#!/usr/bin/env bash

ANDROID_LOG_TAG="Android Studio Install"
UDEV_RULES_DIR="/etc/udev/rules.d"
UDEV_RULES_FILE="${UDEV_RULES_DIR}/51-android.rules"
ANDROID_STUDIO_EXEC="/opt/android-studio/bin/studio.sh"
SDK_PLATFORM_TOOLS="$HOME/Android/Sdk/platform-tools"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

# If you're developing on Ubuntu Linux, you need to add a udev rules file that
# contains a USB configuration for each type of device you want to use for
# development. In the rules file, each device manufacturer is identified by a
# unique vendor ID, as specified by the ATTR{idVendor} property.
#
# For more information see:
# http://developer.android.com/tools/device.html
# http://www.linux-usb.org/usb.ids
#
function install_android_studio() {
    _add_ppa || return 1
    _install_android_studio || return 1
    _config_rules_file || return 1

    # The fwupd linux service somehow interferes with the fastboot process.
    # We need to disable it.
    stop_service fwupd

    logi "${ANDROID_LOG_TAG}" "Android Studio Setup is done."
}

function _add_ppa() {
    logi "${ANDROID_LOG_TAG}" "Adding repository"
    sudo add-apt-repository -y 'ppa:maarten-fonville/android-studio' || return 1
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -yq || return 1
}

function _install_android_studio() {
    logi "${ANDROID_LOG_TAG}" "Installing Android Studio"
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -yqf android-studio || return 1

    # Check for non-interactive mode
    if [[ ! -t 0 ]] || [[ "${DEBIAN_FRONTEND-}" == "noninteractive" ]]; then
        logi "${ANDROID_LOG_TAG}" "Non-interactive mode detected. Proceeding with launch."
        launch_android_studio_and_export
        return 0
    fi

    local prompt
    prompt=$'Are you sure? \'platform-tools\' directory won\'t be put into PATH if you proceed.\n'
    prompt+=$'This means that you won\'t be able to use tools like adb or fastboot right off the bat. [Y/n] '

    while true; do
        read -p "${RED}Do you want to setup Android Studio now? [Y/n] ${NORMAL}" yn
        case "${yn:-y}" in
        [Yy]*)
            launch_android_studio_and_export
            break
            ;;
        [Nn]*)
            while true; do
                read -p "${RED}${prompt}${NORMAL}" yn_confirm
                case "${yn_confirm:-y}" in
                [Yy]*)
                    logw "${ANDROID_LOG_TAG}" "Continuing without the export."
                    return 0
                    ;;
                [Nn]*)
                    launch_android_studio_and_export
                    return 0
                    ;;
                *)
                    loge "${ANDROID_LOG_TAG}" "Please answer yes or no."
                    ;;
                esac
            done
            ;;
        *)
            loge "${ANDROID_LOG_TAG}" "Please answer yes or no."
            ;;
        esac
    done
}

function _config_rules_file() {
    logi "${ANDROID_LOG_TAG}" "Configuring rules file"

    if [ ! -d "${UDEV_RULES_DIR}" ]; then
        logi "${ANDROID_LOG_TAG}" "${UDEV_RULES_DIR} does not exist, creating it"
        sudo mkdir -p "${UDEV_RULES_DIR}" || return 1
    fi

    logi "${ANDROID_LOG_TAG}" "Copying rules file to final destination"
    local assets_dir
    assets_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.assets"

    if [ -f "${assets_dir}/51-android.rules" ]; then
        sudo cp "${assets_dir}/51-android.rules" "${UDEV_RULES_FILE}" || return 1
        sudo chmod a+r "${UDEV_RULES_FILE}" || return 1

        # Reload udev rules without restarting the entire daemon
        sudo udevadm control --reload-rules && sudo udevadm trigger ||
            logw "${ANDROID_LOG_TAG}" "Failed to reload udev rules."
    else
        logw "${ANDROID_LOG_TAG}" "udev rules file not found in assets: ${assets_dir}/51-android.rules"
    fi
}

function launch_android_studio_and_export() {
    # Protection against headless environments
    if [[ -z "${DISPLAY-}" ]]; then
        logw "${ANDROID_LOG_TAG}" "No DISPLAY detected. Skipping Android Studio launch."
        logw "${ANDROID_LOG_TAG}" "Please run '${ANDROID_STUDIO_EXEC}' manually to complete setup."
        return 0
    fi

    logi "${ANDROID_LOG_TAG}" "Launching Android Studio Setup Wizard"
    if [ -f "${ANDROID_STUDIO_EXEC}" ]; then
        # Launching and waiting for the user to complete the wizard
        "${ANDROID_STUDIO_EXEC}"
    else
        loge "${ANDROID_LOG_TAG}" "Android Studio executable not found at ${ANDROID_STUDIO_EXEC}"
        return 1
    fi

    # After the wizard is closed, we attempt to export the path.
    path_export "${SDK_PLATFORM_TOOLS}"
}

if install_android_studio; then
    summary+=("Android Studio has been installed")
else
    loge "${ANDROID_LOG_TAG}" "Installation failed."
fi
