#!/usr/bin/env bash

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

GITCONFIG_LOG_TAG="Gitconfig"

function configure_gitconfig() {
    logi "${GITCONFIG_LOG_TAG}" "Configuring your .gitconfig file"
    cp "$(dirname "$(pwd)")"/.assets/.gitconfig "${HOME}"/.gitconfig || return 1
    sed -i "s/coreid/${COREID}/g" "${HOME}"/.gitconfig || return 1
}

if configure_gitconfig; then
    summary+=("The gitconfig has been configured")
else
    loge "${GITCONFIG_LOG_TAG}" "Configuration failed."
fi
