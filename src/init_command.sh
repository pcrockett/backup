# shellcheck shell=bash

read_config

password_file="$(temp_file)"

echo "${RESTIC_E2EE_PASSWORD}" > "${password_file}"
RESTIC_PASSWORD_FILE="${password_file}" restic init
