#!/usr/bin/env bats

source tests/util.sh

@test 'check - no snapshots yet - fails' {
  backup init offsite
  capture_output backup check offsite
  assert_stderr 'Fatal: Cannot read from a repository having size 0'
  assert_exit_code 1
}

@test 'check - snapshot exists - succeeds' {
  backup init offsite
  backup run offsite
  capture_output backup check offsite
  assert_no_stderr
  assert_stdout 'check all packs'
  assert_stdout 'check snapshots, trees and blobs'
  assert_stdout 'no errors were found'
  assert_stdout 'OK: No errors encountered\.'
  assert_exit_code 0
}

@test 'check - bucket not initialized - fails' {
  capture_output backup check offsite
  assert_stderr 'Is there a repository at the following location\?'
  assert_stdout 'offsite backup destination encountered an error\.'
  assert_exit_code 1
}

@test 'check - file unchanged after backup - succeeds' {
  echo "foobar" >"${HOME}/foobar"
  backup init offsite
  backup run offsite
  capture_output backup check offsite --file "${HOME}/foobar"
  assert_stdout 'Original file hash: aec070645fe53ee3b3763059376134f058cc337247c978add178b6ccdfb0019f'
  assert_stdout 'offsite OK: aec070645fe53ee3b3763059376134f058cc337247c978add178b6ccdfb0019f
OK: No errors encountered\.'
  assert_exit_code 0
}

@test 'check - file changed after backup - fails' {
  echo "foobar" >"${HOME}/foobar"
  backup init offsite
  backup run offsite
  echo "original file change!" >"${HOME}/foobar"
  capture_output backup check offsite --file "${HOME}/foobar"
  assert_stdout 'Original file hash: a6503884de5e1db7022e6ede70cd4add207dd6051e05f549ac4bdaf746e0b22b'
  assert_stdout 'offsite FAIL: aec070645fe53ee3b3763059376134f058cc337247c978add178b6ccdfb0019f
offsite file hash does not match original.'
  assert_exit_code 1
}

@test 'check - file removed after backup - fails' {
  echo "foobar" >"${HOME}/foobar"
  backup init offsite
  backup run offsite
  rm "${HOME}/foobar"
  capture_output backup check offsite --file "${HOME}/foobar"
  assert_stderr "FATAL: ${HOME}/foobar doesn't exist"
  assert_exit_code 1
}

@test 'check - file removed FROM backup - fails' {
  echo "foobar" >"${HOME}/foobar"
  backup init offsite
  backup run offsite
  rm "${HOME}/foobar"
  backup run offsite
  echo "foobar" >"${HOME}/foobar"
  capture_output backup check offsite --file "${HOME}/foobar"
  assert_stdout 'Original file hash: aec070645fe53ee3b3763059376134f058cc337247c978add178b6ccdfb0019f'
  assert_stderr "FATAL: ${HOME}/foobar does not exist in latest snapshot\\."
  assert_exit_code 1
}
