#!/usr/bin/env bash

OS_ARCH=$1

#For bash errors
set -eo pipefail

#update merge-testnets
cd ~/merge-testnets
git fetch && git pull

#update nethermind
cd ~/nethermind
git fetch && git pull
docker buildx build --platform=$OS_ARCH -t nethermind_kintsugi .

#update teku
cd ~/teku
git fetch && git pull
./gradlew installDist
echo '
FROM eclipse-temurin:16 as jre-build

# Create a custom Java runtime
RUN JAVA_TOOL_OPTIONS="-Djdk.lang.Process.launchMechanism=vfork" $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM ubuntu:latest
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME

RUN apt-get -y update
RUN apt-get -y install curl
RUN rm -rf /var/lib/api/lists/*


# copy application (with libraries inside)
COPY . /teku

ENV TEKU_REST_API_INTERFACE="0.0.0.0"
ENV TEKU_METRICS_INTERFACE="0.0.0.0"

# List Exposed Ports
# Metrics, Rest API, LibP2P, Discv5
EXPOSE 8008 5051 9000 9000/udp

# specify default command
ENTRYPOINT ["teku/build/install/teku/bin/teku"]' > ~/teku/Dockerfile
docker build -t teku ~/teku/
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
            --config kintsugi --datadir="/execution_data"
    network_mode: host

  teku:
    image: teku
    container_name: teku_beacon
    volumes:
        - ./beacon_data:/consensus_data
        - ~/merge-testnets/kintsugi:/custom_config_data
    command: >
        --data-path "datadir-teku"   --network https://github.com/eth2-clients/merge-testnets/raw/main/kintsugi/config.yaml   --initial-state https://github.com/eth2-clients/merge-testnets/raw/main/kintsugi/genesis.ssz   --Xee-endpoint http://localhost:8550   --p2p-discovery-bootnodes "enr:-Iq4QKuNB_wHmWon7hv5HntHiSsyE1a6cUTK1aT7xDSU_hNTLW3R4mowUboCsqYoh1kN9v3ZoSu_WuvW9Aw0tQ0Dxv6GAXxQ7Nv5gmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk"
    network_mode: host
' > ~/docker-compose.nethbus.yml

docker-compose -f docker-compose.nethbus.yml up -d 