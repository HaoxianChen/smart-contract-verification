#!/usr/bin/bash

TIMEOUT=$1
NTHREADS=$2
echo "timeout: $TIMEOUT seconds"
echo "threads: $NTHREADS"

# Run DCV
mkdir -p output/dcv
cd dcv && python3 check-all.py ../output/dcv && cd ..

# Run solc-verify
mkdir -p output/solc-verify/reference
mkdir -p output/solc-verify/decon
cd solc-verify 
python3 check-all.py $TIMEOUT $NTHREADS solidity ../output/solc-verify/reference 
python3 check-all.py $TIMEOUT $NTHREADS dsc-instrument ../output/solc-verify/decon
cd ..

# Run solc
mkdir -p output/solc/reference
mkdir -p output/solc/decon
cd solc-smt 
python3 check-all.py $TIMEOUT $NTHREADS solidity ../output/solc/reference 
python3 check-all.py $TIMEOUT $NTHREADS dsc-instrument ../output/solc/decon
cd ..

