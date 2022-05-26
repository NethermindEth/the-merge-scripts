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
        --Merge.TerminalTotalDifficulty 20000000000000
        --Metrics.Enabled=${NETHERMIND_METRICSCONFIG_ENABLED}
        --Metrics.NodeName="Nethku Bopsten Beacon Chain"
        --Metrics.PushGatewayUrl=${NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL:-""}
        --Seq.MinLevel=${NETHERMIND_SEQCONFIG_MINLEVEL}
        --Seq.ServerUrl=${NETHERMIND_SEQCONFIG_SERVERURL}
        --Seq.ApiKey=${NETHERMIND_SEQCONFIG_APIKEY:-""}
    network_mode: host

  teku:
    image: consensys/teku:develop
    container_name: teku_beacon
    restart: unless-stopped
    volumes:
        - ./beacon_data:/datadir-teku
        - /tmp/jwtsecret:/tmp/jwtsecret
    command: |
        --data-path "datadir-teku"  
        --network ropsten
        --ee-endpoint http://localhost:8551
        --ee-jwt-secret-file "/tmp/jwtsecret"
        --log-destination console
        --Xnetwork-total-terminal-difficulty-override=20000000000000
    network_mode: host
' > ~/docker-compose.nethku.yml

echo '
NETHERMIND_METRICSCONFIG_ENABLED=true
NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL=$PUSH_GATEWAY_URL
NETHERMIND_SEQCONFIG_MINLEVEL=Info
NETHERMIND_SEQCONFIG_SERVERURL=https://seq.nethermind.io
NETHERMIND_SEQCONFIG_APIKEY=$SEQ_API_KEY
' > ~/.env

docker-compose -f docker-compose.nethku.yml up -d nethermind teku
