#!/bin/bash

source ./log.sh

LOG_TAG="Android Studio Install"

# If you're developing on Ubuntu Linux, you need to add a udev rules file that
# contains a USB configuration for each type of device you want to use for
# development. In the rules file, each device manufacturer is identified by a
# unique vendor ID, as specified by the ATTR{idVendor} property.
#
# For mor information {@link http://developer.android.com/tools/device.html} and
# {@link http://www.linux-usb.org/usb.ids}
#
install_android_studio() {
	logi "${LOG_TAG}" "Adding maarten-fonville/android-studio repository"
	sudo add-apt-repository -y 'ppa:maarten-fonville/android-studio'
	sudo apt-get update

	logi "${LOG_TAG}" "Installing Android Studio"
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
							logw "${LOG_TAG}" "Continuing without the export."
							break
							;;
						[Nn]* )
							lunch_android_studio_and_export
							break
							;;
						* )
							loge "${LOG_TAG}" "Please answer yes or no."
							;;
					esac
				done
				break
				;;
			* )
				loge "${LOG_TAG}" "Please answer yes or no."
				;;
		esac
	done

	logi "${LOG_TAG}" "Configuring rules file"
	if [ ! -d "/etc/udev/rules.d" ]; then
		logi "${LOG_TAG}" "/etc/udev/rules.d/ does not exist, creating it"
		sudo mkdir -p /etc/udev/rules.d/
	fi

	logi "${LOG_TAG}" "Copying rules file to final destination"
	sudo cp "$(dirname "$(pwd)")"/.assets/51-android.rules /etc/udev/rules.d/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	sudo service udev restart

	# The fwupd linux service somehow interferes with the fastboot process. We
	# need to disable it.
	stop_service fwupd

	logi "${LOG_TAG}" "Android Studio Setup is done."
}

lunch_android_studio_and_export() {
	logi "${LOG_TAG}" "Launching Android Studio Setup Wizard"
	/opt/android-studio/bin/./studio.sh

	# here we are counting on that the user has completed the
	# setup wizard, otherwise, the export will fail.
	path_export "$HOME/Android/Sdk/platform-tools"
}

install_android_studio
