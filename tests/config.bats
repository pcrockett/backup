#!/usr/bin/env bats

source tests/util.sh

@test 'config - does not exist yet - creates file automatically' {
  rm "${TEST_CONFIG_DIR}/config.sh"
  capture_output backup config --no-pager
  assert_no_stderr
  assert_stdout '^# shellcheck shell=bash'
  assert_exit_code 0

  capture_output ls -lh "${TEST_CONFIG_DIR}/config.sh"
  assert_stdout '^-rw------- 1 root root .+$'
}
