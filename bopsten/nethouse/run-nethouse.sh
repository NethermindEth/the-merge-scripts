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

  lighthouse:
    image: sigp/lighthouse:latest-unstable
    container_name: lighthouse_beacon
    volumes:
        - ./beacon_data:/testnet-lh1
    command: |
        lighthouse 
        --spec mainnet 
        --network ropsten 
        --debug-level info 
        beacon_node 
        --datadir ./testnet-lh1 
        --eth1 
        --http 
        --http-allow-sync-stalled 
        --metrics 
        --merge  
        --enr-udp-port=9000
        --enr-tcp-port=9000 
        --discovery-port=9000
        --execution-endpoints http://127.0.0.1:8551
        --jwt-secrets="/tmp/jwtsecret"
    network_mode: host
' > ~/docker-compose.nethouse.yml

echo '
NETHERMIND_METRICSCONFIG_ENABLED=true
NETHERMIND_METRICSCONFIG_NODENAME="Nethku Bopsten Beacon Chain"
NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL=$PUSH_GATEWAY_URL
NETHERMIND_SEQCONFIG_MINLEVEL=Info
NETHERMIND_SEQCONFIG_SERVERURL=https://seq.nethermind.io
NETHERMIND_SEQCONFIG_APIKEY=$SEQ_API_KEY
' > ~/.env

docker-compose -f docker-compose.nethouse.yml up -d nethermind lighthouse