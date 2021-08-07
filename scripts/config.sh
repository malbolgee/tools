#!/bin/bash

declare -A flags
flags=()

if [[ -f ./utils.sh ]]; then
    . ./utils.sh
else
    fe "utils.sh was not found."
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
        . ./pulseinstall.sh
        . ./android_studio.sh
        . ./code.sh
        . ./cybereasoninstall.sh
        . ./arasinstall.sh
	. ./vysor.sh
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
    -i | --aras)
        flags+=([aras]=./arasinstall.sh)
        shift
        ;;
    -v | --vysor)
        flags+=([vysor]=./vysor.sh)
        shift
        ;;
    -* | --*=) # unsupported flags
        fe "Unsupported flag $1" >&2
        exit 1
        ;;
    esac
done

for flag in "${flags[@]}"; do
    . $flag
done
