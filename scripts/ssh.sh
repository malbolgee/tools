#!/bin/bash

# shellcheck source=/dev/null
source ./log.sh

LOG_TAG="SSH Config"

COREID=""

config_ssh() {
	prompt_coreid_question
	generate_key
	add_key_to_authorized_keys
	configure_config_file
	change_permissions
	configure_gitconfig
}

change_permissions() {
	logi "${LOG_TAG}" "Changing directories permissions.."
	chmod 755 ~
	chmod -R 700 ~/.ssh
}

add_key_to_authorized_keys() {
	logi "${LOG_TAG}" "Adding key to authorized keys.."
	cat ~/.ssh/id_"$COREID".pub >> ~/.ssh/authorized_keys
}

prompt_coreid_question() {
	read -p "Is \"${USER}\" your coreid? [yN] " yn

	if [[ "$yn" =~ [yY] ]] || [ -z "$yn" ]; then
		COREID="$USER"
	else
		while true; do
			read -p "Provide your coreid: " coreid

			if [ -n "$coreid" ]; then
				COREID="$coreid"
				break
			fi
		done
	fi
}

generate_key() {
	logi "${LOG_TAG}" "Generating SSH key.."
	yes '' | ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_"$COREID" -C "${COREID}@motorola.com"
}

configure_gitconfig() {
	logi "${LOG_TAG}" "Configuring your .gitconfig file"
	cp "$(dirname "$(pwd)")"/.assets/.gitconfig "${HOME}"/.gitconfig
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.gitconfig
}

configure_config_file() {
	logi "${LOG_TAG}" "Configuring server config file"
	cp "$(dirname "$(pwd)")"/.assets/config "${HOME}"/.ssh/config
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.ssh/config
}

config_ssh
