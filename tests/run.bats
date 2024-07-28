#!/usr/bin/env bats

source tests/util.sh

@test 'run - bucket initialized - succeeds' {
    backup init s3
    capture_output backup run --dest s3
    assert_no_stderr
    assert_stdout 'snapshot [[:alnum:]]+ saved'
    assert_exit_code 0
}

@test 'run - bucket not initialized - fails' {
    capture_output backup run --dest s3
    assert_stderr 'Is there a repository at the following location\?'
    assert_exit_code 10
}