#!/usr/bin/env bash

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

export ANY_CONNECT_LOG_TAG="Any Connect VPN Install"
export DOWNLOAD_PATH="$HOME/opt"
export ANY_CONNECT_URL="https://github.com/malbolgee/tools/releases/download/v0.1/anyconnect.tar.gz"

function install_any_connect() {
    _download_any_connect || return 1
    _extract || return 1
    _install_vpn || return 1
    _install_iseposture || return 1
    _clear || return 1

    logi "${ANY_CONNECT_LOG_TAG}" "Any Connect VPN installation is done"
}

function _download_any_connect() {
    logi "${ANY_CONNECT_LOG_TAG}" "Downloading"

    if ! is_package_installed 'wget'; then
        logi "${ANY_CONNECT_LOG_TAG}" "installing wget..."
        sudo apt install -yf wget || return 1
    fi

    wget --no-check-certificate --content-disposition --show-progress ${ANY_CONNECT_URL} || return 1
}

function _extract() {
    if [ ! -d "$DOWNLOAD_PATH" ]; then
        logi "${ANY_CONNECT_LOG_TAG}" "Directory $DOWNLOAD_PATH does not exist. Creating it."
        mkdir -p "$DOWNLOAD_PATH" || return 1
    fi

    tar xvzf anyconnect.tar.gz -C "$DOWNLOAD_PATH" || return 1
}

function _install_vpn() {
    cd "$DOWNLOAD_PATH/anyconnect/vpn/" || return 1
    yes 'y' | sudo "$DOWNLOAD_PATH/anyconnect/vpn/vpn_install.sh" || return 1
    cd - || return 1
}

function _install_iseposture() {
    mv "$DOWNLOAD_PATH/anyconnect/ISEPostureCFG.xml" "$DOWNLOAD_PATH/anyconnect/iseposture/ISEPostureCFG.xml" || return 1
    cd "$DOWNLOAD_PATH/anyconnect/iseposture/" || return 1
    yes 'y' | sudo "$DOWNLOAD_PATH/anyconnect/iseposture/iseposture_install.sh" || return 1
    cd - || return 1
}

function _clear() {
    rm -rf anyconnect.tar.gz
}

if ! is_on_server; then
    if install_any_connect; then
        summary+=("Any Connect VPN has been installed")
    else
        loge "${ANY_CONNECT_LOG_TAG}" "Installation failed."
    fi
fi

unset ANY_CONNECT_LOG_TAG
unset DOWNLOAD_PATH
unset ANY_CONNECT_URL
