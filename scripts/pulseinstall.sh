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

    sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu bionic main universe'
    sudo apt update && sudo apt install && sudo apt install -yft bionic libwebkitgtk-1.0-0

    logi "${LOG_TAG}" "Installing Pulse..."
    sudo dpkg -i ./pulsesecure.deb

    logi "${LOG_TAG}" "Removing trash.."
    rm -rf ./pulsesecure.deb

    make_connections

    logi "${LOG_TAG}" "Pulse was successfully installed!"
}

make_connections() {

    FILE_NAME=".pulse_Connections.txt"
    FILE_PATH="$HOME/.pulse_secure/pulse/"

    if [ ! -d "$FILE_PATH" ]; then
        logi "${LOG_TAG}" "Directory ${FILE_PATH} does not exist, creating it.."
        mkdir -p "${FILE_PATH}"
    fi

    logi "${LOG_TAG}" "Creating pulse connections..."
    echo '{"connName":"motorola_us","baseUrl":"https://partnervpn.motorola.com/7121","preferredCert":""}' >> "${FILE_PATH}"/${FILE_NAME}
    echo '{"connName":"motorola_br","baseUrl":"https://br-partnervpn.motorola.com/7121","preferredCert":""}' >> "${FILE_PATH}"/${FILE_NAME}

    logi "${LOG_TAG}" "Connections succssefully created!"
}

install_pulse
