#!/bin/bash

source ./log.sh

LOG_TAG="Config"

declare -A flags
flags=()

if [[ -f ./utils.sh ]]; then
    . ./utils.sh
else
    loge "${LOG_TAG}" "utils.sh was not found."
fi

if [[ -z $1 ]]; then
    usage
    exit 1
fi

while (("$#")); do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    -a | --all)
        . ./libs.sh
        . ./ssh.sh
        . ./pulseinstall.sh
        . ./android_studio.sh
        . ./code.sh
        . ./cybereasoninstall.sh
        . ./vysor.sh
        . ./tmux.sh
        exit 0
        ;;
    -l | --libs)
        flags+=([libs]=./libs.sh)
        shift
        ;;
    -p | --pulse)
        flags+=([pulse]=./pulseinstall.sh)
        shift
        ;;
    -A | --android)
        flags+=([android]=./android_studio.sh)
        shift
        ;;
    -c | --code)
        flags+=([code]=./code.sh)
        shift
        ;;
    -r | --cyber)
        flags+=([cyber]=./cybereasoninstall.sh)
        shift
        ;;
    -v | --vysor)
        flags+=([vysor]=./vysor.sh)
        shift
        ;;
    -t | --tmux)
        flags+=([tmux]=./tmux.sh)
        shift
        ;;
    -s | --ssh)
        flags+=([ssh]=./ssh.sh)
        shift
        ;;
    -* | --*=) # unsupported flags
        loge "${LOG_TAG}" "Unsupported flag $1" >&2
        exit 1
        ;;
    esac
done

for flag in "${flags[@]}"; do
    . $flag
done
