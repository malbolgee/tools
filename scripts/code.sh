#!/bin/bash

source ./log.sh

LOG_TAG="Vistual Studio Install"

install_visual_code() {

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo apt update
    logi "${LOG_TAG}" "Trying to install Visual Studio Code..."
    sudo apt install -yf code && logi "${LOG_TAG}" "Vistual Studio Code successfully installed!"
}

install_visual_code
