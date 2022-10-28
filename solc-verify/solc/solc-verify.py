#!/usr/bin/env python3

import argparse
import re
import subprocess
import os
import threading
import signal
import psutil
import tempfile
import sys
import multiprocessing

# Potential error codes
ERROR_NO_ERROR=0
ERROR_COMPILER=-1
ERROR_SOLVER_NOT_FOUND=-2
ERROR_PROCESS_ERROR=-3
ERROR_PROCESS_TIMEOUT = -4
ERROR_BOOGIE_ERROR=-5
ERROR_VERIFICATION=-6
ERROR_PARTIAL=-7

def kill():
    parent = psutil.Process(os.getpid())
    for child in parent.children(recursive=True):  # or parent.children() for recursive=False
        child.kill()

def findSolver(solver):
    # Name of the solver
    if solver == 'z3': solverExe = 'z3'
    elif solver == 'cvc4': solverExe = 'cvc4'
    else: return None
    # Now, find it in the path
    for path in os.environ["PATH"].split(os.pathsep):
        solverPath = os.path.join(path, solverExe)
        if os.path.isfile(solverPath) and os.access(solverPath, os.X_OK):
            return solverPath
    return None

def yellowTxt(txt):
    return '\033[93m' + txt + '\x1b[0m' if sys.stdout.isatty() else txt

def greenTxt(txt):
    return '\033[92m' + txt + '\x1b[0m' if sys.stdout.isatty() else txt

def redTxt(txt):
    return '\033[91m' + txt + '\x1b[0m' if sys.stdout.isatty() else txt

def blueTxt(txt):
    return '\033[94m' + txt + '\x1b[0m' if sys.stdout.isatty() else txt

# Mapping from status to colors
statusToColor = {
    'OK': greenTxt,
    'INCONCLUSIVE': yellowTxt,
    'TIMEOUT': yellowTxt,
    'SKIPPED': yellowTxt,
    'ERROR': redTxt,
    'UNKNOWN_PROCESS_ERROR': redTxt,
    'UNKNOWN_BOOGIE_ERROR': redTxt,
}

def betterResult(status1, status2):
    if status1 == 'OK':
        return True
    if status1 == 'ERROR':
        return True
    if status2 == 'OK':
        return False
    if status2 == 'ERROR':
        return False
    if status1 == 'INCONCLUSIVE':
        return True
    if status2 == 'INCONCLUSIVE':
        return False
    return True

def parseBoogieOutput(bplFile, verifierOutputStr):
    '''Takes boogie output and returns structured result'''

    # List of issues
    issues = []
    # Name of the verified function
    functionName = None
    # Final result
    result = 'OK'

    # Map results back to .sol file
    outputLines = list(filter(None, verifierOutputStr.split('\n')))
    errors = 0
    inconclusive = 0
    for outputLine, nextOutputLine in zip(outputLines, outputLines[1:]):
        if 'This assertion might not hold.' in outputLine:
            errLine = getRelatedLineFromBpl(outputLine, 0) # Info is in the current line
            issues.append({
                'location': getSourceLineAndCol(errLine),
                'message': getMessage(errLine)
            })
        if 'A postcondition might not hold on this return path.' in outputLine:
            errLine = getRelatedLineFromBpl(nextOutputLine, 0) # Info is in the next line
            issues.append({
                'location': getSourceLineAndCol(errLine),
                'message': getMessage(errLine)
            })
        if 'A precondition for this call might not hold.' in outputLine:
            errLine = getRelatedLineFromBpl(nextOutputLine, 0) # Message is in the next line
            errLinePrev = getRelatedLineFromBpl(outputLine, -1) # Location is in the line before
            issues.append({
                'location': getSourceLineAndCol(errLinePrev),
                'message': getMessage(errLine)
            })
        if 'Verification inconclusive' in outputLine:
            errLine = getRelatedLineFromBpl(outputLine, 0) # Info is in the current line
            issues.append({
                'location': getSourceLineAndCol(errLine),
                'message': 'Inconclusive result'
            })
        if 'This loop invariant might not hold on entry.' in outputLine:
            errLine = getRelatedLineFromBpl(outputLine, 0) # Info is in the current line
            issues.append({
                'location': getSourceLineAndCol(errLine),
                'message': 'Invariant \'' + getMessage(errLine) + '\' might not hold on loop entry'
            })
        if 'This loop invariant might not be maintained by the loop.' in outputLine:
            errLine = getRelatedLineFromBpl(outputLine, 0) # Info is in the current line
            issues.append({
                'location': getSourceLineAndCol(errLine),
                'message': 'Invariant \'' + getMessage(errLine) + '\' might not be maintained by the loop'
            })
        if re.search('Verifying .* \.\.\.', outputLine) is not None:
            if 'error' in nextOutputLine:
                result = 'ERROR'
            elif 'timeout' in nextOutputLine:
                result = 'TIMEOUT'
            elif 'inconclusive' in nextOutputLine:
                result = 'INCONCLUSIVE'
            else:
                result = 'OK'
            functionName = getFunctionName(outputLine.replace('Verifying ', '').replace(' ...',''), bplFile)

    result = {
        'function': functionName,
        'issues': issues,
        'result': result
    }

    return result

