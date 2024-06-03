#!/bin/bash

CYBER_LOG_TAG="Cybereason Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

# Download and install cybereason .deb package.
#
# The Cybereason Defense Platform combines endpoint prevention, detection, and
# response all in one lightweight agent. It's a Motorola requirement.
#
function install_cybereason() {
    _download_cybereason
    _install_cyberreason

    summary+=("Cybereason has been installed")
}

function _download_cybereason() {
    logi "${CYBER_LOG_TAG}" "Downloading Cybereason"

    local CYBER_URL="https://github.com/malbolgee/tools/releases/download/v0.1/cybereason.deb"

    if ! is_package_installed 'wget'; then
        logi "${CYBER_LOG_TAG}" "installing wget"
        sudo apt install -yf wget
    fi

    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    "${CYBER_URL}"
}

function _install_cyberreason() {
    logi "${CYBER_LOG_TAG}" "Installing Cybereason"
    sudo dpkg -i ./cybereason.deb && logi "${CYBER_LOG_TAG}" "Cybereason has been successfully installed!"

    logi "${CYBER_LOG_TAG}" "Removing trash"
    rm -rf ./cybereason.deb
}

install_cybereason
