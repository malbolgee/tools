#!/usr/bin/env bash

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

readonly SCRCPY_LOG_TAG="scrcpy Install"
readonly REPOS_DIR="${HOME}/repos"
readonly SCRCPY_DIR="${REPOS_DIR}/scrcpy"
readonly GITHUB_REPO_URL="https://github.com/Genymobile/scrcpy.git"

function install_scrcpy() {
    logi "${SCRCPY_LOG_TAG}" "Starting scrcpy installation process"

    local ubuntu_version
    ubuntu_version=$(lsb_release -rs 2>/dev/null || grep -oP '(?<=^VERSION_ID=").*(?=")' /etc/os-release || echo "0")

    local scrcpy_branch="v3.3.4"
    local use_sdl3=false

    if dpkg --compare-versions "${ubuntu_version}" "ge" "25.04" 2>/dev/null; then
        scrcpy_branch="v4.0"
        use_sdl3=true
        logi "${SCRCPY_LOG_TAG}" "Detected Ubuntu >= 25.04. Target branch: ${scrcpy_branch} (SDL3)"
    else
        logi "${SCRCPY_LOG_TAG}" "Detected Ubuntu < 25.04. Target branch: ${scrcpy_branch} (SDL2)"
    fi

    if ! _install_required_packages "${use_sdl3}"; then
        loge "${SCRCPY_LOG_TAG}" "Failed to install required packages"
        return 1
    fi

    if ! _clone_repository "${scrcpy_branch}"; then
        loge "${SCRCPY_LOG_TAG}" "Failed to clone repository"
        return 1
    fi

    if ! _build_and_install "${scrcpy_branch}"; then
        loge "${SCRCPY_LOG_TAG}" "Failed to build and install scrcpy"
        return 1
    fi

    logi "${SCRCPY_LOG_TAG}" "scrcpy installation is done"
}

function _install_required_packages() {
    local use_sdl3="$1"
    logi "${SCRCPY_LOG_TAG}" "Installing required packages"

    # Common dependencies for both versions
    local packages=(
        ffmpeg
        libusb-1.0-0
        gcc
        pkg-config
        meson
        ninja-build
        libavcodec-dev
        libavdevice-dev
        libavformat-dev
        libavutil-dev
        libswresample-dev
        libusb-1.0-0-dev
        wget
    )

    # Add version-specific dependencies
    if [ "${use_sdl3}" = true ]; then
        packages+=(
            libsdl3-0
            libsdl3-dev
            libv4l-dev
        )
    else
        packages+=(
            libsdl2-2.0-0
            libsdl2-dev
        )
    fi

    # Install packages non-interactively to prevent blocking prompts
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq "${packages[@]}" || return 1
}

function _clone_repository() {
    local branch="$1"
    logi "${SCRCPY_LOG_TAG}" "Cloning scrcpy repository (branch: ${branch})"

    mkdir -p "${REPOS_DIR}" || return 1

    # Clean up existing directory to ensure a fresh clone
    if [ -d "${SCRCPY_DIR}" ]; then
        logi "${SCRCPY_LOG_TAG}" "Directory ${SCRCPY_DIR} already exists. Cleaning up."
        rm -rf "${SCRCPY_DIR}" || return 1
    fi

    git clone --depth=1 --branch="${branch}" --single-branch "${GITHUB_REPO_URL}" "${SCRCPY_DIR}" || return 1
}

function _build_and_install() {
    local branch="$1"
    logi "${SCRCPY_LOG_TAG}" "Building and installing"

    # Use a subshell to encapsulate environment variables and working directory changes safely
    (
        cd "${SCRCPY_DIR}" || return 1

        # Exit subshell immediately if any build/install command fails
        set -e

        logi "${SCRCPY_LOG_TAG}" "Downloading prebuilt scrcpy-server for ${branch}..."
        wget -qO "scrcpy-server-${branch}" "https://github.com/Genymobile/scrcpy/releases/download/${branch}/scrcpy-server-${branch}"

        meson setup x --buildtype=release --strip -Db_lto=true -Dprebuilt_server="scrcpy-server-${branch}"
        ninja -Cx
        sudo ninja -Cx install
    ) || return 1
}

if install_scrcpy; then
    summary+=("scrcpy has been installed")
else
    loge "${SCRCPY_LOG_TAG}" "Installation failed."
fi
