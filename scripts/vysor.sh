#!/bin/bash

# Download and install the vysor software

install_vysor() {

    if ! is_package_installed 'curl'; then
        fl "Installing curl..."
        sudo apt install -yf curl
    fi

    if ! is_package_installed 'vysor'; then
        fl "Downloading Vysor..."
        curl -O https://download1593.mediafire.com/bg63ppq0l1ug/iqqmn38rviyahfj/vysor.AppImage
	sudo chmod +x vysor.AppImage
        sudo mv vysor.AppImage /usr/bin
        sudo ln -s /usr/bin/vysor.AppImage /usr/bin/vysor
    else
        fl "Vysor is already installed."
    fi
}

install_vysor
