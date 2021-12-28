#!/bin/bash

#For bash errors
set -eo pipefail

OS=$1

if [ $OS = "linux" ] then # ubuntu really, //TODO: freebsd, openbsd
    sudo apt install curl gnupg
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
    sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
    apt update && sudo apt install bazel
elif [ $OS = "darwin" ] then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install bazel
fi

git clone -b kintsugi https://github.com/prysmaticlabs/prysm.git
cd prysm
bazel build //beacon-chain:beacon-chain