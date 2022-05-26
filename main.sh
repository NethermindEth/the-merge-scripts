#!/bin/bash
#arg parse for bash using getopt from https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

# More safety, by turning some bugs into errors.
# Without `errexit` you don’t need ! and can replace
# PIPESTATUS with a simple $?, but I don’t do that.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=c:st:b:d:h
LONGOPTS=consensus_engine:,setup,testnet:,nethermind_tag:,consensus_tag:,directory:,branch:,help

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
            -s, --setup               Installs required dependencies for chosen consensus_engine
            -t, --testnet             Choose which testnet to deploy on. Default: bopsten. Supported: kintsugi, bopsten
            --nethermind_tag          Nethermind Docker image tag
            --consensus_tag           Consensus client Docker image tag
            -b, --branch              Defines Nethermind Git branch
            -d, --directory           Working directory
            "
            exit 3
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ $consensus_engine = - ]; then
    echo "Consensus engine is required. Set it with options -c | --consensus.
Use --help for more information."
    exit 4
fi

if [ $s = y ]; then
    echo "Installing dependencies"
    ./setup.sh
fi

if [ $testnet = - ]; then
    testnet="bopsten"
    echo "No testnet specified, using default: $testnet"
fi

if [ $nethermind_tag = - ]; then
    nethermind_tag="nethermind_bopsten"
    echo "No nethermind tag specified, using default: $nethermind_tag"
fi

if [ $consensus_tag = - ]; then
    consensus_tag="${consensus_engine}_beacon"
    echo "No consensus tag specified, using default: ${consensus_engine}_beacon"
fi

if [ $directory = - ]; then
    directory="~"
    echo "No working directory specified, using default: ~"
fi

if [ $branch = - ]; then
    branch="main"
    echo "No branch tag specified, using default: main"
fi

                                                                                                                                                                                                    98,0-1        72%
# Without `errexit` you don’t need ! and can replace
# PIPESTATUS with a simple $?, but I don’t do that.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=c:st:b:d:h
LONGOPTS=consensus_engine:,setup,testnet:,nethermind_tag:,consensus_tag:,directory:,branch:,help

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

nethermind_tag=- consensus_tag=- consensus_engine=- testnet=- branch=- directory=-
s=n
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -c|--consensus_engine)
            consensus_engine="$2"
            declare -l consensus_engine
            consensus_engine=$consensus_engine
            shift 2
            ;;
        -s|--setup)
            s=y
            shift
            ;;
        -t|--testnet)
            testnet="$2"
            declare -l testnet
            testnet=$testnet
            shift 2
            ;;
        --nethermind_tag)
            nethermind_tag="$2"
            shift 2
            ;;
        --consensus_tag)
            consensus_tag="$2"
            shift 2
                                                                                                                                                                                                    32,0-1         3%
            echo "Usage: ./main.sh [OPTIONS]

            Install and run validators with ease.

            Required Option:
            -c, --consensus_engine    Chosen consensus engine to use.
                                      Choices: lighthouse, lodestar, nimbus, prysm, teku
            Optional:
            -s, --setup               Installs required dependencies for chosen consensus_engine
            -t, --testnet             Choose which testnet to deploy on. Default: bopsten. Supported: kintsugi, bopsten
            --nethermind_tag          Nethermind Docker image tag
            --consensus_tag           Consensus client Docker image tag
            -b, --branch              Defines Nethermind Git branch
            -d, --directory           Working directory
            "
            exit 3
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ $consensus_engine = - ]; then
    echo "Consensus engine is required. Set it with options -c | --consensus.
Use --help for more information."
    exit 4
fi

if [ $s = y ]; then
    echo "Installing dependencies"
    ./setup.sh
fi

if [ $testnet = - ]; then
    testnet="bopsten"
    echo "No testnet specified, using default: $testnet"
fi

if [ $nethermind_tag = - ]; then
    nethermind_tag="nethermind_bopsten"
    echo "No nethermind tag specified, using default: $nethermind_tag"
fi

