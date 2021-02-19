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



#### brownie ###

crytic-compile . --compile-force-framework Brownie

if [ $? -ne 0 ]
then
    echo "Brownie test failed"
    exit 255
fi


yarn --version || exit 0

nvm use 12 
# start testing eth-saddle for CI purposes 
npm install --global eth-saddle
# install the repo
yarn
# CI dependency injection
yarn add --dev "https://github.com/sc-forks/solidity-coverage.git#$COMMIT_REF"
# load package 
cat package.json
# run commands 
yarn run coverage
