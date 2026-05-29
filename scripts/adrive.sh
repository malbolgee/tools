#!/usr/bin/env bash

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

DRIVE_LOG_TAG="Adrive Install"

function install_adrive() {
    local REPOS_DIRECTORY="${HOME}"/repos
    local ADRIVE_DIRECTORY="adrive"
    local GITHUB_REPO_LINK="https://github.com/malbolgee/adrive.git"

    logi "${DRIVE_LOG_TAG}" "Configuring adrive"

    if ! is_package_installed python3; then
        loge "${DRIVE_LOG_TAG}" "python3 is not installed. Please install it first."
        return 1
    fi

    _clone_repository || return 1
    _execute_install || return 1

    logi "${DRIVE_LOG_TAG}" "adrive install is done"
}

function _clone_repository() {
    logi "${DRIVE_LOG_TAG}" "Cloning adrive repository"
    if [ ! -d "${REPOS_DIRECTORY}" ]; then
        logi "${DRIVE_LOG_TAG}" "${REPOS_DIRECTORY} directory does not exist, creating it"
        mkdir -p "${REPOS_DIRECTORY}" || return 1
    fi

    if [ -d "${REPOS_DIRECTORY}/${ADRIVE_DIRECTORY}" ]; then
        logi "${DRIVE_LOG_TAG}" "Directory ${REPOS_DIRECTORY}/${ADRIVE_DIRECTORY} already exists. Cleaning up."
        rm -rf "${REPOS_DIRECTORY:?}/${ADRIVE_DIRECTORY:?}" || return 1
    fi

    git clone "${GITHUB_REPO_LINK}" "${REPOS_DIRECTORY}/${ADRIVE_DIRECTORY}" || return 1
}

function _execute_install() {
    logi "${DRIVE_LOG_TAG}" "Executing adrive install script"
    cd "${REPOS_DIRECTORY}/${ADRIVE_DIRECTORY}" || return 1
    chmod +x install.sh || return 1
    ./install.sh || return 1
}

if install_adrive; then
    summary+=("adrive tool has been installed")
else
    loge "${DRIVE_LOG_TAG}" "Installation failed."
fi
