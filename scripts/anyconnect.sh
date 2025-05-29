#!/bin/bash

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

export ANY_CONNECT_LOG_TAG="Any Connect VPN Install"
export DOWNLOAD_PATH="$HOME/opt"
export ANY_CONNECT_URL="https://github.com/malbolgee/tools/releases/download/v0.1/anyconnect.tar.gz"

function install_any_connect() {
    _download_any_connect
    _extract
    _install_vpn
    _install_iseposture
    _clear

    logi "${PULSE_LOG_TAG}" "Any Connect VPN installation is done"

    summary+=("Any Connect VPN has been installed")
}

function _download_any_connect() {
    logi "${ANY_CONNECT_LOG_TAG}" "Downloading"

    if ! is_package_installed 'wget'; then
        logi "${PULSE_LOG_TAG}" "installing wget..."
        sudo apt install -yf wget
    fi

    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    ${ANY_CONNECT_URL}
}

function _extract() {
	if [ ! -d "$DOWNLOAD_PATH" ]; then
		logi "${ANY_CONNECT_LOG_TAG}" "Directory $DOWNLOAD_PATH does not exist. Creating it."
        mkdir -p "$DOWNLOAD_PATH"
	fi

    tar xvzf anyconnect.tar.gz -C "$DOWNLOAD_PATH"
}

function _install_vpn() {
    cd "$DOWNLOAD_PATH/anyconnect/vpn/" || exit
    yes 'y' | sudo "$DOWNLOAD_PATH/anyconnect/vpn/vpn_install.sh"
    cd - || exit
}

function _install_iseposture() {
    mv "$DOWNLOAD_PATH/anyconnect/ISEPostureCFG.xml" "$DOWNLOAD_PATH/anyconnect/iseposture/ISEPostureCFG.xml"
    cd "$DOWNLOAD_PATH/anyconnect/iseposture/" || exit
    yes 'y' | sudo "$DOWNLOAD_PATH/anyconnect/iseposture/iseposture_install.sh"
    cd - || exit
}

function _clear() {
    rm -rf anyconnect.tar.gz
}

if ! is_on_server; then
    install_any_connect
fi

unset ANY_CONNECT_LOG_TAG
unset DOWNLOAD_PATH
unset ANY_CONNECT_URL
