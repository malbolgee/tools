#!/usr/bin/env bash

TMUX_LOG_TAG="Tmux Install"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

# Install tmux and puts a .tmux.conf in it
function install_tmux() {
    local DOTFILES_PATH="${HOME}"/dotfiles
    local CONF_FILE_PATH="${HOME}"/.tmux.conf

    if ! is_package_installed 'tmux'; then
        logi "${TMUX_LOG_TAG}" "Trying to install Tmux"
        sudo apt install -yf tmux || return 1
    fi

    _clone_dotfiles_repository || return 1

    logi "${TMUX_LOG_TAG}" "Successfully configured"
}

function _clone_dotfiles_repository() {
    logi "${TMUX_LOG_TAG}" "Setting up tmux .tmux.conf"

    local DOTFILES_GITHUB_URL="https://github.com/malbolgee/dotfiles.git"

    if ! is_package_installed 'git'; then
        logi "${TMUX_LOG_TAG}" "Trying to install git"
        sudo apt install -yf git || return 1
    fi

    git clone "${DOTFILES_GITHUB_URL}" "${DOTFILES_PATH}" || return 1
    echo "source-file ${DOTFILES_PATH}/.tmux.conf" >>"${CONF_FILE_PATH}" || return 1
}

if install_tmux; then
    summary+=("tmux has been configured")
else
    loge "${TMUX_LOG_TAG}" "Installation failed."
fi
