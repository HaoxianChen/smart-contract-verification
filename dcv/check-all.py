#!/usr/bin/python3

# import threading
import subprocess
import time
import sys

JAR = "declarative-smart-contract-assembly-0.1.0-SNAPSHOT.jar"
benchmark_dir = "benchmarks"
all_contracts = [
        # "erc1155.dl",
        # "erc777.dl",
        # "paymentSplitter.dl",
        # "crowFunding.dl",
        # "erc20.dl",
        # "nft.dl",
        # "vestingWallet.dl",
        # "wallet.dl",
        # "voting.dl",
        "auction.dl",
        # New benchmarks
        # "ltcSwapAsset.dl",
        # "tether.dl", 
        # "bnb.dl",
        # "linktoken.dl", 
        # "matic.dl",
        # "shib.dl", 
        # "theta.dl",
        # "wbtc.dl",
        # "controllable.dl",
        # "tokenPartition.dl"
        ]

def test(contract_dir, contract_name, out_dir):
    contract = "%s/%s" % (contract_dir, contract_name)
    cmd = ["scala", JAR, "verify", contract]
    # print(" ".join(cmd))
    print("Verifying %s" % contract_name)

    n = contract_name.split(".")[0]+".log"
    outfile = "%s/%s" % (out_dir, n)
    with open(outfile, 'w') as f:
        start = time.time()
        process = subprocess.call(cmd, stdout=f)
        elapsed = time.time() - start
        print("%s, %fs." % (contract_name, elapsed)) 
        f.write("time: %fs." % elapsed)

if __name__ == '__main__':
    out_dir = sys.argv[1]

    for c in all_contracts:
        test(benchmark_dir, c, out_dir)

