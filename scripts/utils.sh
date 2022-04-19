#!/bin/bash

source ./log.sh

LOG_TAG="Utils"

BOLD=$(tput bold)
UNDERLINE=$(tput smul)
SPACES="       "
NORMAL=$(tput sgr0)

BASHRC_PATH="$HOME/.bashrc"

# Export to PATH a directory passed as argument
#
# @param $1 Is the path to be placed in the PATH.
#
path_export() {
	if [ -f "$BASHRC_PATH" ]; then
		if ! grep -qE "$1\$" "$BASHRC_PATH"; then
			if [ -d "$1" ]; then
				echo "export PATH=\$PATH:$1" >> "$BASHRC_PATH"
				logi "${LOG_TAG}" "Directory $1 successfully put into PATH."
			else
				loge "${LOG_TAG}" "The directory $1 does not exist. Unable to put it into PATH."
			fi
		else
			logw "${LOG_TAG}" "The .bashrc file already has this directory."
		fi
	else
		loge "${LOG_TAG}" "The bashrc file does not exist. Unable to put it into PATH."
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
}

is_package_installed() {
    ! [[ $(command -v "$1") = "" ]]
}
