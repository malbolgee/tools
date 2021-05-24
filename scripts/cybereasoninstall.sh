#!/bin/bash

# Download and install cybereason .deb package.
#
# The Cybereason Defense Platform combines endpoint prevention, detection, and
# response all in one lightweight agent. It's a Motorola requirement.
#
install_cybereason() {

    # fl "Execution install_cybereason script"

    if ! is_package_installed 'curl'; then
        fl "Installing curl..."
        sudo apt install -yf curl
    fi

    fl "Downloading Cybereason..."
    curl -O https://download1499.mediafire.com/1v4oh89raulg/9yfdlwx2blwdff1/cybereason.deb
    fl "Installing Cybereason..."
    sudo dpkg -i ./cybereason.deb
}

install_cybereason
