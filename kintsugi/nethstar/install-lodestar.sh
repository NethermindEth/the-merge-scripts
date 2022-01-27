#!/bin/bash

#For bash errors
set -eo pipefail

# npm
apt install -y npm

# upgrade node
npm install -g n
n 15.0.1

# yarn 
npm install --global yarn

git clone https://github.com/chainsafe/lodestar.git
cd lodestar
yarn install --ignore-optional
yarn run build