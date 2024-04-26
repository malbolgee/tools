#!/bin/bash

LOG_TAG="Main"

set -e

function show_error_message() {
	echo "$1 was not found"
	exit 1
}

if [ -f ./log.sh ]; then
	export LOG_LIB_LOADED='y'
	source ./log.sh
else
	show_error_message "log.sh"
fi

if [ -f ./utils.sh ]; then
	export UTILS_LIB_LOADED='y'
	source ./utils.sh
else
	show_error_message "utils.sh"
fi

function main() {

	local flags=()

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
			. ./ggdrive.sh
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
		-g | --ggdrive)
			flags+=([ggdrive]=./ggdrive.sh)
			shift
			;;
		-* | --*=) # unsupported flags
			loge "${LOG_TAG}" "Unsupported flag $1" >&2
			exit 1
			;;
		esac
	done

	for flag in "${flags[@]}"; do
		source "$flag"
	done

}

main "$1"

unset LOG_LIB_LOADED
unset UTILS_LIB_LOADED
