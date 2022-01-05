# The merge scripts

Scripts for the setup of Ethereum 2 validators in a ubuntu/debian machine.

Currently there are scripts for the following testnets:
- [Kintsugi](https://hackmd.io/@n0ble/kintsugi-spec)

## Kintsugi testnet

Nethermind client in combination of the following consensus engines (without validators yet):
- [Lighthouse](https://github.com/sigp/lighthouse)
- [Lodestar](https://github.com/chainsafe/lodestar)
- [Nimbus](https://github.com/status-im/nimbus-eth2)
- [Teku](https://github.com/ConsenSys/teku)
- [Prysm](https://github.com/prysmaticlabs/prysm)

### How to run

First clone this repository in Home directory. Consider running `find . -type f -name '*.sh' -exec chmod +x {} \;` to make all scripts executables.

> If you do not have nethermind, docker and docker-compose installed, then run `setup.sh` to install them. This also clone the repo https://github.com/eth2-clients/merge-testnets.git, which contains the configuration for the tesnet

To run a nethermind with a consensus engine on kintsugi you just need to pass the correct args values to `main.sh` script:

```./main.sh --consensus_engine <client> --testnet kintsugi ```

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

To run Teku and Prysm you need two terminal sessions. `screen` is a useful command for this and is installed by default if you run the main script with the `-s` option. 

> Use systemd services instead of screen for production systems

To run nethermind in one terminal, create first one screen session with `screen -S <nethermind-session-name>`. This command also switch to that session. Next go to the `nethermind/src/Nethermind/Nethermind.Runner` folder and run:

```
dotnet run -c Release -- --config kintsugi
```

To leave the session press `Ctrl + A + D`.

> For more information about screen command check https://linuxize.com/post/how-to-use-linux-screen/

For Teku create a new session and go to the `teku/build/install/teku/bin` folder and run:

```
./teku 
--data-path "datadir-teku" \
--network https://github.com/eth2-clients/merge-testnets/raw/main/merge-devnet-2/config.yaml \
--initial-state https://github.com/eth2-clients/merge-testnets/raw/main/merge-devnet-2/genesis.ssz \   
--Xee-endpoint http://localhost:8550 \
--p2p-discovery-bootnodes "enr:-Iq4QKuNB_wHmWon7hv5HntHiSsyE1a6cUTK1aT7xDSU_hNTLW3R4mowUboCsqYoh1kN9v3ZoSu_WuvW9Aw0tQ0Dxv6GAXxQ7Nv5gmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk" \
--log-destination console
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

Check [this](https://www.notion.so/nethermind/7e25dc09046b4f2fabac2f2cb5fda52c?v=c64361f9012c401ebe7eb93046ba9347) notion page to check the status of the nodes created and installed for kintsugi.