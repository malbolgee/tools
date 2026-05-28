#!/usr/bin/env bash

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

function main() {

	local a_flag="false"
	local s_flag="false"
	local i_flag="false"

	local l_flag_force="true" # Forces the source of ./libs.sh script.

	declare -a scripts=()
	declare -a summary=()

	# Define a dark theme with green accents for whiptail
	export NEWT_COLORS="
		root=white,black;
		window=lightgray,black;
		border=lightgray,black;
		shadow=black,black;
		button=black,green;
		actbutton=white,green;
		checkbox=green,black;
		actcheckbox=black,green;
		title=green,black;
		listbox=lightgray,black;
		actlistbox=black,lightgray;
	"

	local CHOICES
	CHOICES=$(whiptail --title "Installation Options" --checklist \
		"Select the tools to install:" 20 78 11 \
		"a" "All standard scripts" OFF \
		"F" "Skip libs.sh (Force)" OFF \
		"p" "Anyconnect" OFF \
		"A" "Android Studio" OFF \
		"c" "VS Code" OFF \
		"r" "Sentinel One" OFF \
		"v" "Scrcpy" OFF \
		"t" "Tmux" OFF \
		"s" "SSH Config" OFF \
		"i" "Git Config" OFF \
		"d" "Adrive" OFF 3>&1 1>&2 2>&3)

	if [ $? -ne 0 ]; then
		exit 0
	fi

	if [[ -z $CHOICES ]]; then
		exit 0
	fi

	if [[ $CHOICES == *'"a"'* ]]; then
		a_flag="true"
		scripts+=(
			./ssh.sh
			./gitconfig.sh
			./code.sh
			./android_studio.sh
			./sentinelOneInstall.sh
			./anyconnect.sh
			./scrcpy.sh
			./tmux.sh
			./adrive.sh
		)
	else
		for choice in $CHOICES; do
			# Remove quotes
			choice="${choice%\"}"
			choice="${choice#\"}"

			case "$choice" in
			p) scripts+=(./anyconnect.sh) ;;
			A) scripts+=(./android_studio.sh) ;;
			c) scripts+=(./code.sh) ;;
			r) scripts+=(./sentinelOneInstall.sh) ;;
			v) scripts+=(./scrcpy.sh) ;;
			t) scripts+=(./tmux.sh) ;;
			s)
				s_flag="true"
				scripts+=(./ssh.sh)
				;;
			i)
				i_flag="true"
				scripts+=(./gitconfig.sh)
				;;
			d) scripts+=(./adrive.sh) ;;
			esac
		done
	fi

	if [[ $CHOICES == *'"F"'* ]]; then
		l_flag_force="false"
	fi

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

	if is_package_installed 'lolcat'; then
		lolcat <../.assets/done
	else
		cat <../.assets/done
	fi

	for message in "${summary[@]}"; do
		printf "%s%s%s\\n" "${GREEN}" "${message}" "${NORMAL}"
	done
}

main "$@"
