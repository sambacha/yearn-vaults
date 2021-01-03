#!/bin/bash
# SPDX-License-Identifier: ISC

# version: v0.1.0
set -o errexit
# export env
export CI=''
export LC_ALL=C
# ensure CI enviornment


#### truffle ####
crytic-compile . --compile-remove-metadata
if [ $? -ne 0 ]
then
    echo "Truffle test failed"
    exit 255
fi

# docker pull trailofbits/solc-select

