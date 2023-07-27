#!/usr/bin/python3

import threading
import subprocess
import time
import sys

all_contracts = [
        "auction.sol",
        "erc721.sol","token.sol",
        "wallet.sol",
        "crowFunding.sol",
        "erc777-simplified.sol",
        "vestingWallet-simplified.sol",
        "erc1155.sol",
        "paymentSplitter-simplified.sol",
        "voting.sol"
        ]

def test(contract, _bin, timeout):
    outfile = contract.split(".")[0]+".log"
    cmd = [_bin, "--model-checker-engine", "chc",
          "--model-checker-show-unproved",
          "--model-checker-timeout", str(timeout*1000),
          "--base-path", "./",
          "--include-path", "node_modules",
          contract]
    print(" ".join(cmd))
    with open(outfile,'w') as f:
        start = time.time()
        try:
            process = subprocess.call(cmd,stderr=f,timeout=timeout+20)
        except subprocess.TimeoutExpired:
            # print ("Time: timeout after %ds." % timeout)
            f.write("Timeout after %ds." % timeout)
            
        elapsed = time.time() - start
        print("%s, %fs." % (contract, elapsed)) 
        f.write("\nTime: %fs." % (elapsed))

if __name__ == '__main__':
    all_threads = []
    _bin = sys.argv[1]
    timeout = int(sys.argv[2])
    for c in all_contracts:
        t = threading.Thread(target=test, args=(c,_bin,timeout))
        t.start()
        all_threads.append(t)

    for t in all_threads:
        t.join()



