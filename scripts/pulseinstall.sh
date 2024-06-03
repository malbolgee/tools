#!/bin/bash

PULSE_LOG_TAG="Pulse Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

# Download and install pulsesecure .deb package.
#
# The pulsesecure software is necessary for the Motorola VPN connection.
#
function install_pulse() {
    _download_pulse
    _add_ppa
    _install_required_packages
    _install_pulse

    logi "${PULSE_LOG_TAG}" "PulseSecure installation is done"

    summary+=("PulseSecure has been installed")
}

function _download_pulse() {
    logi "${PULSE_LOG_TAG}" "Downloading"

    local PULSE_URL="https://github.com/malbolgee/tools/releases/download/v0.1/pulsesecure.deb"

    if ! is_package_installed 'wget'; then
        logi "${PULSE_LOG_TAG}" "installing wget..."
        sudo apt install -yf wget
    fi

    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    ${PULSE_URL}
}

function _add_ppa() {
    logi "${PULSE_LOG_TAG}" "Adding legacy repository"

    local gpg_key="3B4FE6ACC0B21F32"
    local filepath="/etc/apt/sources.list"
    local br_mirror="deb http://br.archive.ubuntu.com/ubuntu bionic main universe"
    local us_mirror="deb http://mirrors.kernel.org/ubuntu bionic main universe"

    add_source_ppa "$br_mirror" "$filepath"
    add_source_ppa "$us_mirror" "$filepath"

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "$gpg_key"
    logi "${PULSE_LOG_TAG}" "Updating"
    sudo apt-get update
}

function _install_required_packages() {
    logi "${PULSE_LOG_TAG}" "Installing required packages"
    sudo apt-get install -y libgdk-pixbuf2.0-0
    sudo apt-get install -y libnss3-tools
    sudo apt-get install -yft bionic libwebkitgtk-1.0-0
}

function _install_pulse() {
    logi "${PULSE_LOG_TAG}" "Installing"
    sudo dpkg -i ./pulsesecure.deb

    logi "${PULSE_LOG_TAG}" "Removing trash"
    rm -rf ./pulsesecure.deb
}

install_pulse
