#!/bin/bash

#For bash errors
set -eo pipefail

git clone https://github.com/chainsafe/lodestar.git
cd lodestar
yarn install --ignore-optional
yarn run build