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
        --Metrics.Enabled=${NETHERMIND_METRICSCONFIG_ENABLED}
        --Metrics.NodeName="Nethysm Bopsten Beacon Chain"
        --Metrics.PushGatewayUrl=${NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL:-""}
        --Seq.MinLevel=${NETHERMIND_SEQCONFIG_MINLEVEL}
        --Seq.ServerUrl=${NETHERMIND_SEQCONFIG_SERVERURL}
        --Seq.ApiKey=${NETHERMIND_SEQCONFIG_APIKEY:-""}
    network_mode: host

  prysm:
    image: gcr.io/prysmaticlabs/prysm/beacon-chain:latest,gcr.io/prysmaticlabs/prysm/validator:latest
    container_name: prysm_beacon
    restart: unless-stopped
    volumes:
        - ./beacon_data:/prysm-beacondata
        - /tmp/jwtsecret:/tmp/jwtsecret
    command: |
        --ropsten
        --datadir prysm-beacondata
        --http-web3provider=http://localhost:8551
        --bootstrap-node=enr:-Iq4QMCTfIMXnow27baRUb35Q8iiFHSIDBJh6hQM5Axohhf4b6Kr_cOCu0htQ5WvVqKvFgY28893DHAg8gnBAXsAVqmGAX53x8JggmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk
        --jwt-secret=/tmp/jwtsecret
    network_mode: host
' > ~/docker-compose.nethysm.yml

echo '
NETHERMIND_METRICSCONFIG_ENABLED=true
NETHERMIND_METRICSCONFIG_PUSHGATEWAYURL=$PUSH_GATEWAY_URL
NETHERMIND_SEQCONFIG_MINLEVEL=Info
NETHERMIND_SEQCONFIG_SERVERURL=https://seq.nethermind.io
NETHERMIND_SEQCONFIG_APIKEY=$SEQ_API_KEY
' > ~/.env

docker-compose -f docker-compose.nethysm.yml up -d nethermind prysm