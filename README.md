# Artifact for Safety Verification of Declarative Smart Contracts

This artifact contains the benchmarks, binaries, and scripts to reproduce the 
the experimental results of the corresponding paper (Table 2).

## EXPERIMENT RUNTIME
The expected runtime is 11 hours with single thread, 
and 1.5 hour with 10 threads.

## REPRODUCIBILITY INSTRUCTIONS

The results reported in Table 2 in the paper is collected from a server
with 125GB memory. Smaller memory size may impact the run time of verification 
tasks.

1. Download and extract the artifact file
2. `` cd dcv-tacas23-artifcat ``
3. Install dependent software from local packages: ``sudo ./install.sh `` 
This only needs to run once.
4. Set environment variables: ``source ./setup.sh``. This needs to be 
run on every reboot.
5. Run all experiments: `` ./run.sh 3600 1``
The first parameter is the timeout (in seconds), 
    the second parameter is the thread, which should be the minimum
    of 10 and the number of idle CPU threads on the machine.

The results are written to the ``output`` directory,
which has sub-directories ``dcv``, ``solc/reference``, ``solc/decon``, 
``solc-verify/reference``, and ``solc-verify/decon``.
Each directory contains the results for the corresponding columns in Table 2.
The verifier output and verification time for each benchmark contract
is written to a separate log file.

## Expected output

For DCV output, it is expected to have all benchmark verification results
returning ``Init: UNSATISFIABLE`` and ``Tr: UNSATISFIABLE``,
which means the safety verification is successful.

For solc, the output could be one of the following:
* ``Warning: CHC: Assertion violation might happen here.``,
which means that it cannot verify the assertion,
which is the unknown in Table 2.
* If its time exceeds the timeout parameter, it is marked as timeout in Table 2.
* Some may return
``Warning: CHC: Error trying to invoke SMT solver``,
which is reported as error in Table 2.
* Otherwise, the verification succeeds, and the time is reported in Table 2.

For solc-verify, the output could be one of the following:
* ``Invariant [...] might not hold when entering function.``
This also means the assertion cannot be verified,
and is reported as unknown in Table 2.
* Similarly, time exceeding timeout parameter would be reported as timeout
instead.
* Some contracts may return ``solc-verify error: [...]``, with errors are caused by 
encountering unsupported language features.
These results are are reported as error in Table 2.
* Otherwise, the verification succeeds, and the time is reported in Table 2.



