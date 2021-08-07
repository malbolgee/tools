#!/bin/bash

# Download and install Aras through Wine
#
# In order to be able to use this software, you need to be under the 'INDT'
# network either by being physically there or through a VPN.
#
install_aras() {

    if ! ispackage_installed 'wine'; then
        fl "Installing Wine..."
        sudo apt install -yf wine
    fi

    if ! is_package_installed 'curl'; then
        fl "Installing Curl..."
        sudo apt install -yf curl
    fi

    fl "Downloading Aras..."

    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    https://github.com/malbolgee/tools/releases/download/v0.1/aras.exe

    fl "Installing Aras through Wine..."
    sudo wine ./aras.exe
}

install_aras
