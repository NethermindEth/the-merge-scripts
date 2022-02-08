#!/usr/bin/env bash

#For bash errors
set -eo pipefail

OS=$1
ARCH=$2
consensus_tag=$3
nethermind_tag=$4

#update merge-testnets
cd ~/merge-testnets
git fetch && git pull

#update nethermind
cd ~/nethermind
git fetch && git pull
docker buildx build --platform="${OS}/${ARCH}" -t $nethermind_tag .

#update nimbus
cd ~/nimbus-eth2
git fetch && git pull
make -j2 nimbus_beacon_node
echo '
FROM debian:bullseye-slim

SHELL ["/bin/bash", "-c"]

STOPSIGNAL SIGINT

# Docker refuses to copy the source directory here, so read it as "nimbus-eth2/*"
COPY . /home/user/nimbus-eth2
WORKDIR "/home/user/nimbus-eth2/"
ENTRYPOINT ["/home/user/nimbus-eth2/build/nimbus_beacon_node"]' > ~/nimbus-eth2/Dockerfile
docker build -t $consensus_tag nimbus-eth2/
cd ~

echo '
version: "3.4"
services:

  nethermind:
    image: nethermind_kintsugi
    container_name: nethermind_beacon
    volumes:
      - ./execution_data:/execution_data
    command: >
            --config kintsugi --datadir="/execution_data" --JsonRpc.Port=8545
    network_mode: host

  nimbus:
    image: nimbus
    container_name: nimbus_beacon
    volumes:
        - ./beacon_data:/consensus_data
        - ~/merge-testnets/kintsugi:/custom_config_data
    command: |
         --network=/custom_config_data 
         --web3-url=ws://127.0.0.1:8545 
         --log-level=DEBUG  --terminal-total-difficulty-override=5000000000 --data-dir=nimbus-beacondata --bootstrap-node=enr:-Iq4QKuNB_wHmWon7hv5HntHiSsyE1a6cUTK1aT7xDSU_hNTLW3R4mowUboCsqYoh1kN9v3ZoSu_WuvW9Aw0tQ0Dxv6GAXxQ7Nv5gmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk
    network_mode: host
' > ~/docker-compose.nethbus.yml

docker-compose -f docker-compose.nethbus.yml up -d nethermind nimbus