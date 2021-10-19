#!/bin/bash

# Install all the libs necessary for the other packages to properly run.
install_libs() {

    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get -yf install python git curl build-essential apt-transport-https wine vim
}

install_libs
