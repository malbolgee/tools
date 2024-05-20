#!/bin/bash

source ./log.sh

TMUX_LOG_TAG="Tmux Install"

# Install tmux and puts a .tmux.conf in it
function install_tmux() {
    DOTFILES_PATH=$HOME/dotfiles
    CONF_FILE_PATH=$HOME/.tmux.conf

    if ! is_package_installed 'tmux'; then
        logi "${TMUX_LOG_TAG}" "Trying to install Tmux.."
        sudo apt install -yf tmux
    fi

    logi "${TMUX_LOG_TAG}" "Setting up tmux .tmux.conf"
    git clone https://github.com/malbolgee/dotfiles.git "${DOTFILES_PATH}"

    echo "source-file ${DOTFILES_PATH}/.tmux.conf" >>"${CONF_FILE_PATH}"

    logi "${TMUX_LOG_TAG}" "Tmux was successfully installed!"
}

install_tmux
