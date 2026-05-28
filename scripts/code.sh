#!/usr/bin/env bash

CODE_LOG_TAG="Vistual Studio Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

function install_visual_code() {
    _config_vscode_gpg_keys || return 1
    _install_visual_code || return 1
}

function _config_vscode_gpg_keys() {
    logi "${CODE_LOG_TAG}" "Configuring GPG keys"

    local VSCODE_ASC_KEY_URL="https://packages.microsoft.com/keys/microsoft.asc"

    sudo apt install -yf wget gpg || return 1
    wget -qO- "${VSCODE_ASC_KEY_URL}" | gpg --dearmor >packages.microsoft.gpg || return 1
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg || return 1
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null || return 1
    rm -f packages.microsoft.gpg
}

function _install_visual_code() {
    sudo apt install -yf apt-transport-https || return 1
    sudo apt update || return 1
    logi "${CODE_LOG_TAG}" "Trying to install"
    sudo apt install -yf code || return 1
    logi "${CODE_LOG_TAG}" "Vistual Studio Code successfully installed!"
}

if ! is_on_server; then
    if install_visual_code; then
        summary+=("Vistual Studio Code has been installed")
    else
        loge "${CODE_LOG_TAG}" "Installation failed."
    fi
fi
