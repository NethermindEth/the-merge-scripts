#!/usr/bin/env bash

#For bash errors
set -eo pipefail

#update merge-testnets
cd ~/merge-testnets
git fetch && git pull

#update nethermind
cd ~/nethermind
git fetch && git pull
docker buildx build --platform=linux/amd64 -t nethermind_kintsugi .

#update lighthouse
cd ~/lighthouse
git fetch && git pull
docker build -t lighthouse .

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

  lighthouse:
    image: lighthouse
    container_name: lighthouse_beacon
    volumes:
        - ./beacon_data:/consensus_data
        - ~/merge-testnets/kintsugi:/custom_config_data
    command: >
        lighthouse --spec mainnet --testnet-dir=/custom_config_data --debug-level info beacon_node --datadir ./testnet-lh1 --eth1 --http --http-allow-sync-stalled --metrics --merge --eth1-endpoints http://127.0.0.1:8550 --enr-udp-port=9001 --enr-tcp-port=9001 --discovery-port=9001 --boot-nodes="enr:-KG4QIkKUzDxrv7Xz8u9K9QqoTqEwKKCkLoChxVnfeILU6IdBoWoNOxPGvdl474l1iPFoR8CJUhgGEeO-k1SJ7SJCOEDhGV0aDKQR9ByjGEAAHAKAAAAAAAAAIJpZIJ2NIJpcISl6LnPiXNlY3AyNTZrMaEDprwHy6RKAKJguvGCldiGAI5JDJmQ8TZVnnWQur8zEh2DdGNwgiMog3VkcIIjKA,enr:-Ly4QGJodG8Q0vX5ePXsLsXody1Fbeauyottk3-iAvJ_6XfTVlWGsnfBQPlIOBgexXJqD78bUD5OCnXF5igBBJ4WuboBh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBH0HKMYQAAcAoAAAAAAAAAgmlkgnY0gmlwhEDhBN-Jc2VjcDI1NmsxoQPf98kXQf3Nh3ooc8vBdbUY2WAHR1VDrDhXYTKvRt4n-IhzeW5jbmV0cwCDdGNwgiMog3VkcIIjKA,enr:-KG4QLIhAeEVABV4Id22qEbjemJ0b9JBjRhdYpKN0kvpVi_GbFkQTvAf7-Da-5sW2oNenTW3is_GxLImUCtYzxPMOR4DhGV0aDKQR9ByjGEAAHAKAAAAAAAAAIJpZIJ2NIJpcISl6LF5iXNlY3AyNTZrMaED6XFvht9SUPD0FlYWnjunXhF9FdQMQO56816C9iFNt-WDdGNwgiMog3VkcIIjKA,enr:-LK4QPluMnS3OaiMpy7E0dSF-n7ES9Ort7mpOj85lS_43jGvfuV-SOZyjYNG-WEIT5aOzpWH2vgBbF2MoB94IZdDLxIBh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBH0HKMYQAAcAoAAAAAAAAAgmlkgnY0gmlwhKEjS06Jc2VjcDI1NmsxoQM0uDjlVaZoToQ6ReyUkgFTQizlE6avXGljrWIz9Rf4LoN0Y3CCIyiDdWRwgiMo,enr:-Ku4QM4JL9b3RGfRnnfAY7jqDRiTTGaU2OWk0j4YWbR7N2YHc7RjPGiVERqiWHasIjmMz-No86wsvf4KHuyM4FeRtuMFh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBH0HKMYQAAcAoAAAAAAAAAgmlkgnY0gmlwhKEjQ92Jc2VjcDI1NmsxoQN_UgL8zuTFqyGm5_lKZqUdoHMH2XeU0OvNmZwgycMmSIN0Y3CCIyg"
    network_mode: host
' > docker-compose.nethouse.yml

docker-compose -f docker-compose.nethouse.yml up -d 