#!/bin/bash

# If you're developing on Ubuntu Linux, you need to add a udev rules file that
# contains a USB configuration for each type of device you want to use for
# development. In the rules file, each device manufacturer is identified by a
# unique vendor ID, as specified by the ATTR{idVendor} property.
#
# For mor information {@link http://developer.android.com/tools/device.html} and
# {@link http://www.linux-usb.org/usb.ids}
#
install_android_studio() {

    # fl "Execution install_android_studio script"

    sudo add-apt-repository -y 'ppa:maarten-fonville/android-studio'
    sudo apt-get update
    fl "Installing Android Studio"
    sudo apt-get install -y android-studio

    if ! is_package_installed 'curl'; then
        fl "Installing curl..."
        sudo apt install -yf curl
    fi

    sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules
    sudo chmod a+r /etc/udev/rules.d/51-android.rules
    sudo service udev restart

    # The fwupd linux service somehow interferes with the fastboot process. We
    # need to disable it.
    stop_service fwupd
    path_export "$HOME/Android/Sdk/platform-tools"
}

install_android_studio
