#!/usr/bin/env bash

#For bash errors
set -eo pipefail

cd ~

echo '
version: "3.4"
services:

  nethermind:
    image: nethermindeth/nethermind:bopsten
    container_name: nethermind_bopsten
    restart: unless-stopped
    volumes:
      - ./execution_data:/execution_data
      - /tmp/jwtsecret:/tmp/jwtsecret
    command: |
        --config ropsten 
        --datadir="/execution_data"
        --JsonRpc.Host=0.0.0.0 
        --JsonRpc.JwtSecretFile=/tmp/jwtsecret
        --Merge.TerminalTotalDifficulty 100000000000000000000000
        --Metrics.Enabled=${NETHERMIND_METRICSCONFIG_ENABLED}
        --Metrics.NodeName="Nethbus Bopsten Beacon Chain"
        --Metrics.PushGatewayUrl=${NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL:-""}
        --Seq.MinLevel=${NETHERMIND_SEQCONFIG_MINLEVEL}
        --Seq.ServerUrl=${NETHERMIND_SEQCONFIG_SERVERURL}
        --Seq.ApiKey=${NETHERMIND_SEQCONFIG_APIKEY:-""}
    network_mode: host

  nimbus:
    image: statusim/nimbus-eth2:multiarch-v22.5.1
    container_name: nimbus_beacon
    restart: unless-stopped
    volumes:
        - ./beacon_data:/home/user/.cache/nimbus/BeaconNode
        - /tmp/jwtsecret:/tmp/jwtsecret
    command: |
         --network=ropsten
         --web3-url=http://127.0.0.1:8551 
         --log-level=DEBUG
         --rest 
         --metrics
         --jwt-secret="/tmp/jwtsecret"
         --terminal-total-difficulty-override=100000000000000000000000
    network_mode: host
' > ~/docker-compose.nethbus.yml

echo '
NETHERMIND_METRICSCONFIG_ENABLED=true
NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL=$PUSH_GATEWAY_URL
NETHERMIND_SEQCONFIG_MINLEVEL=Info
NETHERMIND_SEQCONFIG_SERVERURL=https://seq.nethermind.io
NETHERMIND_SEQCONFIG_APIKEY=$SEQ_API_KEY
' > ~/.env

docker-compose -f docker-compose.nethbus.yml up -d nethermind nimbus