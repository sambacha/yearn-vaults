#!/bin/bash

# disable reporting as a CI
export CI=''

# configure `locales`
export LC_ALL=C

# TODO - trigger 'exit' instead
set -o errexit

# ensure CI enviornment
yarn --version || exit 0

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
