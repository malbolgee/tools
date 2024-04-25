#!/bin/bash

if [ -z "${LOG_LIB_LOADED-}" ]; then
    source ./log.sh
    export LOG_LIB_LOADED='y'
fi

if [ -z "${UTILS_LIB_LOADED-}" ]; then
    source ./utils.sh
    export UTILS_LIB_LOADED='y'
fi

LOG_TAG="Ggdrive Install"

install_ggdrive() {

    local REPOS_DIRECTORY="${HOME}"/repos
    local GGDRIVE_DIRECTORY=ggdrive
    local LOCAL_BIN_DIRECTORY="${HOME}"/.local/bin

    if [ ! -d "${REPOS_DIRECTORY}" ]; then
        logi "${LOG_TAG}" "${REPOS_DIRECTORY} directory does not exist, creating it"
        mkdir -p "${REPOS_DIRECTORY}"
    fi

    git clone https://github.com/malbolgee/ggdrive.git "${REPOS_DIRECTORY}"/${GGDRIVE_DIRECTORY}
    git -C "${REPOS_DIRECTORY}"/${GGDRIVE_DIRECTORY}/ checkout fix/progress_logger

    cp "$(dirname "$(pwd)")"/.assets/config_env.sh "${REPOS_DIRECTORY}"/${GGDRIVE_DIRECTORY}/

    cd "${REPOS_DIRECTORY}"/${GGDRIVE_DIRECTORY}/ || exit

    ./config_env.sh

    cd - || exit

    if [ ! -d "${LOCAL_BIN_DIRECTORY}" ]; then
        logi "${LOG_TAG}" "${LOCAL_BIN_DIRECTORY} directory does not exist, creating it"
        mkdir -p "${LOCAL_BIN_DIRECTORY}"
    fi

    logi "${LOG_TAG}" "Creating symlink to gdrive"
    ln -s "${REPOS_DIRECTORY}"/${GGDRIVE_DIRECTORY}/gdrive "${LOCAL_BIN_DIRECTORY}"/gdrive

    logi "${LOG_TAG}" "Exporting ${LOCAL_BIN_DIRECTORY} directory"
    path_export "${LOCAL_BIN_DIRECTORY}"
}

install_ggdrive
