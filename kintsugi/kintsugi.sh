#!/bin/bash

#For bash errors
set -eo pipefail

consensus_engine=$1
consensus_tag=$2
nethermind_tag=$3
install=$4

OS=$(uname -s | tr 'A-Z' 'a-z')
ARCH=$(uname -m | tr 'A-Z' 'a-z')

cd ~
if [ $install = y ]; then
    echo "Installing $consensus_engine"
    case $consensus_engine in
        nimbus)
        echo "Installing nimbus"
        the-merge-scripts/kintsugi/nethbus/install-nimbus.sh
        ;;
        teku)
        echo "Installing teku"
        the-merge-scripts/kintsugi/nethku/install-teku.sh
        ;;
        lighthouse)
        echo "Installing lighthouse"
        the-merge-scripts/kintsugi/nethouse/install-lighthouse.sh
        ;;
        lodestar)
        echo "Installing lodestar"
        the-merge-scripts/kintsugi/nethstar/install-lodestar.sh
        ;;
        prysm)
        echo "Installing prysm"
        the-merge-scripts/kintsugi/nethysm/install-prysm.sh $OS
        ;;
        *)
        echo "Unknown consensus engine: $consensus_engine"
        exit 5
        ;;
    esac
fi

case $consensus_engine in
    nimbus)
        echo "Running nethbus"
        ~/the-merge-scripts/kintsugi/nethbus/run-nethbus.sh $OS $ARCH $consensus_tag $nethermind_tag
        ;;
    teku)
        echo "Running nethku"
         ~/the-merge-scripts/kintsugi/nethku/run-nethku.sh $OS $ARCH $consensus_tag $nethermind_tag
        ;;
    lighthouse)
        echo "Running nethouse"
         ~/the-merge-scripts/kintsugi/nethouse/run-nethouse.sh $OS $ARCH $consensus_tag $nethermind_tag
        ;;
    lodestar)
        echo "Running nethstar"
         ~/the-merge-scripts/kintsugi/nethstar/run-nethstar.sh
        ;;
    prysm)
        echo "Running nethysm"
         ~/the-merge-scripts/kintsugi/nethysm/run-nethysm.sh
        ;;
    *)
        echo "Unknown consensus engine: $consensus_engine"
        exit 5
        ;;
esac
