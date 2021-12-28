#!/bin/bash

#For bash errors
set -eo pipefail

consensus_engine=$1
consensus_tag=$2
nethermind_tag=$3
install=$4

OS=uname -s | tr 'A-Z' 'a-z'
ARCH=uname -m | tr 'A-Z' 'a-z'

cd ~
if [ $install = y ]; then
    echo "Installing $consensus_engine"
    case $consensus_engine in
        nimbus)
        ;;
        teku)
        ;;
        lighthouse)
        ;;
        lodestar)
        ;;
        prysm)
        kintsugi/prysm/install-prysm.sh OS
        ;;
    esac
fi

echo "consensus_engine: $consensus_engine, nethermind_tag: $nethermind_tag, consensus_tag: $consensus_tag"