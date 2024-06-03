#!/bin/bash

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
        sudo apt install -yf tmux
    fi

    _clone_dotfiles_repository

    logi "${TMUX_LOG_TAG}" "Successfully configured"
    
    summary+=("tmux has been configured")
}

function _clone_dotfiles_repository() {
    logi "${TMUX_LOG_TAG}" "Setting up tmux .tmux.conf"

    local DOTFILES_GITHUB_URL="https://github.com/malbolgee/dotfiles.git"

    if ! is_package_installed 'git'; then
        logi "${TMUX_LOG_TAG}" "Trying to install git"
        sudo apt install -yf git
    fi

    git clone "${DOTFILES_GITHUB_URL}" "${DOTFILES_PATH}"
    echo "source-file ${DOTFILES_PATH}/.tmux.conf" >>"${CONF_FILE_PATH}"
}

install_tmux
