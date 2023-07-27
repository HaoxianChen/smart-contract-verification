#!/bin/bash

~/projects/solc-macos \
  --model-checker-engine chc  \
  --model-checker-solvers all \
  --model-checker-show-unproved \
  --model-checker-targets assert \
  --model-checker-timeout 200000 \
  --base-path "./" --include-path "node_modules" \
  $1
