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
        --Metrics.PushGatewayUrl=${NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL}
        --Seq.MinLevel=${NETHERMIND_SEQCONFIG_MINLEVEL}
        --Seq.ServerUrl=${NETHERMIND_SEQCONFIG_SERVERURL}
        --Seq.ApiKey=${NETHERMIND_SEQCONFIG_APIKEY}
    network_mode: host

  nimbus:
    image: statusim/nimbus-eth2:multiarch-v22.5.1
    container_name: nimbus_beacon
    volumes:
        - ./beacon_data:/nimbus-beacondata 
    command: |
         --network=ropsten 
         --web3-url=http://127.0.0.1:8551 
         --log-level=DEBUG
         --rest 
         --data-dir=nimbus-beacondata
         --metrics
         --jwt-secret="/tmp/jwtsecret"
    network_mode: host
' > ~/docker-compose.nethbus.yml

echo '
NETHERMIND_METRICSCONFIG_ENABLED=true
NETHERMIND_METRICSCONFIG_NODENAME="Nethku Bopsten Beacon Chain"
NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL=$PUSH_GATEWAY_URL
NETHERMIND_SEQCONFIG_MINLEVEL=Info
NETHERMIND_SEQCONFIG_SERVERURL=https://seq.nethermind.io
NETHERMIND_SEQCONFIG_APIKEY=$SEQ_API_KEY
' > ~/.env

docker-compose -f docker-compose.nethbus.yml up -d nethermind nimbus