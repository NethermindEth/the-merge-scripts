#!/bin/bash

#For bash errors
set -eo pipefail

consensus_engine=$1

cd ~

# generate jwt secret
openssl rand -hex 32 | tr -d "\n" > "/tmp/jwtsecret"

mkdir ~/beacon_data
chmod 747 ~/beacon_data

case $consensus_engine in
    nimbus)
        echo "Running nethbus"
        ~/the-merge-scripts/bopsten/nethbus/run-nethbus.sh
        ;;
    teku)
        echo "Running nethku"
         ~/the-merge-scripts/bopsten/nethku/run-nethku.sh
        ;;
    lighthouse)
        echo "Running nethouse"
         ~/the-merge-scripts/bopsten/nethouse/run-nethouse.sh
        ;;
    lodestar)
        echo "Running nethstar"
         ~/the-merge-scripts/bopsten/nethstar/run-nethstar.sh
        ;;
    prysm)
        echo "Running nethysm"
         ~/the-merge-scripts/bopsten/nethysm/run-nethysm.sh
        ;;
    *)
        echo "Unknown consensus engine: $consensus_engine"
        exit 5
        ;;
esac
