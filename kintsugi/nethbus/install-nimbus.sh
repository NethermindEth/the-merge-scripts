#!/bin/bash

#For bash errors
set -eo pipefail

git clone -b kintsugi https://github.com/status-im/nimbus-eth2.git
cd nimbus-eth2/
make -j2 nimbus_beacon_node