#!/bin/bash

source ./log.sh

LOG_TAG="Tmux Install"

# Install tmux and puts a .tmux.conf in it
install_tmux() {

    DOTFILES_PATH=~/dotfiles
    CONF_FILE_PATH=~/.tmux.conf

    logi "${LOG_TAG}" "Trying to install Tmux.."
    sudo apt install -yf tmux

    logi "${LOG_TAG}" "Setting up tmux .tmux.conf"
    git clone https://malbolge.dev.br/malbolge/dotfiles.git ${DOTFILES_PATH}

    echo "source-file ${DOTFILES_PATH}/.tmux.conf" >> ${CONF_FILE_PATH}

    logi "${LOG_TAG}" "Tmux was successfully installed!"
}

install_tmux
