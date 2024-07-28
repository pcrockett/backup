#!/usr/bin/env bats

source tests/util.sh

@test 'check - no snapshots yet - fails' {
    backup init s3
    capture_output backup check --dest s3
    assert_stderr 'Fatal: Cannot read from a repository having size 0'
    assert_exit_code 1
}

@test 'check - snapshot exists - succeeds' {
    backup init s3
    backup run --dest s3
    capture_output backup check --dest s3
    assert_no_stderr
    assert_stdout 'check all packs'
    assert_stdout 'check snapshots, trees and blobs'
    assert_stdout 'no errors were found'
    assert_exit_code 0
}

@test 'check - bucket not initialized - fails' {
    capture_output backup check --dest s3
    assert_stderr 'Is there a repository at the following location\?'
    assert_exit_code 10
}
