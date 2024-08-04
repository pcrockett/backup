#!/usr/bin/env bats

source tests/util.sh

@test 'run - bucket initialized - succeeds' {
    backup init remote
    capture_output backup run remote
    assert_no_stderr
    assert_stdout 'snapshot [[:alnum:]]+ saved'
    assert_exit_code 0
}

@test 'run - bucket not initialized - fails' {
    capture_output backup run remote
    assert_stderr 'Is there a repository at the following location\?'
    assert_exit_code 10
}
