#!/usr/bin/env bash

#For bash errors
set -eo pipefail

cd ~
#dependencies
apt-get -y install apt-utils

#docker
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo apt -y install docker.io

#essentials
apt install -y build-essential

#docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#buildx
mkdir -p ~/.docker/cli-plugins
FILE=~/.docker/cli-plugins/docker-buildx
if ! [ -f "$FILE" ]; then
    wget https://github.com/docker/buildx/releases/download/v0.7.1/buildx-v0.7.1.linux-amd64 -P "$FILE"
    mv "$FILE" ~/.docker/cli-plugins/docker-buildx
    chmod a+x ~/.docker/cli-plugins/docker-buildx
fi 

#dotnet
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb; \
sudo dpkg -i packages-microsoft-prod.deb ; \
rm packages-microsoft-prod.deb

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-6.0

#nethermind and dependencies
sudo apt-get install -y libsnappy-dev libc6-dev libc6

#testnet config
git clone https://github.com/eth2-clients/merge-testnets.git