if [ $consensus_tag = - ]; then
    consensus_tag="${consensus_engine}_beacon"
    echo "No consensus tag specified, using default: ${consensus_engine}_beacon"
fi

if [ $directory = - ]; then
    directory="~"
                                                                                                                                                                                                    98,0-1        64%
# Without `errexit` you don’t need ! and can replace
# PIPESTATUS with a simple $?, but I don’t do that.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=c:st:b:d:h
LONGOPTS=consensus_engine:,setup,testnet:,nethermind_tag:,consensus_tag:,directory:,branch:,help

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors

OPTIONS=c:st:b:d:h
LONGOPTS=consensus_engine:,setup,testnet:,nethermind_tag:,consensus_tag:,directory:,branch:,help
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# cd the-merge-scripts/
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root/the-merge-scripts# git pull
remote: Enumerating objects: 29, done.
remote: Counting objects: 100% (29/29), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 15 (delta 10), reused 15 (delta 10), pack-reused 0
Unpacking objects: 100% (15/15), 2.77 KiB | 473.00 KiB/s, done.
From https://github.com/NethermindEth/the-merge-scripts
   d4a95a5..cb4155f  bopsten    -> origin/bopsten
Updating d4a95a5..cb4155f
Fast-forward
 bopsten/bopsten.sh               | 17 +++++++++--------
 bopsten/nethbus/run-nethbus.sh   |  8 +++++---
 bopsten/nethku/run-nethku.sh     |  8 +++++---
 bopsten/nethouse/run-nethouse.sh |  8 +++++---
 bopsten/nethstar/run-nethstar.sh |  8 +++++---
 bopsten/nethysm/run-nethysm.sh   |  8 +++++---
 main.sh                          | 18 ++++++++++++++----
 7 files changed, 48 insertions(+), 27 deletions(-)
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root/the-merge-scripts# cd ..
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# bash the-merge-scripts/main.sh --consensus_engine teku --testnet bopsten -d /mnt/vol-bopsten-nethku-us-east-0/root
Programming error
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# ls
beacon_data  docker-compose.nethku.yml  execution_data  nethermind.logs  teku.logs  the-merge-scripts
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# rm docker-compose.nethku.yml
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# bash the-merge-scripts/main.sh --consensus_engine teku --testnet bopsten -d "/mnt/vol-bopsten-nethku-us-east-0/root"
Programming error
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# vi the-merge-scripts/main.sh
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# cd the-merge-scripts/
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root/the-merge-scripts# git pull
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (1/1), done.
remote: Total 3 (delta 2), reused 3 (delta 2), pack-reused 0
Unpacking objects: 100% (3/3), 1.21 KiB | 414.00 KiB/s, done.
From https://github.com/NethermindEth/the-merge-scripts
   cb4155f..47841bb  bopsten    -> origin/bopsten
Updating cb4155f..47841bb
Fast-forward
 main.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root/the-merge-scripts# cd ..
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# bash the-merge-scripts/main.sh --consensus_engine teku --testnet bopsten -d "/mnt/vol-bopsten-nethku-us-east-0/root"
Programming error
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# vi the-merge-scripts/main.sh
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# bash the-merge-scripts/main.sh --consensus_engine teku --testnet bopsten -d "/mnt/vol-bopsten-nethku-us-east-0/root"
No nethermind tag specified, using default: nethermind_bopsten
No consensus tag specified, using default: teku_beacon
No working directory specified, using default: ~
the-merge-scripts/main.sh: line 149: cd: ~/the-merge-scripts/: No such file or directory
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# bash the-merge-scripts/main.sh --consensus_engine teku --testnet bopsten -d /mnt/vol-bopsten-nethku-us-east-0/root
No nethermind tag specified, using default: nethermind_bopsten
No consensus tag specified, using default: teku_beacon
No working directory specified, using default: ~
the-merge-scripts/main.sh: line 149: cd: ~/the-merge-scripts/: No such file or directory
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# vi the-merge-scripts/main.sh
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# bash the-merge-scripts/main.sh --consensus_engine teku --testnet bopsten -d /mnt/vol-bopsten-nethku-us-east-0/root
No nethermind tag specified, using default: nethermind_bopsten
No consensus tag specified, using default: teku_beacon
No branch tag specified, using default: main
Using bopsten testnet
root@localhost:/mnt/vol-bopsten-nethku-us-east-0/root# cat the-merge-scripts/main.sh
#!/bin/bash
#arg parse for bash using getopt from https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

