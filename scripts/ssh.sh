#!/bin/bash

# shellcheck source=/dev/null
source ./log.sh

SSH_LOG_TAG="SSH Config"

COREID=""

function config_ssh() {
	prompt_coreid_question
	generate_key
	add_key_to_authorized_keys
	configure_config_file
	change_permissions
	configure_gitconfig
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

function prompt_coreid_question() {
	read -p "${RED}Is ${BOLD}\"${USER}\" ${NORMAL}${RED}your coreid? [yN] ${NORMAL}" yn

	if [[ "$yn" =~ [yY] ]] || [ -z "$yn" ]; then
		COREID="$USER"
	else
		while true; do
			read -p "${RED}Provide your coreid${NORMAL}: " coreid

			if [ -n "$coreid" ]; then
				COREID="$coreid"
				break
			fi
		done
	fi
}

function generate_key() {
	logi "${SSH_LOG_TAG}" "Generating SSH key.."
	yes '' | ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_"$COREID" -C "${COREID}@motorola.com"
}

function configure_gitconfig() {
	logi "${SSH_LOG_TAG}" "Configuring your .gitconfig file"
	cp "$(dirname "$(pwd)")"/.assets/.gitconfig "${HOME}"/.gitconfig
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.gitconfig
}

function configure_config_file() {
	logi "${SSH_LOG_TAG}" "Configuring server config file"
	cp "$(dirname "$(pwd)")"/.assets/config "${HOME}"/.ssh/config
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.ssh/config
}

config_ssh
