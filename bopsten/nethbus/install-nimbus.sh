#!/bin/bash

#For bash errors
set -eo pipefail

git clone -b unstable https://github.com/status-im/nimbus-eth2.git
cd nimbus-eth2/
make update OVERRIDE=1
make nimbus_beacon_node
cd ..