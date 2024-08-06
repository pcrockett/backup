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
