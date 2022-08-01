#!/bin/bash

. "./log.sh"

LOG_TAG="config_env"

configure_bashrc() {
	logi "${LOG_TAG}" "Configuring .bashrc"
	cp "$(dirname "$(pwd)")"/.assets/.bashrc "${HOME}"/.bashrc
}

configure_bashrc
