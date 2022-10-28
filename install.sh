#!/usr/bin/bash

# Install packages
dpkg -i packages/*.deb
pip3 install packages/*.whl

# Setup solc-verify
cp solc-verify/cvc4 /usr/local/bin
chmod a+x /usr/local/bin/cvc4
