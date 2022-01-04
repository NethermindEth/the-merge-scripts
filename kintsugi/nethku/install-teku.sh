#!/bin/bash

#For bash errors
set -eo pipefail

git clone https://github.com/ConsenSys/teku.git
cd teku
./gradlew installDist

apt install screen
