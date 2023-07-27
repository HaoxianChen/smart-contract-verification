#!/usr/bin/python3

import threading
import subprocess
import time
import sys
from multiprocessing import Pool

all_contracts = [
        "wallet.sol",
        "crowFunding.sol",
        # "erc20.sol",
        # "erc721.sol",
        # "erc777.sol",
        # "erc1155.sol",
        "paymentSplitter.sol",
        "vestingWallet.sol",
        "voting.sol",
        "auction.sol",
        "ltcSwapAsset.sol",
        "tether.sol", 
        "bnb.sol",
        "linktoken.sol", 
        "matic.sol",
        "shib.sol", 
        "theta.sol",
        "wbtc.sol",
        # "controllable.sol",
        # "tokenPartition.sol"
        ]

def test(contract_name, _bin, timeout, benchmark_dir, out_dir):
    _n = contract_name.split(".")[0]+".log"
    outfile = "%s/%s" % (out_dir, _n)
    contract = "%s/%s" %(benchmark_dir, contract_name)
    cmd = [_bin, "-solc", "0.5.11","-input", contract, "-verify_timeout", str(timeout), "assert"]
    print(" ".join(cmd))
    with open(outfile,'w') as f:
        start = time.time()
        try:
            process = subprocess.call(cmd,stderr=f,stdout=f,timeout=timeout+20)
        except subprocess.TimeoutExpired:
            # print ("Time: timeout after %ds." % timeout)
            f.write("Timeout after %ds." % timeout)
            
        elapsed = time.time() - start
        print("%s, %fs." % (contract_name, elapsed)) 
        f.write("\nTime: %fs." % (elapsed))

if __name__ == '__main__':
    all_threads = []
    _bin = "./main.native"
    timeout = int(sys.argv[1])
    nthreads = int(sys.argv[2])
    benchmark_dir = sys.argv[3]
    out_dir = sys.argv[4]

    def f(_c):
        test(_c,_bin,timeout,benchmark_dir,out_dir)

    with Pool(nthreads) as p:
        p.map(f,all_contracts)
