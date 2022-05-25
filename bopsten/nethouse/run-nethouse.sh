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
        --JsonRpc.Host=0.0.0.0 
        --JsonRpc.JwtSecretFile=/tmp/jwtsecret
        --Metrics.Enabled=${NETHERMIND_METRICSCONFIG_ENABLED}
        --Metrics.NodeName="Nethouse Bopsten Beacon Chain"
        --Metrics.PushGatewayUrl=${NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL:-""}
        --Seq.MinLevel=${NETHERMIND_SEQCONFIG_MINLEVEL}
        --Seq.ServerUrl=${NETHERMIND_SEQCONFIG_SERVERURL}
        --Seq.ApiKey=${NETHERMIND_SEQCONFIG_APIKEY:-""}
    network_mode: host

  lighthouse:
    image: sigp/lighthouse:latest-unstable
    container_name: lighthouse_beacon
    restart: unless-stopped
    volumes:
        - ./beacon_data:/testnet-lh1
        - /tmp/jwtsecret:/tmp/jwtsecret
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
NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL=$PUSH_GATEWAY_URL
NETHERMIND_SEQCONFIG_MINLEVEL=Info
NETHERMIND_SEQCONFIG_SERVERURL=https://seq.nethermind.io
NETHERMIND_SEQCONFIG_APIKEY=$SEQ_API_KEY
' > ~/.env

docker-compose -f docker-compose.nethouse.yml up -d nethermind lighthouse