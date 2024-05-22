#!/bin/bash

SSH_LOG_TAG="SSH Config"

if [ -z "${MAIN_LOADED-}" ]; then
    echo "The script must be accessed from main.sh"
    exit 1
fi

function config_ssh() {
	prompt_coreid_question
	generate_key
	add_key_to_authorized_keys
	configure_config_file
	change_permissions
}

function change_permissions() {
	logi "${SSH_LOG_TAG}" "Changing directories permissions.."
	chmod 755 ~
	chmod -R 700 ~/.ssh
}

function add_key_to_authorized_keys() {
	logi "${SSH_LOG_TAG}" "Adding key to authorized keys.."
	cat ~/.ssh/id_"$COREID".pub >>~/.ssh/authorized_keys
}

function generate_key() {
	logi "${SSH_LOG_TAG}" "Generating SSH key.."
	yes '' | ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_"$COREID" -C "${COREID}@motorola.com"
}


function configure_config_file() {
	logi "${SSH_LOG_TAG}" "Configuring server config file"
	cp "$(dirname "$(pwd)")"/.assets/config "${HOME}"/.ssh/config
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.ssh/config
}

config_ssh
