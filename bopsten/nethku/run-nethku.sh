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

  teku:
    image: consensys/teku:develop
    container_name: teku_beacon
    volumes:
        - ./beacon_data:/datadir-teku
    command: |
        --data-path "datadir-teku"  
        --network ropsten
        --ee-endpoint http://localhost:8551
        --ee-jwt-secret-file "/tmp/jwtsecret"
        --log-destination console
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

docker-compose -f docker-compose.nethbus.yml up -d nethermind teku


 "Metrics": {
    "NodeName": "Nethermind Ropsten Beacon Chain 1",
    "Enabled": true,
    "PushGatewayUrl": "http://94.237.52.161:9000/metrics/nethermind-iudiy4raagaizaih1phuaShekighoJ2ixaecahvii7ohte3oozeeh0eTh7Aich1Shee9ceetuy3iGhexoh5naithoot8rebi7fee",
    "IntervalSeconds": 5
  },
  "Seq": {
    "MinLevel": "Info",
    "ServerUrl": "https://seq.nethermind.io",
    "ApiKey": "pAOZejN5FvcTwEMguifK"
  },