def verifyProcedure(arguments):
    # Unpack arguments
    bplFile = arguments['bplFile']
    procedureId = arguments['procedureId']
    args = arguments['args']
    solver = arguments['solver']
    # Run timer
    timer = threading.Timer(args.timeout, kill)
    # Run verification, get result
    timer.start()
    boogieArgs = '/proc:%s /doModSetAnalysis /errorTrace:0 /useArrayTheory /trace /infer:j' % procedureId
    if args.smt_log:
        boogieArgs += ' /proverLog:%s.%s.%s.smt2' % (args.smt_log, procedureId, solver)

    # Solver path
    if args.solver_bin is not None:
        solverPath = args.solver_bin
    else:
        solverPath = findSolver(solver)
    if solverPath is None:
        print(yellowTxt('Error: cannot find %s' % solver))
        return ERROR_SOLVER_NOT_FOUND
    if args.verbose:
       print('Using %s at %s' % (solver, solverPath))

    # Setup solver-specific arguments
    if solver == 'z3':
        boogieArgs += ' /proverOpt:PROVER_PATH=%s' % solverPath
    elif solver == 'cvc4':
        boogieArgs += ' /proverOpt:PROVER_PATH=%s /proverOpt:SOLVER=CVC4 /proverOpt:C:"--incremental --produce-models --quiet"' % solverPath
        if args.arithmetic == 'mod' or args.arithmetic == 'mod-overflow':
            boogieArgs += ' /proverOpt:C:"--decision=justification --no-arrays-eager-index --arrays-eager-lemmas"'
            boogieArgs += ' /proverOpt:LOGIC=QF_AUFDTNIA'

    verifyCommand = args.boogie + ' ' + bplFile + ' ' + boogieArgs
    if args.verbose:
        print(blueTxt('Verifier command: ') + verifyCommand)
    try:
        verifierOutput = subprocess.check_output(verifyCommand, shell = True, stderr=subprocess.STDOUT)
        timer.cancel()
    except subprocess.CalledProcessError as err:
        timer.cancel()
        functionName = getFunctionName(procedureId, bplFile)
        # Timeout is expected
        if err.returncode == -9:
            return (ERROR_NO_ERROR, {
                'function': functionName,
                'result': 'TIMEOUT',
                'issues': []
            })
        # Other errors should be reported
        if args.verbose:
            print(yellowTxt('Error while running verifier, details:'))
            print(blueTxt('----- Verifier output -----'))
            printVerbose(err.output.decode('utf-8'))
            print(blueTxt('---------------------------'))
        return (ERROR_PROCESS_ERROR, {
            'function': functionName,
            'result': 'UNKNOWN_PROCESS_ERROR',
            'issues': []
        })

    verifierOutputStr = verifierOutput.decode('utf-8')
    if re.search('Boogie program verifier finished with', verifierOutputStr) == None:
        print(yellowTxt('Error while running verifier, details:'))
        printVerbose(verifierOutputStr)
        return (ERROR_BOOGIE_ERROR, {
            'function': functionName,
            'result': 'UNKNOWN_BOOGIE_ERROR',
            'issues': []
        })
    elif args.verbose:
        print(blueTxt('----- Verifier output -----'))
        printVerbose(verifierOutputStr)
        print(blueTxt('---------------------------'))

    # Return structure boogie output
    result = parseBoogieOutput(bplFile, verifierOutputStr)
    if args.verbose:
        print(result)

    return (ERROR_NO_ERROR, result)

