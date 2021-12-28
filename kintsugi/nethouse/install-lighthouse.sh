#!/bin/bash

#For bash errors
set -eo pipefail

git clone -b unstable https://github.com/sigp/lighthouse.git
cd lighthouse
make