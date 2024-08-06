#!/usr/bin/env bats

source tests/util.sh

@test 'init - config exists - bucket initialized' {
    capture_output backup init offsite
    assert_no_stderr
    assert_stdout '^created restic repository [[:alnum:]]+ at s3\:http\:\/\/.+'
    assert_exit_code 0
}

@test 'init - already initialized - fails' {
    backup init offsite  # this should succeed

    capture_output backup init offsite
    assert_stderr 'repository master key and config already initialized'
    assert_exit_code 1
}
