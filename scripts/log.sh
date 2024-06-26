#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
NORMAL=$(tput sgr0)

BOLD=$(tput bold)
UNDERLINE=$(tput smul)
SPACES="       "

# @param $1 - is the log tag of the file being logged
# @param $2 - is the message to be logged
function logi() {
    printf "%sINFO%s: [%s] - %s\\n" "${BLUE}" "${NORMAL}" "$1" "$2"
}

# @param $1 - is the log tag of the file being logged
# @param $2 - is the message to be logged
function loge() {
    printf "%sERROR%s: [%s] - %s\\n" "${RED}" "${NORMAL}" "$1" "$2"
}

# @param $1 - is the log tag of the file being logged
# @param $2 - is the message to be logged
function logw() {
    printf "%sWARNING%s: [%s] - %s\\n" "${YELLOW}" "${NORMAL}" "$1" "$2"
}

# @param $1 - is the log tag of the file being logged
# @param $2 - is the message to be logged
function logd() {
    printf "%sDEBUG%s: [%s] - %s\\n" "${CYAN}" "${NORMAL}" "$1" "$2"
}
