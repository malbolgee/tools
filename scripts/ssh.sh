#!/bin/bash

. ./log.sh

LOG_TAG="SSH Config"

COREID=""

config_ssh() {
	prompt_coreid_question
	generate_key
	add_key_to_authorized_keys

	# only configure server file if we are not on a sever itself
	[ "zbr05lbld12" != "$(uname -n)" ] && configure_config_file

	change_permissions
	configure_gitconfig
}

change_permissions() {
	logi "${LOG_TAG}" "Changing directories permissions.."
	sudo chmod 755 ~
	sudo chmod -R 700 ~/.ssh
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
	yes '' | ssh-keygen -t rsa -f ~/.ssh/id_"$COREID"
}

configure_gitconfig() {
	logi "${LOG_TAG}" "Configuring your .gitconfig file"

	# TODO: handle if we are in SSH access in ZBR or INDT

	cp "$(dirname "$(pwd)")"/.assets/.gitconfig "${HOME}"/.gitconfig
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.gitconfig
}

configure_config_file() {
	logi "${LOG_TAG}" "Configuring server config file"
	cp "$(dirname "$(pwd)")"/.assets/config "${HOME}"/.ssh/config
	sed -i "s/coreid/${COREID}/g" "${HOME}"/.ssh/config
}

config_ssh
