#!/bin/bash

source ./log.sh

VYSOR_LOG_TAG="Vysor Install"

# Download and install the vysor software
function install_vysor() {
	if ! is_package_installed 'wget'; then
		logi "${VYSOR_LOG_TAG}" "installing wget..."
		sudo apt install -yf wget
	fi

	if ! is_package_installed 'vysor'; then
		logi "${VYSOR_LOG_TAG}" "Downloading Vysor.."

		wget --no-check-certificate\
		--content-disposition\
		--show-progress\
		https://github.com/malbolgee/tools/releases/download/v0.1/vysor.AppImage

		logi "${VYSOR_LOG_TAG}" "Changing the vysor.AppImage execution status"
		sudo chmod +x vysor.AppImage
		logi "${VYSOR_LOG_TAG}" "Moving vysor.AppImage to /usr/bin"
		sudo mv vysor.AppImage /usr/bin
		logi "${VYSOR_LOG_TAG}" "Creating Symbolic Link vysor.AppImage -> vysor"
		sudo ln -s /usr/bin/vysor.AppImage /usr/bin/vysor
	else
		logi "${VYSOR_LOG_TAG}" "Vysor is already installed."
	fi

    logi "${VYSOR_LOG_TAG}" "Vysor was successfully installed!"
}

install_vysor