def verifyAll(bplFile, args):

    if args.solver == 'all':
        solvers = ['z3', 'cvc4']
    else:
        solvers = [args.solver]

    verifyProcedureArgs = []
    procedureRegex = '^procedure(\s+(\{[^\}]*\}))+\s+(?P<procedure_name>[^\(]*)'
    prog = re.compile(procedureRegex)
    with open(bplFile, 'r') as f:
        for line in f.readlines():
            result = prog.match(line)
            if (result):
                procedureId = result.group('procedure_name')
                for solver in solvers:
                    verifyProcedureArgs.append({
                        "bplFile": bplFile,
                        "procedureId": procedureId,
                        "args": args,
                        "solver": solver
                    })
    # Verify
    with multiprocessing.Pool(args.parallel) as p:
       verifierOutputList = p.map(verifyProcedure, verifyProcedureArgs)

    # Join results
    results = {}
    for (code, result) in verifierOutputList:
        functionName = result['function']
        if functionName is not None:
            if functionName in results:
                # If current result is better keep it
                if betterResult(results[functionName]['result'], result['result']):
                    continue
            results[functionName] = {
                'result': result['result'],
                'issues': result['issues']
            }

    return results

def main(tmpDir):

    # Set up argument parser
    parser = argparse.ArgumentParser(description='Verify Solidity smart contracts.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('file', type=str, help='Path to the input file')
    parser.add_argument('--timeout', type=int, help='Timeout (per function) for running Boogie (in seconds)', default=10)
    parser.add_argument('--arithmetic', type=str, help='Encoding used for arithmetic data types and operations in the verifier', default='int', choices=['int', 'bv', 'mod', 'mod-overflow'])
    parser.add_argument('--modifies-analysis', action='store_true', help='Perform modification analysis on state variables')
    parser.add_argument('--event-analysis', action='store_true', help='Perform analysis on emitted events and data changes')
    parser.add_argument('--parallel', type=int, help='How many cores to use', default=multiprocessing.cpu_count())

    parser.add_argument('--output', type=str, help='Output directory for the Boogie program')
    parser.add_argument('--verbose', action='store_true', help='Print all output of the compiler and the verifier')
    parser.add_argument('--smt-log', type=str, help='Log input for the SMT solver')
    parser.add_argument('--errors-only', action='store_true', help='Only display error messages')
    parser.add_argument('--show-warnings', action='store_true', help='Display warnings')

    parser.add_argument('--solc', type=str, help='Solidity compiler to use (with boogie translator)', default=os.path.dirname(os.path.realpath(__file__)) + '/solc')
    parser.add_argument('--boogie', type=str, help='Boogie verifier binary to use', default='boogie')
    parser.add_argument('--solver', type=str, help='SMT solver used by the verifier', default='all', choices=['all', 'z3', 'cvc4'])
    parser.add_argument('--solver-bin', type=str, help='Override the binary of the solver to use')

    args = parser.parse_args()

    solFile = args.file

    # BPL file if requested, otherwise a temporary
    if args.output: outDir = args.output
    else: outDir = tmpDir
    bplFile = outDir + '/' + os.path.basename(solFile) + '.bpl'

    # First convert .sol to .bpl
    solcArgs = ' --boogie %s -o %s --overwrite --boogie-arith %s' % (solFile, outDir, args.arithmetic)
    if args.modifies_analysis:
        solcArgs += ' --boogie-mod-analysis'
    if args.event_analysis:
        solcArgs += ' --boogie-event-analysis'
    convertCommand = args.solc + ' ' + solcArgs
    if args.verbose:
        print(blueTxt('Solc command: ') + convertCommand)
    compilerOutputStr = ''
    try:
        compilerOutput = subprocess.check_output(convertCommand, shell = True, stderr=subprocess.STDOUT)
        compilerOutputStr = compilerOutput.decode('utf-8', 'ignore')
        if args.verbose:
            print(blueTxt('----- Compiler output -----'))
            printVerbose(compilerOutputStr)
            print(blueTxt('---------------------------'))
    except subprocess.CalledProcessError as err:
        compilerOutputStr = err.output.decode('utf-8')
        print(yellowTxt('Error while running compiler, details:'))
        printVerbose(compilerOutputStr)
        return ERROR_COMPILER

    # Print warnings if requested
    warnings = 0
    compilerOutputLines = compilerOutputStr.split('\n')
    compilerOutputLines.append("") # Add extra empty line due to iteration with next line
    for line, nextLine in zip(compilerOutputLines, compilerOutputLines[1:]):
        # Ignore pre-release warnings
        if line == 'Warning: This is a pre-release compiler version, please do not use it in production.': continue
        # Other warnings should be printed
        if 'Warning: ' in line or 'solc-verify warning: ' in line:
            warnings += 1
            if args.show_warnings:
                # For compiler warnings, source location is in next line
                if 'Warning: ' in line and nextLine.lstrip().startswith('--> '):
                    line = nextLine.lstrip().replace('--> ', '') + ' ' + line
                line = line.replace('Warning: ', yellowTxt('Warning') + ': ')
                line = line.replace('solc-verify warning: ', yellowTxt('solc-verify warning') + ': ')
                print(line)
        # Also print errors (this can only be intra-function errors)
        if 'solc-verify error: ' in line:
            if args.show_warnings:
                line = line.replace('solc-verify error: ', redTxt('solc-verify error') + ': ')
                print(line)

    # Map results back to .sol file
    skipped = 0
    errors = 0
    inconclusive = 0

    # Run verification
    verifierResults = verifyAll(bplFile, args)

    # Collect all the skipped functions
    for line in open(bplFile).readlines():
        if line.startswith('procedure ') and '{:skipped}' in line:
            verifierResults[getMessage(line)] = {
                'result': 'SKIPPED',
                'message': 'SKIPPED'
            }

    prefix = '' if args.errors_only else ' - '
    for function, result in verifierResults.items():
        result_type = result['result']
        color = statusToColor[result_type]
        # Check result type
        if result_type == 'ERROR':
            errors = errors + 1
        elif result_type == 'INCONCLUSIVE':
            inconclusive = inconclusive + 1
        elif result_type == 'TIMEOUT':
            inconclusive = inconclusive + 1
        elif result_type == 'SKIPPED':
            skipped = skipped + 1
        elif result_type == 'OK':
            color = greenTxt
        print(function + ': ' + color(result_type))
        if 'issues' in result:
            for issue in result['issues']:
                location = issue['location']
                locationStr = '%s:%s:%s' % (location['file'], location['row'], location['column'])
                print(prefix + locationStr + ': ' + issue['message'])

    # Warnings
    if warnings > 0 and not args.show_warnings:
        print(yellowTxt('Use --show-warnings to see %d warning%s.' % (warnings, '' if warnings == 1 else 's')))
    if inconclusive > 0:
        print(yellowTxt('Inconclusive results.'))
    if skipped > 0 and not args.show_warnings:
        print(yellowTxt('Some functions were skipped. Use --show-warnings to see details.'))

    # Final result
    if errors == 0:
        print(greenTxt('No errors found.'))
        if inconclusive > 0 or skipped > 0: return ERROR_PARTIAL
        return ERROR_NO_ERROR
    else:
        print(redTxt('Errors were found by the verifier.'))
        return ERROR_VERIFICATION

def printVerbose(txt):
    txt = txt.replace('Warning: ', yellowTxt('Warning') + ': ')
    txt = txt.replace('Error: ', yellowTxt('Error') + ': ')
    txt = txt.replace('solc-verify error: ', yellowTxt('solc-verify error') + ': ')
    txt = txt.replace('solc-verify warning: ', yellowTxt('solc-verify warning') + ': ')
    txt = txt.replace(']  error', ']  ' + redTxt('error'))
    txt = txt.replace(']  verified', ']  ' + greenTxt('verified'))
    print(txt)

# Gets the line related to an error in the output
def getRelatedLineFromBpl(outputLine, offset):
    # Errors have the format 'filename(line,col): Message'
    errFileLineCol = outputLine.split(':')[0]
    errFile = errFileLineCol[:errFileLineCol.rfind('(')]
    errLineNo = int(errFileLineCol[errFileLineCol.rfind('(')+1:errFileLineCol.rfind(',')]) - 1
    return open(errFile).readlines()[errLineNo + offset]

# Gets the original (.sol) line and column number from an annotated line in the .bpl
def getSourceLineAndCol(line):
    match = re.search('{:sourceloc \"([^}]*)\", (\\d+), (\\d+)}', line)
    if match is None:
        return None
    else:
        return {
            'file': match.group(1),
            'row': match.group(2),
            'column': match.group(3)
        }

# Gets the message from an annotated line in the .bpl
def getMessage(line):
    match = re.search('{:message \"([^}]*)\"}', line)
    if match is None:
        return '[No message found for error]'
    else:
        return match.group(1)

def getFunctionName(boogieName, bplFile):
    for line in open(bplFile).readlines():
        if line.startswith('procedure ') and boogieName in line:
            return getMessage(line)
    return '[Unknown function]'

if __name__== '__main__':
    with tempfile.TemporaryDirectory() as tmpDir:
        ret = main(tmpDir)
    sys.exit(ret)
