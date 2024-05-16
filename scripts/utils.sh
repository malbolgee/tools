#!/bin/bash

source ./log.sh

LOG_TAG="Utils"

BASHRC_PATH="$HOME/.bashrc"

# Export to PATH a directory passed as argument
#
# @param $1 Is the path to be placed in the PATH.
#
path_export() {

	local line=$1

	if [ ! -d "$line" ]; then
		loge "${LOG_TAG}" "The directory $1 does not exist. Unable to put it into PATH."
	fi

	_put_line_in_file "$line" "$BASHRC_PATH"

}

# Add a PPA repository source into the source.list file
add_source_ppa() {

	local ppa=$1
	local filepath=$2

	_put_line_in_file "$ppa" "$filepath"

}

# Puts a line at the end of a file.
#
# @param $1 Is the line to be placed in the file.
# @param $2 Is the path in which the file is located.
#			The path must contain the file name as in /home/user/.bashrc, for exemple.
#
_put_line_in_file() {

	local line=$1
	local filepath=$2

	if [ ! -f "$filepath" ]; then
		loge "${LOG_TAG}" "The $filepath file does not exist."
	fi

	if ! grep -qE "$line" "$filepath"; then
		sudo echo "$line" | sudo tee -a "$filepath" >/dev/null
		logi "${LOG_TAG}" "Line $line successfully put in the $filepath file!"
	else
		logw "${LOG_TAG}" "The $filepath file already has this line. Skipping..."
	fi

}

stop_service() {
	logi "${LOG_TAG}" "Trying to stop ${1} service"
	sudo systemctl stop "$1".service
	logi "${LOG_TAG}" "Trying to disable ${1} service"
	sudo systemctl disable "$1".service
	logi "${LOG_TAG}" "Trying to mask ${1} service"
	sudo systemctl mask "${1}".service
}

usage() {
	printf "%sNAME%s\\n" "${BOLD}" "${NORMAL}"
	printf "%sconfig - Motorola ThinkShield Script Configuration\\n\\n" "${SPACES}"
	printf "%sSYNOPSIS%s\\n" "${BOLD}" "${NORMAL}"
	printf "%s%sconfig%s <%sOPTION%s>\\n\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${UNDERLINE}" "${NORMAL}"
	printf "%sDESCRIPTION%s\\n" "${BOLD}" "${NORMAL}"
	printf "%sConfiguration Script file for the Motorola ThinkShield Team. The script handles the installation of several services and tools used by the team in a daily basis.\\n\\n" "${SPACES}"

	printf "%s%s-a%s, %s--all%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall and configure everything .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-l%s, %s--libs%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall all the libs necessary to the tools and services .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-p%s, %s--pulse%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Pulsesecure .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-A%s, %s--android%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Android Studio and makes all the necessary configurations .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-c%s, %s--code%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Visual Studio Code .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-r%s, %s--cyber%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Cybereason .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-v%s, %s--vysor%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Vysor .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-t%s, %s--tmux%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall tmux .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-s%s, %s--ssh%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sconfigure ssh settings .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-g%s, %s--ggdrive%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall ggdrive utility .\\n\\n" "${SPACES}" "${SPACES}"
}

is_package_installed() {
	! [[ $(command -v "$1") = "" ]]
}
