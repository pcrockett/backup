# shellcheck shell=bash

util:lines() {
  # iterate through args, and output each one on a new line.
  #
  # example usage:
  #
  #     util:lines a b c
  #
  # outputs:
  #
  #     a
  #     b
  #     c
  #
  for i in "${@}"; do
    echo "${i}"
  done
}

util:escape_value() {
  printf '%q' "${1}"
}

util:mkdir_private() {
  (
    umask u=rwx,g=,o=
    mkdir --parent "${1}"
  )
}

util:temp_file() {
  # create a temp file in ${BACKUP_TEMP_DIR} and echo its file path to stdout
  # ${BACKUP_TEMP_DIR} will be deleted in [ref:before-hook]
  mktemp --tmpdir="${BACKUP_TEMP_DIR}"
}

util:sha256sum() {
  sha256sum "${1}" | awk '{print $1}'
}

util:indent() {
  sed 's/^/    /'
}
