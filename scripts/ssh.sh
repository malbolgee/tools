#!/bin/bash

source ./log.sh

LOG_TAG="SSH Config"

COREID=""

config_ssh() {
    prompt_coreid_question
    generate_key
    add_key_to_authorized_keys
    download_template_config_file
    fill_template_file
    move_template_file
    change_permissions
}

change_permissions() {
    logi "${LOG_TAG}" "Changing directories permissions.."
    sudo chmod 755 ~
    sudo chmod -R 700 ~/.ssh
}

add_key_to_authorized_keys() {
    logi "${LOG_TAG}" "Adding key to authorized keys.."
    cat id_"$COREID".pub >> authorized_keys
}

fill_template_file() {
    sed -i "s/coreid/${COREID}/g" ./config
}

move_template_file() {
    logi "${LOG_TAG}" "Moved config file to ~/.ssh/"
    mv ./config ~/.ssh/
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

download_template_config_file() {
    logi "${LOG_TAG}" "Downloading config file..."
    wget --no-check-certificate\
    --content-disposition\
    --show-progress\
    https://malbolge.dev.br/attachments/7c3ff4c0-be32-431a-9050-4ace408dc26e
}

config_ssh