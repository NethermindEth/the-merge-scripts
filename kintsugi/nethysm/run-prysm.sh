#!/usr/bin/env bash

#For bash errors
set -eo pipefail

#update merge-testnets
cd ~/merge-testnets
git fetch && git pull

#update nethermind
cd ~/nethermind/src/Nethermind
git fetch && git pull
dotnet build Nethermind.sln -c Release

#update prysm
cd ~/prysm
git fetch && git pull
bazel build //beacon-chain:beacon-chain

# Use screen to manage multiple terminals https://linuxize.com/post/how-to-use-linux-screen/
