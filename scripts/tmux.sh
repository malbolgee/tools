#!/bin/bash

source ./log.sh

LOG_TAG="Tmux Install"

# Install tmux and puts a .tmux.conf in it
install_tmux() {

    DOTFILES_PATH=$HOME/dotfiles
    CONF_FILE_PATH=$HOME/.tmux.conf

    if ! is_package_installed 'tmux'; then
        logi "${LOG_TAG}" "Trying to install Tmux.."
        sudo apt install -yf tmux
    fi

    logi "${LOG_TAG}" "Setting up tmux .tmux.conf"
    git clone https://github.com/malbolgee/dotfiles.git "${DOTFILES_PATH}"

    echo "source-file ${DOTFILES_PATH}/.tmux.conf" >> "${CONF_FILE_PATH}"

    logi "${LOG_TAG}" "Tmux was successfully installed!"
}

install_tmux
