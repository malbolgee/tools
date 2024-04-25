#!/bin/bash

# Install all the libs necessary for the other packages to properly run.
install_libs() {
	sudo apt update && sudo apt -y upgrade
	sudo apt -yf install curl apt-transport-https vim pip llvm clang net-tools
	sudo apt -yf install default-jre default-jdk sqlitebrowser libncurses5 libnss3-tools
	sudo apt -yf install build-essential linux-headers-"$(uname -r)"
}

install_libs
