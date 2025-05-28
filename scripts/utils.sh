#!/bin/bash

source ./log.sh

UTILS_LOG_TAG="Utils"

BASHRC_PATH="$HOME/.bashrc"

# Export to PATH a directory passed as argument
#
# @param $1 Is the path to be placed in the PATH.
#
function path_export() {

	local line=$1

	if [ ! -d "$line" ]; then
		loge "${UTILS_LOG_TAG}" "The directory $1 does not exist. Unable to put it into PATH."
	fi

	_put_line_in_file "export PATH=$line:\$PATH" "$BASHRC_PATH"

}

# Add a PPA repository source into the source.list file
function add_source_ppa() {

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
function _put_line_in_file() {

	local line=$1
	local filepath=$2

	if [ ! -f "$filepath" ]; then
		loge "${UTILS_LOG_TAG}" "The $filepath file does not exist."
	fi

	if ! grep -qE "$line" "$filepath"; then
		sudo echo "$line" | sudo tee -a "$filepath" >/dev/null
		logi "${UTILS_LOG_TAG}" "Line $line successfully put in the $filepath file!"
	else
		logw "${UTILS_LOG_TAG}" "The $filepath file already has this line. Skipping..."
	fi

}

function stop_service() {
	logi "${UTILS_LOG_TAG}" "Trying to stop ${1} service"
	sudo systemctl stop "$1".service
	logi "${UTILS_LOG_TAG}" "Trying to disable ${1} service"
	sudo systemctl disable "$1".service
	logi "${UTILS_LOG_TAG}" "Trying to mask ${1} service"
	sudo systemctl mask "${1}".service
}

function prompt_coreid_question() {
	read -p "${RED}Is ${BOLD}\"${COREID}\" ${NORMAL}${RED}your coreid? [yN] ${NORMAL}" yn

	if [[ "$yn" =~ [yY] ]] || [ -z "$yn" ]; then
		COREID="$USER"
	else
		while true; do
			read -p "${RED}Provide your coreid${NORMAL}: " coreid

			if [ -n "$coreid" ]; then
				COREID="$coreid"
				break
			fi
		done
	fi
}

function is_on_server() {
	[[ -n "$SSH_CONNECTION" ]]
}

function usage() {
	printf "%sNAME%s\\n" "${BOLD}" "${NORMAL}"
	printf "%sconfig - Motorola ThinkShield Script Configuration\\n\\n" "${SPACES}"
	printf "%sSYNOPSIS%s\\n" "${BOLD}" "${NORMAL}"
	printf "%s%s./main.sh%s <%sOPTION%s> {OPTION}\\n\\n" "${SPACES}" "${BOLD}" "${NORMAL}" "${UNDERLINE}" "${NORMAL}"
	printf "%sDESCRIPTION%s\\n" "${BOLD}" "${NORMAL}"
	printf "%sConfiguration Script file for the Motorola ThinkShield Team. The script handles the installation of several services and tools used by the team in a daily basis.\\n\\n" "${SPACES}"

	printf "%s%s-a%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall and configure everything .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-l%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall all the libs necessary to the tools and services .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-p%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Pulsesecure .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-A%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Android Studio and makes all the necessary configurations .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-c%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Visual Studio Code .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-r%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall Cybereason .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-v%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall scrcpy .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-t%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall tmux .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-s%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sconfigure ssh settings .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-i%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sconfigure the gitconfig file .\\n\\n" "${SPACES}" "${SPACES}"
	printf "%s%s-g%s\\n" "${SPACES}" "${BOLD}" "${NORMAL}"
	printf "%s%sinstall ggdrive utility .\\n\\n" "${SPACES}" "${SPACES}"
}

function is_package_installed() {
	! [[ $(command -v "$1") = "" ]]
}
