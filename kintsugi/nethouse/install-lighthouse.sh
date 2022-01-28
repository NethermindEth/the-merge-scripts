#!/bin/bash

#For bash errors
set -eo pipefail

# Install latest version of Rust and include in PATH
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Clone and make Lighthouse
git clone -b unstable https://github.com/sigp/lighthouse.git
cd lighthouse
make
