#!/bin/bash

VYSOR_LOG_TAG="Vysor Install"

if [ -z "${MAIN_LOADED-}" ]; then
	echo "The script must be accessed from main.sh"
	exit 1
fi

# Download and install the vysor software
function install_vysor() {
	if ! is_package_installed 'vysor'; then
		_download_vysor
		_configure_vysor

		logi "${VYSOR_LOG_TAG}" "Vysor was successfully installed!"

		summary+=("Vysor has been installed")
	fi
}

function _download_vysor() {
	logi "${VYSOR_LOG_TAG}" "Downloading Vysor"

	local VYSOR_URL="https://github.com/malbolgee/tools/releases/download/v0.1/vysor.AppImage"

	if ! is_package_installed 'wget'; then
		logi "${VYSOR_LOG_TAG}" "installing wget..."
		sudo apt install -yf wget
	fi

	wget --no-check-certificate --content-disposition --show-progress "${VYSOR_URL}"
}

function _configure_vysor() {
	logi "${VYSOR_LOG_TAG}" "Changing the vysor.AppImage execution status"
	sudo chmod +x vysor.AppImage
	logi "${VYSOR_LOG_TAG}" "Moving vysor.AppImage to /usr/bin"
	sudo mv vysor.AppImage /usr/bin
	logi "${VYSOR_LOG_TAG}" "Creating Symbolic Link vysor.AppImage -> vysor"
	sudo ln -s /usr/bin/vysor.AppImage /usr/bin/vysor
}

install_vysor
