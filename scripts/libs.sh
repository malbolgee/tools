#!/usr/bin/env bash

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

# Install all the libs necessary for the other packages to properly run.
function install_libs() {
    local packages=(
        curl
        vim
        pip
        apt-transport-https
        llvm
        clang
        net-tools
        lolcat
        default-jre
        default-jdk
        sqlitebrowser
        libnss3-tools
        build-essential
        linux-headers-"$(uname -r)"
    )

    echo "Updating package list and upgrading system..."
    # Using apt-get for stable scripting and DEBIAN_FRONTEND=noninteractive for automation
    if sudo DEBIAN_FRONTEND=noninteractive apt-get update &&
        sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y &&
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -yf "${packages[@]}"; then
        return 0
    else
        echo "Error: Package installation failed."
        return 1
    fi
}

if ! is_on_server; then
    if install_libs; then
        summary+=("The necessary packages have been installed")
    else
        echo "Error: Package installation failed."
    fi
fi
