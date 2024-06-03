#!/bin/bash

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

# Install all the libs necessary for the other packages to properly run.
function install_libs() {
	sudo apt update && sudo apt -y upgrade
	sudo apt -yf install git wget
	sudo apt -yf install curl apt-transport-https vim pip llvm clang net-tools lolcat
	sudo apt -yf install default-jre default-jdk sqlitebrowser libncurses5 libnss3-tools
	sudo apt -yf install build-essential linux-headers-"$(uname -r)"

	summary+=("The necessary packages has been installed")
}

install_libs
