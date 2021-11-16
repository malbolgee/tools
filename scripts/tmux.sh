#!/bin/bash

# Install tmux and puts a .tmux.conf in it
install_tmux() {

    DOTFILES_PATH=~/dotfiles
    CONF_FILE_PATH=~/.tmux.conf

    sudo apt install -yf tmux

    git clone https://malbolge.dev.br/malbolge/dotfiles.git ${DOTFILES_PATH}
    git -C ${DOTFILES_PATH} checkout main

    echo "source-file ${DOTFILES_PATH}/.tmux.conf" >> ${CONF_FILE_PATH}
}

install_tmux
