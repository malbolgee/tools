#!/bin/bash

source ./log.sh

LOG_TAG="Vysor Install"

# Download and install the vysor software
install_vysor() {

	if ! is_package_installed 'curl'; then
		logi "${LOG_TAG}" "curl is not installed, installing curl..."
		sudo apt install -yf curl
	fi

	if ! is_package_installed 'vysor'; then
		logi "${LOG_TAG}" "Downloading Vysor.."

		wget --no-check-certificate\
		--content-disposition\
		--show-progress\
		https://github.com/malbolgee/tools/releases/download/v0.1/vysor.AppImage

		logi "${LOG_TAG}" "Changing the vysor.AppImage execution status"
		sudo chmod +x vysor.AppImage
		logi "${LOG_TAG}" "Moving vysor.AppImage to /usr/bin"
		sudo mv vysor.AppImage /usr/bin
		logi "${LOG_TAG}" "Creating Symbolic Link vysor.AppImage -> vysor"
		sudo ln -s /usr/bin/vysor.AppImage /usr/bin/vysor
	else
		logi "${LOG_TAG}" "Vysor is already installed."
	fi

    logi "${LOG_TAG}" "Vysor was successfully installed!"
}

install_vysor
