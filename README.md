# The merge scripts

Scripts for the setup of Ethereum 2 validators in a ubuntu/debian machine.

Currently there are scripts for the following testnets:
- [Kintsugi](https://hackmd.io/@n0ble/kintsugi-spec)
- [Bopsten](https://github.com/ethereum/execution-apis/blob/2d8fe82fcc4e63f82501eb41819cb1a222ad6007/src/engine/authentication.md)

## Kintsugi testnet

Nethermind client in combination of the following consensus engines (without validators yet):
- [Lighthouse](https://github.com/sigp/lighthouse)
- [Lodestar](https://github.com/chainsafe/lodestar)
- [Nimbus](https://github.com/status-im/nimbus-eth2)
- [Teku](https://github.com/ConsenSys/teku)
- [Prysm](https://github.com/prysmaticlabs/prysm)

### How to run

First clone this repository in Home directory. Consider running `find . -type f -name '*.sh' -exec chmod +x {} \;` to make all scripts executables.

> If you do not have nethermind, docker and docker-compose installed, then run `setup.sh` to install them. This also clone the repo https://github.com/eth-clients/merge-testnets.git, which contains the configuration for the tesnet

To run a nethermind with a consensus engine on kintsugi you just need to pass the correct args values to `main.sh` script:

```./main.sh --consensus_engine <client> --testnet bopsten ```

where `<client>` can be any of the ones listed above (no case sensitive).

> If you do not have the desired consensus engine installed, then run `main.sh` with the `-s` option to install all the dependencies and software needed

Lighthouse, Nimbus and Teku have docker support so the scripts will create a `docker-compose.yml` file to run nethermind with the desired client and run it. Optionally you can chose what tag use for nethermind and consensus engine docker image with the options `--nethermind_tag` and `--consensus_tag` respectively. You can check the execution logs with:

```docker logs -f docker-compose.<name>.yml --tail=20```

where `<name>` is:
- nethouse <-> Lighthouse
- nethstar <-> Lodestar
- nethbus <-> Nimbus
- nethku <-> Teku
- nethysm <-> Prysm

To run Lodestar and Prysm you need two terminal sessions. `screen` is a useful command for this and is installed by default if you run the main script with the `-s` option. 

> Use systemd services instead of screen for production systems

To run nethermind in one terminal, create first one screen session with `screen -S <nethermind-session-name>`. This command also switch to that session. Next go to the `nethermind/src/Nethermind/Nethermind.Runner` folder and run:

```
dotnet run -c Release -- --config kintsugi
```

To leave the session press `Ctrl + A + D`.

> For more information about screen command check https://linuxize.com/post/how-to-use-linux-screen/

For Lodestar create a new session and go to the `lodestar` folder and run:

```
./lodestar beacon \
--rootDir="../lodestar-beacondata" \
--paramsFile="./config.yaml" \
--genesisStateFile="./genesis.ssz" \
--network.discv5. bootEnrs="enr:-Iq4QKuNB_wHmWon7hv5HntHiSsyE1a6cUTK1aT7xDSU_hNTLW3R4mowUboCsqYoh1kN9v3ZoSu_WuvW9Aw0tQ0Dxv6GAXxQ7Nv5gmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk" \
--eth1.enabled=true \
--execution.urls="http://127.0.0.1:8550" \
--network.connectToDiscv5Bootnodes \
--network.discv5.enabled=true \
--logFile beacon.log
```

For Prysm create a new session and go to the `prysm` folder and run:

```
bazel run //beacon-chain -- 
--genesis-state ~/merge-testnets/kintsugi/genesis.ssz \
--datadir $PWD/../datadir-prysm \
--http-web3provider=http://localhost:8550 \
--min-sync-peers=1 \
--chain-config-file ~/merge-testnets/kintsugi/config.yaml \
--bootstrap-node "enr:-Iq4QKuNB_wHmWon7hv5HntHiSsyE1a6cUTK1aT7xDSU_hNTLW3R4mowUboCsqYoh1kN9v3ZoSu_WuvW9Aw0tQ0Dxv6GAXxQ7Nv5gmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk" \ 
--terminal-total-difficulty-override 5000000000
```

## Bopsten testnet

Nethermind client in combination of the following consensus engines (without validators yet):
- [Lighthouse](https://github.com/sigp/lighthouse)
- [Lodestar](https://github.com/chainsafe/lodestar)
- [Nimbus](https://github.com/status-im/nimbus-eth2)
- [Teku](https://github.com/ConsenSys/teku)
- [Prysm](https://github.com/prysmaticlabs/prysm)

### How to run

First clone this repository in Home directory. Consider running `find . -type f -name '*.sh' -exec chmod +x {} \;` to make all scripts executables.

> If you do not have nethermind, docker and docker-compose installed, then run `setup.sh` to install them.

To run a nethermind with a consensus engine on bopsten you just need to pass the correct args values to `main.sh` script:

```./main.sh --consensus_engine <client> --testnet bopsten ```

where `<client>` can be any of the ones listed above (no case sensitive).

All of the consensus clients have docker support so the scripts will create a `docker-compose.yml` file to run nethermind with the desired client and run it. You can check the execution logs with:

```docker logs -f docker-compose.<name>.yml --tail=20```

where `<name>` is:
- nethouse <-> Lighthouse
- nethstar <-> Lodestar
- nethbus <-> Nimbus
- nethku <-> Teku
- nethysm <-> Prysm

