#!/bin/bash

source ./log.sh

LOG_TAG="Cybereason Install"

# Download and install cybereason .deb package.
#
# The Cybereason Defense Platform combines endpoint prevention, detection, and
# response all in one lightweight agent. It's a Motorola requirement.
#
install_cybereason() {

    if ! is_package_installed 'curl'; then
        logi "${LOG_TAG}" "curl is not installed, installing curl..."
        sudo apt install -yf curl
    fi

    logi "${LOG_TAG}" "Downloading Cybereason..."

    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    https://github.com/malbolgee/tools/releases/download/v0.1/cybereason.deb

    logi "${LOG_TAG}" "Installing Cybereason..."
    sudo dpkg -i ./cybereason.deb && logi "${LOG_TAG}" "Cybereason has been successfully installed!"

    logi "${LOG_TAG}" "Removing trash..."
    rm -rf ./cybereason.deb
}

install_cybereason
