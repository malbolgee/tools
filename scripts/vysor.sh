#!/bin/bash

# Download and install the vysor software

install_vysor() {

    if ! is_package_installed 'curl'; then
        fl "Installing curl..."
        sudo apt install -yf curl
    fi

    if ! is_package_installed 'vysor'; then
        fl "Downloading Vysor..."

	wget --no-check-certificate\
	--content-disposition\
	--show-progress\
	https://github.com/malbolgee/tools/releases/download/v0.1/vysor.AppImage

    sudo chmod +x vysor.AppImage
    sudo mv vysor.AppImage /usr/bin
    sudo ln -s /usr/bin/vysor.AppImage /usr/bin/vysor
    else
        fl "Vysor is already installed."
    fi
}

install_vysor
