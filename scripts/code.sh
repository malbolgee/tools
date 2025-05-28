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

    sudo apt install -yf wget gpg
    wget -qO- "${VSCODE_ASC_KEY_URL}" | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
}

function _install_visual_code() {
    sudo apt install -yf apt-transport-https
    sudo apt update
    logi "${CODE_LOG_TAG}" "Trying to install"
    sudo apt install -yf code && logi "${CODE_LOG_TAG}" "Vistual Studio Code successfully installed!"
}

if ! is_on_server; then
    install_visual_code
fi
