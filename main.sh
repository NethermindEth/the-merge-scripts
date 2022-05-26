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

OPTIONS=c:st:b:h:d
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
            branch="$2"
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
