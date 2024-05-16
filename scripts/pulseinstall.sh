#!/bin/bash

# shellcheck source=/dev/null
source ./log.sh

LOG_TAG="Pulse Install"

# Download and install pulsesecure .deb package.
#
# The pulsesecure software is necessary for the Motorola VPN connection.
#
install_pulse() {

    if ! is_package_installed 'curl'; then
        logi "${LOG_TAG}" "curl is not installed, installing curl..."
        sudo apt install -yf curl
    fi

    logi "${LOG_TAG}" "Downloading Pulse..."
    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    https://github.com/malbolgee/tools/releases/download/v0.1/pulsesecure.deb
    
    logi "${LOG_TAG}" "Adding repository"

    local gpg_key="3B4FE6ACC0B21F32"
    local filepath="/etc/apt/sources.list"
    local br_mirror="deb http://br.archive.ubuntu.com/ubuntu bionic main universe"
    local us_mirror="deb http://mirrors.kernel.org/ubuntu bionic main universe"

    add_source_ppa "$br_mirror" "$filepath"
    add_source_ppa "$us_mirror" "$filepath"

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "$gpg_key"
    logi "${LOG_TAG}" "Updating"
    sudo apt-get update

    logi "${LOG_TAG}" "Installing packages"
    sudo apt-get install -y libgdk-pixbuf2.0-0
    sudo apt-get install -y libnss3-tools
    sudo apt-get install -yft bionic libwebkitgtk-1.0-0

    logi "${LOG_TAG}" "Installing Pulse..."
    sudo dpkg -i ./pulsesecure.deb

    logi "${LOG_TAG}" "Removing trash.."
    rm -rf ./pulsesecure.deb

    logi "${LOG_TAG}" "Pulse was successfully installed!"
}

install_pulse
