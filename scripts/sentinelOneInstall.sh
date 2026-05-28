#!/usr/bin/env bash

# Sentinel One Installation Script
#
# This script downloads the Sentinel One agent archive, extracts it,
# and installs the enclosed .deb package.
#
# Requirements:
# - Must be sourced or executed from main.sh
# - Internet access to download the agent
# - Sudo privileges for installation

# Ensure the script is accessed through the main entry point
if [ -z "${MAIN_LOADED-}" ]; then
    echo "Error: This script must be accessed from main.sh"
    exit 1
fi

SENTINEL_LOG_TAG="Sentinel One Install"

function install_sentinel_one() {
    local download_url="https://github.com/malbolgee/tools/releases/download/v0.1/sentinelAgent.tar.gz"
    local temp_dir
    temp_dir=$(mktemp -d -t sentinel_XXXXXX)
    local archive_path="${temp_dir}/sentinelAgent.tar.gz"
    local extract_dir="${temp_dir}/extracted"

    # Step 1: Ensure dependencies are met
    _ensure_dependencies

    # Step 2: Download the archive
    if ! _download_archive "${download_url}" "${archive_path}"; then
        logi "${SENTINEL_LOG_TAG}" "Failed to download Sentinel One archive."
        rm -rf "${temp_dir}"
        return 1
    fi

    # Step 3: Extract the archive
    mkdir -p "${extract_dir}"
    if ! tar -xzf "${archive_path}" -C "${extract_dir}"; then
        logi "${SENTINEL_LOG_TAG}" "Failed to extract Sentinel One archive."
        rm -rf "${temp_dir}"
        return 1
    fi

    # Step 4: Find and install the .deb package
    local deb_package
    deb_package=$(find "${extract_dir}" -name "*.deb" | head -n 1)

    if [[ -z "${deb_package}" ]]; then
        logi "${SENTINEL_LOG_TAG}" "No .deb package found in the extracted archive."
        rm -rf "${temp_dir}"
        return 1
    fi

    if _install_package "${deb_package}"; then
        summary+=("Sentinel One has been installed successfully")
    else
        logi "${SENTINEL_LOG_TAG}" "Sentinel One installation failed."
        rm -rf "${temp_dir}"
        return 1
    fi

    # Step 5: Cleanup
    logi "${SENTINEL_LOG_TAG}" "Cleaning up temporary files..."
    rm -rf "${temp_dir}"
}

function _ensure_dependencies() {
    local deps=("wget" "tar")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! is_package_installed "${dep}"; then
            missing_deps+=("${dep}")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        logi "${SENTINEL_LOG_TAG}" "Installing missing dependencies: ${missing_deps[*]}"
        sudo apt-get update -yq
        sudo apt-get install -yq "${missing_deps[@]}"
    fi
}

function _download_archive() {
    local url="$1"
    local output="$2"

    logi "${SENTINEL_LOG_TAG}" "Downloading Sentinel One agent..."
    wget --no-check-certificate \
        --content-disposition \
        --show-progress \
        -O "${output}" \
        "${url}"
}

function _install_package() {
    local package_path="$1"

    logi "${SENTINEL_LOG_TAG}" "Installing package: $(basename "${package_path}")"

    # Using apt-get install to handle potential dependencies automatically
    if sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq "${package_path}"; then
        logi "${SENTINEL_LOG_TAG}" "Sentinel One installation complete."
        return 0
    else
        return 1
    fi
}

# Run the installation
install_sentinel_one
