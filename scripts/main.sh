#!/bin/bash

MAIN_LOG_TAG="Main"

set -e

function show_error_message() {
	echo "$1 was not found"
	exit 1
}

function check_flag() {
	local flag=$1
	local option=$2

	if [ "$flag" == "true" ]; then
		loge "$MAIN_LOG_TAG" "Option $option cannot be used along with other options."
		exit 1
	fi
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

	local a_flag="false"
	local l_flag="false"
	local l_flag_force="true" # Forces the use of the -l option.

	declare -A flags=()
	declare -a order=(libs ssh code android cyber pulse vysor tmux ggdrive) # Keeps the order of execution

	if [[ -z $1 ]]; then
		usage
		exit 1
	fi

	while getopts 'lpAcrvtsgaFh' opt; do
		case "$opt" in
		a)

			if [ "${#flags[@]}" -ne 0 ]; then
				loge "$MAIN_LOG_TAG" "Option 'a' cannot be used along with other options."
				exit 1
			fi

			flags+=(
				[libs]=./libs.sh
				[ssh]=./ssh.sh
				[code]=./code.sh
				[android]=./android_studio.sh
				[cyber]=./cybereasoninstall.sh
				[pulse]=./pulseinstall.sh
				[vysor]=./vysor.sh
				[tmux]=./tmux.sh
				[ggdrive]=./ggdrive.sh
			)

			a_flag="true"
			;;

		F)
			l_flag_force="false"
			;;

		l)
			check_flag "$a_flag" "'a'"
			flags+=([libs]=./libs.sh)
			l_flag="true"
			;;

		p)
			check_flag "$a_flag" "'a'"
			flags+=([pulse]=./pulseinstall.sh)
			;;

		A)
			check_flag "$a_flag" "'a'"
			flags+=([android]=./android_studio.sh)
			;;

		c)
			check_flag "$a_flag" "'a'"
			flags+=([code]=./code.sh)
			;;

		r)
			check_flag "$a_flag" "'a'"
			flags+=([cyber]=./cybereasoninstall.sh)
			;;

		v)
			check_flag "$a_flag" "'a'"
			flags+=([vysor]=./vysor.sh)
			;;

		t)
			check_flag "$a_flag" "'a'"
			flags+=([tmux]=./tmux.sh)
			;;

		s)
			check_flag "$a_flag" "'a'"
			flags+=([ssh]=./ssh.sh)
			;;

		g)
			check_flag "$a_flag" "'a'"
			flags+=([ggdrive]=./ggdrive.sh)
			;;

		h)
			usage
			exit 1
			;;

		*)
			usage
			exit 1
			;;
		esac
	done

	# should we even have a 'libs' in this flags array? 
	if [[ "$a_flag" == "true" || "$l_flag" == "true" ]]; then
		unset "flags['libs']" # Remove libs from whatever position it got placed into.
	fi

	# shellcheck source=/dev/null
	# The libs script must always run, unless the F flag is used.
	if [ "$l_flag_force" == "true" ]; then
		source ./libs.sh
	fi

	# shellcheck source=/dev/null
	for index in "${order[@]}"; do
		source "${flags[$index]}"
	done

}

main "$1"

unset LOG_LIB_LOADED
unset UTILS_LIB_LOADED
