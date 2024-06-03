#!/bin/bash

DRIVE_LOG_TAG="Ggdrive Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

function install_ggdrive() {
    local REPOS_DIRECTORY="${HOME}"/repos
    local GGDRIVE_DIRECTORY=ggdrive
    local LOCAL_BIN_DIRECTORY="${HOME}"/.local/bin
    local DOT_GDRIVE_DIRECTORY="${HOME}"/.gdrive
    local GITHUB_REPO_LINK="https://github.com/malbolgee/ggdrive.git"

    logi "${DRIVE_LOG_TAG}" "Configuring ggdrive"

    _clone_repository
    _prepare_env
    _create_symlink
    _export_and_set_data_file

    logi "${DRIVE_LOG_TAG}" "ggdrive configuration is done"

    summary+=("ggdrive tool has been configured")
}

function _clone_repository() {
    logi "${DRIVE_LOG_TAG}" "Cloning ggdrive repository"
    if [ ! -d "${REPOS_DIRECTORY}" ]; then
        logi "${DRIVE_LOG_TAG}" "${REPOS_DIRECTORY} directory does not exist, creating it"
        mkdir -p "${REPOS_DIRECTORY}"
    fi

    git clone "${GITHUB_REPO_LINK}" "${REPOS_DIRECTORY}"/"${GGDRIVE_DIRECTORY}"
    cp "$(dirname "$(pwd)")"/.assets/config_env.sh "${REPOS_DIRECTORY}"/"${GGDRIVE_DIRECTORY}"/
}

function _prepare_env() {
    logi "${DRIVE_LOG_TAG}" "Preparing ggdrive env"
    cd "${REPOS_DIRECTORY}"/"${GGDRIVE_DIRECTORY}"/ || exit
    ./config_env.sh
    cd - || exit
}

function _create_symlink() {
    logi "${DRIVE_LOG_TAG}" "Creating ggdrive symlink"
    if [ ! -d "${LOCAL_BIN_DIRECTORY}" ]; then
        logi "${DRIVE_LOG_TAG}" "${LOCAL_BIN_DIRECTORY} directory does not exist, creating it"
        mkdir -p "${LOCAL_BIN_DIRECTORY}"
    fi

    ln -s "${REPOS_DIRECTORY}"/"${GGDRIVE_DIRECTORY}"/gdrive "${LOCAL_BIN_DIRECTORY}"/gdrive
}

function _export_and_set_data_file() {
    logi "${DRIVE_LOG_TAG}" "Exporting ${LOCAL_BIN_DIRECTORY} directory"
    path_export "${LOCAL_BIN_DIRECTORY}"

    logi "${DRIVE_LOG_TAG}" "Copying data_config.json file to ${DOT_GDRIVE_DIRECTORY} directory"
    cp "$(dirname "$(pwd)")"/.assets/data_config.json "${DOT_GDRIVE_DIRECTORY}"
}

install_ggdrive
