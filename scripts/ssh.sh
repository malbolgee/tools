#!/usr/bin/env bash

SSH_LOG_TAG="SSH Config"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

function config_ssh() {
    generate_key || return 1
    add_key_to_authorized_keys || return 1
    configure_config_file || return 1
    change_permissions || return 1
}

function change_permissions() {
    logi "${SSH_LOG_TAG}" "Changing directories permissions.."
    chmod 755 ~ || return 1
    chmod -R 700 ~/.ssh || return 1
}

function add_key_to_authorized_keys() {
    logi "${SSH_LOG_TAG}" "Adding key to authorized keys.."
    cat ~/.ssh/id_"$COREID".pub >>~/.ssh/authorized_keys || return 1
}

function generate_key() {
    logi "${SSH_LOG_TAG}" "Generating SSH key.."
    yes '' | ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_"$COREID" -C "${COREID}@motorola.com" || return 1
}

function configure_config_file() {
    logi "${SSH_LOG_TAG}" "Configuring server config file"
    cp "$(dirname "$(pwd)")"/.assets/config "${HOME}"/.ssh/config || return 1
    sed -i "s/coreid/${COREID}/g" "${HOME}"/.ssh/config || return 1
}

if config_ssh; then
    summary+=("The SSH keys has been configured")
else
    loge "${SSH_LOG_TAG}" "Configuration failed."
fi
