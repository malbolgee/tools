#!/bin/bash

# Install all the libs necessary for the other packages to properly run.
install_libs() {

	sudo apt update && sudo apt-get upgrade
	sudo apt -yf install python git curl build-essential apt-transport-https vim
	sudo apt -yf install default-jre default-jdk sqlitebrowser
	sudo apt -yf install sqlitebrowser policycoreutils-python-utils
}

install_libs
