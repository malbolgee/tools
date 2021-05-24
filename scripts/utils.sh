#!/bin/bash

RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"
BOLD="\e[1m"
UNDERLINE="\e[4m"
SPACES="       "
NORMAL=$ENDCOLOR

BASHRC_PATH="$HOME/.bashrc"

# Log error messages
#
# @param $1 Is the message to be logged.
#
fe() {
    echo -e "${RED}Error${ENDCOLOR}: $1"
}

# Log warning messages
#
# @param $1 Is the message to be logged.
#
fw() {
    echo -e "${YELLOW}Warning${ENDCOLOR}: $1"
}

# Log info messages
#
# @param $1 Is the message to be logged.
#
fl() {
    echo -e "${BLUE}Info${ENDCOLOR}: $1"
}

# Log success messages
#
# @param $1 Is the message to be logged.
#
fs() {
    echo -e "${GREEN}Success${ENDCOLOR}: $1"
}

# Export to PATH a directory passed as argument
#
# @param $1 Is the path to be placed in the PATH.
#
path_export() {
    if [ -f $BASHRC_PATH ]; then
        if ! grep -qE "$1\$" $BASHRC_PATH; then # Returns 0 if something was found; 1 if not;
            if [ -d $1 ]; then
                fs "Directory '$1' successfully put into PATH."
            else
                fe "The directory '$1' does not exist. Unable to put it into PATH."
            fi
        else
            fw "The .bashrc file already has this directory."
        fi
    else
        fe "The bashrc file does not exist. Unable to put it into PATH."
    fi
}

stop_service() {
    fl "Trying to stop ${1} service"
    sudo systemctl stop $1.service
    fl "Trying to disable ${1} service"
    sudo systemctl disable $1.service
}

usage() {
    printf "${BOLD}NAME${NORMAL}\n"
    printf "${SPACES}config - Motorola ThinkShield Script Configuration\n\n"
    printf "${BOLD}SYNOPSIS${NORMAL}\n"
    printf "${SPACES}${BOLD}config${NORMAL} <${UNDERLINE}OPTION${NORMAL}>\n\n"
    printf "${BOLD}DESCRIPTION${NORMAL}\n"
    printf "${SPACES}Configuration Script file for the Motorola ThinkShield Team. The script handles the installation of several services and tools used by the team in a daily basis.\n\n"

    printf "${SPACES}${BOLD}-a${NORMAL}, ${BOLD}--all${NORMAL}\n"
    printf "${SPACES}${SPACES}install and configure everything .\n\n"
    printf "${SPACES}${BOLD}-l${NORMAL}, ${BOLD}--libs${NORMAL}\n"
    printf "${SPACES}${SPACES}install all the libs necessary to the tools and services .\n\n"
    printf "${SPACES}${BOLD}-p${NORMAL}, ${BOLD}--pulse${NORMAL}\n"
    printf "${SPACES}${SPACES}install Pulsesecure .\n\n"
    printf "${SPACES}${BOLD}-A${NORMAL}, ${BOLD}--android${NORMAL}\n"
    printf "${SPACES}${SPACES}install Android Studio and makes all the necessary configurations .\n\n"
    printf "${SPACES}${BOLD}-c${NORMAL}, ${BOLD}--code${NORMAL}\n"
    printf "${SPACES}${SPACES}install Visual Studio Code .\n\n"
    printf "${SPACES}${BOLD}-r${NORMAL}, ${BOLD}--cyber${NORMAL}\n"
    printf "${SPACES}${SPACES}install Cybereason .\n\n"
    printf "${SPACES}${BOLD}-i${NORMAL}, ${BOLD}--aras${NORMAL}\n"
    printf "${SPACES}${SPACES}install Aras .\n\n"
}

is_package_installed() {
    ! [[ $(command -v $1) = "" ]]
}
