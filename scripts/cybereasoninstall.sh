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

    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    https://github.com/malbolgee/tools/releases/download/v0.1/cybereason.deb

    fl "Installing Cybereason..."
    sudo dpkg -i ./cybereason.deb
}

install_cybereason
