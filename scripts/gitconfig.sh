#!/bin/bash

GITCONFIG_LOG_TAG="Gitconfig"

if [ -z "${MAIN_LOADED-}" ]; then
	echo "The script must be accessed from main.sh"
	exit 1
fi

function configure_gitconfig() {
	logi "${GITCONFIG_LOG_TAG}" "Configuring your .gitconfig file"
	cp "$(dirname "$(pwd)")"/.assets/.gitconfig "${HOME}"/.gitconfig
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.gitconfig

	summary+=("The gitconfig has been configured")
}

configure_gitconfig
