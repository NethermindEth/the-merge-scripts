#!/bin/bash

#For bash errors
set -eo pipefail

consensus_engine=$1
directory=$2

cd $directory

# generate jwt secret
openssl rand -hex 32 | tr -d "\n" > "/tmp/jwtsecret"

mkdir -p $directory/beacon_data
chmod 747 $directory/beacon_data

case $consensus_engine in
    nimbus)
        echo "Running nethbus"
        $directory/the-merge-scripts/bopsten/nethbus/run-nethbus.sh $directory
        ;;
    teku)
        echo "Running nethku"
         $directory/the-merge-scripts/bopsten/nethku/run-nethku.sh $directory
        ;;
    lighthouse)
        echo "Running nethouse"
         $directory/the-merge-scripts/bopsten/nethouse/run-nethouse.sh $directory
        ;;
    lodestar)
        echo "Running nethstar"
         $directory/the-merge-scripts/bopsten/nethstar/run-nethstar.sh $directory
        ;;
    prysm)
        echo "Running nethysm"
         $directory/the-merge-scripts/bopsten/nethysm/run-nethysm.sh $directory
        ;;
    *)
        echo "Unknown consensus engine: $consensus_engine"
        exit 5
        ;;
esac
