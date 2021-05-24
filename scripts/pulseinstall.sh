#!/bin/bash

# Download and install pulsesecure .deb package.
#
# The pulsesecure software is necessary for the Motorola VPN connection.
#
install_pulse() {

    # fl "Execution install_pulse script"
    if ! is_package_installed 'curl'; then
        fl "Installing curl..."
        sudo apt install -yf curl
    fi

    fl "Downloading Pulse..."
    curl -O https://download1501.mediafire.com/hn2xtiqndrcg/gyhmdjiagczph6y/pulsesecure.deb
    sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu bionic main universe'
    sudo apt update && sudo apt install && sudo apt install -t bionic libwebkitgtk-1.0-0
    fl "Installing Pulse..."
    sudo dpkg -i ./pulsesecure.deb
}

install_pulse
