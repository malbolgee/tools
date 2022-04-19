#!/bin/bash

blue=$(tput setaf 4)
normal=$(tput sgr0)

LOG_TAG="pulseinstall"

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

    make_connections

    printf "%sINFO%s::%s:: Pulse was successfully installed!\\n" "${blue}" "${normal}" "${LOG_TAG}"
}

make_connections() {

    FILE_NAME=".pulse_Connections.txt"
    FILE_PATH="$HOME/.pulse_secure/pulse/"

    if [ ! -d "$FILE_PATH" ]; then
        printf "%sINFO%s::%s:: Directory %s does not exist, creating it...\\n" "${blue}" "${normal}" "${LOG_TAG}" "${FILE_PATH}"
        mkdir -p "${FILE_PATH}"
    fi

    echo '{"connName":"motorola_en","baseUrl":"https://partnervpn.motorola.com/7121-otp","preferredCert":""}' >> "${FILE_PATH}"/${FILE_NAME}
    echo '{"connName":"motorola_br","baseUrl":"https://br-partnervpn.motorola.com/7121-otp","preferredCert":""}' >> "${FILE_PATH}"/${FILE_NAME}

    printf "%sINFO%s::%s:: Connections succssefully created!\\n" "${blue}" "${normal}" "${LOG_TAG}"
}

install_pulse
