#!/bin/bash

#  ████████╗██╗##██╗██╗███╗###██╗██╗##██╗███████╗██╗##██╗██╗███████╗██╗#####██████╗#
#  ╚══██╔══╝██║##██║██║████╗##██║██║#██╔╝██╔════╝██║##██║██║██╔════╝██║#####██╔══██╗
#  ###██║###███████║██║██╔██╗#██║█████╔╝#███████╗███████║██║█████╗##██║#####██║##██║
#  ###██║###██╔══██║██║██║╚██╗██║██╔═██╗#╚════██║██╔══██║██║██╔══╝##██║#####██║##██║
#  ###██║###██║##██║██║██║#╚████║██║##██╗███████║██║##██║██║███████╗███████╗██████╔╝
#  ###╚═╝###╚═╝##╚═╝╚═╝╚═╝##╚═══╝╚═╝##╚═╝╚══════╝╚═╝##╚═╝╚═╝╚══════╝╚══════╝╚═════╝#
#  #################################################################################
#  ################████████╗#██████╗##██████╗#██╗#####███████╗######################
#  ################╚══██╔══╝██╔═══██╗██╔═══██╗██║#####██╔════╝######################
#  ###################██║###██║###██║██║###██║██║#####███████╗######################
#  ###################██║###██║###██║██║###██║██║#####╚════██║######################
#  ###################██║###╚██████╔╝╚██████╔╝███████╗███████║######################
#  ###################╚═╝####╚═════╝##╚═════╝#╚══════╝╚══════╝######################
#  #################################################################################

set -e

MAIN_LOG_TAG="Main"

export COREID=$USER
export MAIN_LOADED="true"

function show_error_message() {
	echo "$1 was not found"
	exit 1
}

if [ -f ./log.sh ]; then
	# shellcheck source=/dev/null
	source ./log.sh
else
	show_error_message "log.sh"
fi

if [ -f ./utils.sh ]; then
	# shellcheck source=/dev/null
	source ./utils.sh
else
	show_error_message "utils.sh"
fi

function check_flag() {
	local flag=$1
	local option=$2

	if [ "$flag" == "true" ]; then
		loge "$MAIN_LOG_TAG" "Option $option cannot be used along with other options."
		exit 1
	fi
}

function main() {

	local a_flag="false"
	local s_flag="false"
	local i_flag="false"

	local l_flag_force="true" # Forces the source of ./libs.sh script.

	declare -a scripts=()
	declare -x summary=()

	if [[ -z $1 ]]; then
		usage
		exit 1
	fi

	while getopts 'aipcrvtsgAFh' opt; do
		case "$opt" in
		a)

			if [ "${#scripts[@]}" -ne 0 ]; then
				loge "$MAIN_LOG_TAG" "Option 'a' cannot be used along with other options."
				exit 1
			fi

			scripts+=(
				./ssh.sh
				./gitconfig.sh
				./code.sh
				./android_studio.sh
				./cybereasoninstall.sh
				./pulseinstall.sh
				./vysor.sh
				./tmux.sh
				./ggdrive.sh
			)

			a_flag="true"
			;;

		F)
			l_flag_force="false"
			;;

		p)
			check_flag "$a_flag" "'a'"
			scripts+=(./pulseinstall.sh)
			;;

		A)
			check_flag "$a_flag" "'a'"
			scripts+=(./android_studio.sh)
			;;

		c)
			check_flag "$a_flag" "'a'"
			scripts+=(./code.sh)
			;;

		r)
			check_flag "$a_flag" "'a'"
			scripts+=(./cybereasoninstall.sh)
			;;

		v)
			check_flag "$a_flag" "'a'"
			scripts+=(./vysor.sh)
			;;

		t)
			check_flag "$a_flag" "'a'"
			scripts+=(./tmux.sh)
			;;

		s)
			check_flag "$a_flag" "'a'"
			s_flag="true"
			scripts+=(./ssh.sh)
			;;

		i)
			check_flag "$a_flag" "'a'"
			i_flag="true"
			scripts+=(./gitconfig.sh)
			;;

		g)
			check_flag "$a_flag" "'a'"
			scripts+=(./ggdrive.sh)
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

	# only ask for core id if we need it
	if [[ "$a_flag" == "true" || "$s_flag" == "true" || "$i_flag" == true ]]; then
		prompt_coreid_question
	fi

	# shellcheck source=/dev/null
	# The libs script must always run, unless the F flag is used.
	if [ "$l_flag_force" == "true" ]; then
		source ./libs.sh
	fi

	# shellcheck source=/dev/null
	for script in "${scripts[@]}"; do
		source "${script}"
	done

	lolcat <../.assets/done

	for message in "${summary[@]}"; do
		printf "%s%s%s\\n" "${GREEN}" "${message}" "${NORMAL}"
	done
}

main "$1"

unset COREID
unset MAIN_LOADED
