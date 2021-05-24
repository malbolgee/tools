#!/bin/bash

# Install all the libs necessary for the other packages to properly run.
install_libs() {

    # fl "Execution install_libs script"
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get -yf install python git curl build-essential apt-transport-https wine
}

install_libs
