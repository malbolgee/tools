#!/bin/bash

LOG_TAG="Main"

function show_error_message() {
	echo "$1 was not found"
	exit 1 
}

[ -f ./log.sh ] && . ./log.sh || show_error_message "./log.sh"
[ -f ./utils.sh ] && . ./utils.sh || show_error_message "./utils.sh"

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

}

main
