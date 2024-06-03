#!/bin/bash

ANDROID_LOG_TAG="Android Studio Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

# If you're developing on Ubuntu Linux, you need to add a udev rules file that
# contains a USB configuration for each type of device you want to use for
# development. In the rules file, each device manufacturer is identified by a
# unique vendor ID, as specified by the ATTR{idVendor} property.
#
# For mor information {@link http://developer.android.com/tools/device.html} and
# {@link http://www.linux-usb.org/usb.ids}
#
function install_android_studio() {
	_add_ppa
	_install_android_studio
	_config_rules_file

	# The fwupd linux service somehow interferes with the fastboot process. We
	# need to disable it.
	stop_service fwupd

	logi "${ANDROID_LOG_TAG}" "Android Studio Setup is done."

	summary+=("Android Studio has been installed")
}

function _add_ppa() {
	logi "${ANDROID_LOG_TAG}" "Adding repository"
	sudo add-apt-repository -y 'ppa:maarten-fonville/android-studio'
	sudo apt-get update
}

function _install_android_studio() {
	logi "${ANDROID_LOG_TAG}" "Installing Android Studio"
	sudo apt-get install -yf android-studio

	cr=`echo $'\n.'`
	cr=${cr%.}
	prompt="Are you sure? 'platform-tools' directory won't be put into PATH if you proceed.${cr}"
	prompt="${prompt}This means that you won't be able to use tools like adb or fastboot right off the bat. [Y/n] "

	while true; do
		read -p "${RED}Do you want to setup Android Studio now? [Y/n] ${NORMAL}" yn
		case $yn in
			[Yy]* )
				lunch_android_studio_and_export
				break
				;;
			[Nn]* )
				while true; do
					read -p "${RED}${prompt}${NORMAL}" yn
					case $yn in
						[Yy]* )
							logw "${ANDROID_LOG_TAG}" "Continuing without the export."
							break
							;;
						[Nn]* )
							lunch_android_studio_and_export
							break
							;;
						* )
							loge "${ANDROID_LOG_TAG}" "Please answer yes or no."
							;;
					esac
				done
				break
				;;
			* )
				loge "${ANDROID_LOG_TAG}" "Please answer yes or no."
				;;
		esac
	done
}

function _config_rules_file() {
	logi "${ANDROID_LOG_TAG}" "Configuring rules file"
	if [ ! -d "/etc/udev/rules.d" ]; then
		logi "${ANDROID_LOG_TAG}" "/etc/udev/rules.d/ does not exist, creating it"
		sudo mkdir -p /etc/udev/rules.d/
	fi

	logi "${ANDROID_LOG_TAG}" "Copying rules file to final destination"
	sudo cp "$(dirname "$(pwd)")"/.assets/51-android.rules /etc/udev/rules.d/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	sudo service udev restart
}

function lunch_android_studio_and_export() {
	logi "${ANDROID_LOG_TAG}" "Launching Android Studio Setup Wizard"
	/opt/android-studio/bin/./studio.sh

	# here we are counting on that the user has completed the
	# setup wizard, otherwise, the export will fail.
	path_export "$HOME/Android/Sdk/platform-tools"
}

install_android_studio
