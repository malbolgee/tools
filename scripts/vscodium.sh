#!/bin/bash

CODIUM_LOG_TAG="VSCdodium Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

function install_vscodium() {
    logi "${CODIUM_LOG_TAG}" "Installing vscodium from snap"
    snap install codium --classic
}

install_vscodium
