#!/bin/bash

# Download and install pulsesecure .deb package.
#
# The pulsesecure software is necessary for the Motorola VPN connection.
#
install_pulse() {

    if ! is_package_installed 'curl'; then
        fl "Installing curl..."
        sudo apt install -yf curl
    fi

    fl "Downloading Pulse..."
    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    https://github.com/malbolgee/tools/releases/download/v0.1/pulsesecure.deb

    sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu bionic main universe'
    sudo apt update && sudo apt install && sudo apt install -yft bionic libwebkitgtk-1.0-0

    fl "Installing Pulse..."
    sudo dpkg -i ./pulsesecure.deb

    rm -rf ./pulsesecure.deb
}

install_pulse
