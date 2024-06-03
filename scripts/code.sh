#!/bin/bash

CODE_LOG_TAG="Vistual Studio Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

function install_visual_code() {
    _config_vscode_gpg_keys
    _install_visual_code

    summary+=("Vistual Studio Code has been installed")
}

function _config_vscode_gpg_keys() {
    logi "${CODE_LOG_TAG}" "Configuring GPG keys"

    local VSCODE_ASC_KEY_URL="https://packages.microsoft.com/keys/microsoft.asc"

    wget -qO- "${VSCODE_ASC_KEY_URL}" | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
}

function _install_visual_code() {
    sudo apt update
    logi "${CODE_LOG_TAG}" "Trying to install"
    sudo apt install -yf code && logi "${CODE_LOG_TAG}" "Vistual Studio Code successfully installed!"
}

install_visual_code