# More safety, by turning some bugs into errors.
# Without `errexit` you don’t need ! and can replace
# PIPESTATUS with a simple $?, but I don’t do that.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=c:st:b:d:h
LONGOPTS=consensus_engine:,setup,testnet:,nethermind_tag:,consensus_tag:,directory:,branch:,help

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

nethermind_tag=- consensus_tag=- consensus_engine=- testnet=- branch=- directory=-
s=n
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -c|--consensus_engine)
            consensus_engine="$2"
            declare -l consensus_engine
            consensus_engine=$consensus_engine
            shift 2
            ;;
        -s|--setup)
            s=y
            shift
            ;;
        -t|--testnet)
            testnet="$2"
            declare -l testnet
            testnet=$testnet
            shift 2
            ;;
        --nethermind_tag)
            nethermind_tag="$2"
            shift 2
            ;;
        --consensus_tag)
            consensus_tag="$2"
            shift 2
            ;;
        -b|--branch)
            branch="$2"
            shift 2
            ;;
        -d|--directory)
            directory="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: ./main.sh [OPTIONS]

            Install and run validators with ease.

            Required Option:
            -c, --consensus_engine    Chosen consensus engine to use.
                                      Choices: lighthouse, lodestar, nimbus, prysm, teku
            Optional:
            -s, --setup               Installs required dependencies for chosen consensus_engine
            -t, --testnet             Choose which testnet to deploy on. Default: bopsten. Supported: kintsugi, bopsten
            --nethermind_tag          Nethermind Docker image tag
            --consensus_tag           Consensus client Docker image tag
            -b, --branch              Defines Nethermind Git branch
            -d, --directory           Working directory
            "
            exit 3
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ $consensus_engine = - ]; then
    echo "Consensus engine is required. Set it with options -c | --consensus.
Use --help for more information."
    exit 4
fi

if [ $s = y ]; then
    echo "Installing dependencies"
    ./setup.sh
fi

if [ $testnet = - ]; then
    testnet="bopsten"
    echo "No testnet specified, using default: $testnet"
fi

if [ $nethermind_tag = - ]; then
    nethermind_tag="nethermind_bopsten"
    echo "No nethermind tag specified, using default: $nethermind_tag"
fi

if [ $consensus_tag = - ]; then
    consensus_tag="${consensus_engine}_beacon"
    echo "No consensus tag specified, using default: ${consensus_engine}_beacon"
fi

if [ $directory = - ]; then
    directory="~"
    echo "No working directory specified, using default: ~"
fi

if [ $branch = - ]; then
    branch="main"
    echo "No branch tag specified, using default: main"
fi

## Change branch flag logic
# cd ~/nethermind/
# current_branch=$(git branch --show-current 2>/dev/null)
# echo "current branch: $current_branch"
# echo "current directory: $(pwd)"

# if [ "$current_branch" = "$branch" ]; then
#     echo "Already on $branch branch"
#     git reset --hard origin/$branch
# else
#     echo "Checking out $branch branch"
#     git checkout $branch
#     git reset --hard origin/$branch
# fi
cd "${directory}/the-merge-scripts/"

case $testnet in
    kintsugi)
        echo "Using kintsugi testnet"
        kintsugi/kintsugi.sh $consensus_engine $consensus_tag $nethermind_tag $s
        ;;
    bopsten)
        echo "Using bopsten testnet"
        bopsten/bopsten.sh $consensus_engine $directory
        ;;
    *)
        echo "Unknown testnet: $testnet"
        exit 5
        ;;
esac