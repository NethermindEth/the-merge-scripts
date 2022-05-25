#!/bin/bash

#For bash errors
set -eo pipefail

OS=$1

if [ $OS = "linux" ] then # ubuntu/debian really, //TODO: freebsd, openbsd
    sudo apt install curl gnupg
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
    sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
    apt update && sudo apt install bazel
    # install screen cmd
    apt install screen
elif [ $OS = "darwin" ] then
    # check if brew is installed
    out="$(which brew)" 
    REGEX_PATH='^\/[a-z0-9A-Z]*(\/[a-z0-9A-Z]*)*'
    if ! [[ $out =~ $REGEX_PATH ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install bazel
else
    echo "OS not supported"
    exit 1
fi

git clone -b develop https://github.com/prysmaticlabs/prysm.git
cd prysm
bazel build //beacon-chain:beacon-chain
cd ..