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

#update lighthouse
cd ~/lighthouse
git fetch && git pull
docker build -t $consensus_tag .
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

  lighthouse:
    image: lighthouse
    container_name: lighthouse_beacon
    volumes:
        - ./beacon_data:/consensus_data
        - ~/merge-testnets/kintsugi:/custom_config_data
    command: |
        lighthouse 
        --spec mainnet 
        --testnet-dir=/custom_config_data 
        --debug-level info 
        beacon_node 
        --datadir ./testnet-lh1 
        --eth1 
        --http 
        --http-allow-sync-stalled 
        --metrics 
        --merge  
        --enr-udp-port=9001 
        --enr-tcp-port=9001 
        --discovery-port=9001 --boot-nodes="enr:-KG4QIkKUzDxrv7Xz8u9K9QqoTqEwKKCkLoChxVnfeILU6IdBoWoNOxPGvdl474l1iPFoR8CJUhgGEeO-k1SJ7SJCOEDhGV0aDKQR9ByjGEAAHAKAAAAAAAAAIJpZIJ2NIJpcISl6LnPiXNlY3AyNTZrMaEDprwHy6RKAKJguvGCldiGAI5JDJmQ8TZVnnWQur8zEh2DdGNwgiMog3VkcIIjKA,enr:-Ly4QGJodG8Q0vX5ePXsLsXody1Fbeauyottk3-iAvJ_6XfTVlWGsnfBQPlIOBgexXJqD78bUD5OCnXF5igBBJ4WuboBh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBH0HKMYQAAcAoAAAAAAAAAgmlkgnY0gmlwhEDhBN-Jc2VjcDI1NmsxoQPf98kXQf3Nh3ooc8vBdbUY2WAHR1VDrDhXYTKvRt4n-IhzeW5jbmV0cwCDdGNwgiMog3VkcIIjKA,enr:-KG4QLIhAeEVABV4Id22qEbjemJ0b9JBjRhdYpKN0kvpVi_GbFkQTvAf7-Da-5sW2oNenTW3is_GxLImUCtYzxPMOR4DhGV0aDKQR9ByjGEAAHAKAAAAAAAAAIJpZIJ2NIJpcISl6LF5iXNlY3AyNTZrMaED6XFvht9SUPD0FlYWnjunXhF9FdQMQO56816C9iFNt-WDdGNwgiMog3VkcIIjKA,enr:-LK4QPluMnS3OaiMpy7E0dSF-n7ES9Ort7mpOj85lS_43jGvfuV-SOZyjYNG-WEIT5aOzpWH2vgBbF2MoB94IZdDLxIBh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBH0HKMYQAAcAoAAAAAAAAAgmlkgnY0gmlwhKEjS06Jc2VjcDI1NmsxoQM0uDjlVaZoToQ6ReyUkgFTQizlE6avXGljrWIz9Rf4LoN0Y3CCIyiDdWRwgiMo,enr:-Ku4QM4JL9b3RGfRnnfAY7jqDRiTTGaU2OWk0j4YWbR7N2YHc7RjPGiVERqiWHasIjmMz-No86wsvf4KHuyM4FeRtuMFh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBH0HKMYQAAcAoAAAAAAAAAgmlkgnY0gmlwhKEjQ92Jc2VjcDI1NmsxoQN_UgL8zuTFqyGm5_lKZqUdoHMH2XeU0OvNmZwgycMmSIN0Y3CCIyg"
    network_mode: host

  lighthouse_validator_import:
    image: lighthouse_beacon
    command: |
      lighthouse account validator import
      --password-file=/keys/keystore_password.txt
      --reuse-password
      --directory /keys
      --datadir /var/lib/lighthouse
      --testnet-dir /custom_config_data
    volumes:
      - ~/assigned_data/keys:/keys
      - ~/merge-testnets/kintsugi:/custom_config_data
      - ~/kintsugi/lighthouse/data_directory:/var/lib/lighthouse

  lighthouse_validator:
    image: lighthouse_beacon
    container_name: lighthouse-validator
    volumes:
      - ~/merge-testnets/kintsugi:/custom_config_data
      - ~/kintsugi/lighthouse/data_directory:/var/lib/lighthouse
    command: |
      lighthouse vc
      --testnet-dir /custom_config_data
      --datadir /var/lib/lighthouse
      --metrics
      --debug-level=info
    network_mode: host
    logging:
      driver: "json-file"
      options:
        max-size: "100m"
        max-file: "1"
' > ~/docker-compose.nethouse.yml

docker-compose -f docker-compose.nethouse.yml up -d nethermind lighthouse