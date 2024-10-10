#!/bin/bash

SCRCPY_LOG_TAG="scrcpy Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

function install_scrcpy() {
    local REPOS_DIRECTORY="${HOME}"/repos
    local SCRCPY_DIRECTORY=scrcpy
    local ANDROID_SDK_DIRECTORY="${HOME}/Android/Sdk"
    local GITHUB_REPO_LINK="https://github.com/Genymobile/scrcpy.git"

    _clone_repository
    _install_required_packages
    _build_and_install

    logi "${SCRCPY_LOG_TAG}" "scrcpy installation is done"
    summary+=("scrcpy has been installed")

}

function _install_required_packages() {
    logi "${SCRCPY_LOG_TAG}" "Installing required packages"

    sudo apt install -yf ffmpeg libsdl2-2.0-0 libusb-1.0-0
    sudo apt install -yf gcc pkg-config meson ninja-build libsdl2-dev \
        libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
        libswresample-dev libusb-1.0-0-dev

    sudo apt install -yf openjdk-17-jdk
}

function _clone_repository() {
    logi "${SCRCPY_LOG_TAG}" "Cloning scrcpy repository"
    if [ ! -d "${REPOS_DIRECTORY}" ]; then
        logi "${SCRCPY_LOG_TAG}" "${REPOS_DIRECTORY} directory does not exist, creating it"
        mkdir -p "${REPOS_DIRECTORY}"
    fi

    git clone --depth=1 --branch=master "${GITHUB_REPO_LINK}" "${REPOS_DIRECTORY}"/"${SCRCPY_DIRECTORY}"
}

function _build_and_install() {
    logi "${SCRCPY_LOG_TAG}" "Building and installing"

    if [ ! -d "${ANDROID_SDK_DIRECTORY}" ]; then
        loge "${SCRCPY_LOG_TAG}" "Cannot build scrcpy, Android sdk directory not found"
        echo "false"
    else
        export ANDROID_SDK_ROOT="${ANDROID_SDK_DIRECTORY}"
        cd "${REPOS_DIRECTORY}"/"${SCRCPY_DIRECTORY}"/ || exit
        meson setup x --buildtype=release --strip -Db_lto=true
        ninja -Cx
        sudo ninja -Cx install
        unset ANDROID_SDK_ROOT
        cd - || exit
        echo "true"
    fi
}

install_scrcpy
