#!/usr/bin/env bash

#For bash errors
set -eo pipefail

cd ~

echo '
version: "3.4"
services:

  nethermind:
    image: nethermindeth/nethermind:ropsten
    container_name: nethermind_ropsten
    volumes:
      - ./execution_data:/execution_data
    command: |
        --config ropsten 
        --JsonRpc.Host=0.0.0.0 
        --JsonRpc.JwtSecretFile=/tmp/jwtsecret
        --Metrics.Enabled=${NETHERMIND_METRICSCONFIG_ENABLED}
        --Metrics.NodeName=${NETHERMIND_METRICSCONFIG_NODENAME}
        --Metrics.PushGatewayUrl=${NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL:-""}
        --Seq.MinLevel=${NETHERMIND_SEQCONFIG_MINLEVEL}
        --Seq.ServerUrl=${NETHERMIND_SEQCONFIG_SERVERURL}
        --Seq.ApiKey=${NETHERMIND_SEQCONFIG_APIKEY:-""}
    network_mode: host

  lodestar:
    image: chainsafe/lodestar:next
    container_name: lodestar_beacon
    volumes:
        - ./beacon_data:/lodestar-beacondata
    command: |
        beacon 
        --rootDir="../lodestar-beacondata"
        --network ropsten 
        --eth1.enabled=true
        --execution.urls="http://127.0.0.1:8551"
        --network.connectToDiscv5Bootnodes
        --network.discv5.enabled=true
        --jwt-secret="/tmp/jwtsecret"
        --network.discv5.bootEnrs="enr:-Iq4QMCTfIMXnow27baRUb35Q8iiFHSIDBJh6hQM5Axohhf4b6Kr_cOCu0htQ5WvVqKvFgY28893DHAg8gnBAXsAVqmGAX53x8JggmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk"
    network_mode: host
' > ~/docker-compose.nethstar.yml

echo '
NETHERMIND_METRICSCONFIG_ENABLED=true
NETHERMIND_METRICSCONFIG_NODENAME="Nethku Bopsten Beacon Chain"
NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL=$PUSH_GATEWAY_URL
NETHERMIND_SEQCONFIG_MINLEVEL=Info
NETHERMIND_SEQCONFIG_SERVERURL=https://seq.nethermind.io
NETHERMIND_SEQCONFIG_APIKEY=$SEQ_API_KEY
' > ~/.env

docker-compose -f docker-compose.nethstar.yml up -d nethermind lodestar