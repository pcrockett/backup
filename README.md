# Phil's Backup Script

A very opinionated backup tool, based on [Restic](https://restic.net/).

_This is new, pre-1.0. You probably shouldn't use it until I have exercised it for a bit._

This implements my version of a 3-2-1 backup system:

**3 copies of your data:**

1. Your original copy
2. An external drive
3. An off-site S3-compatible storage service

**2 storage mediums:**

1. Your internal storage and external drive
2. An off-site S3-compatible service

**1 copy off-site:**

1. An off-site S3-compatible service

## Configuration

The other goal of this script is to minimize configuration. You don't get to configure encryption
parameters (besides setting an encryption key), additional backup destinations, etc. You may only
configure:

* The end-to-end encryption key
* Your S3 credentials and bucket URL
* What external drive partition you're going to backup to
* What directories you want to backup
* What files and directories you want to ignore

The default config is generated for you and is easy to fill out.

## Dependencies

Only Linux is supported. Other dependencies:

* [Restic](https://github.com/restic/restic/)
* [fuse3](https://packages.debian.org/bookworm/fuse3)
* A modern version of Bash

## Quick Start

Download the [backup script](backup) to some location on your `PATH` and make it executable.

```bash
# Configure your backups
backup config --edit

# Create your external drive backup repository
backup init external

# Create your off-site S3 backup repository
backup init offsite

# Backup your data to both external and off-site destinations
backup run

# Check both backup destinations for errors
backup check

# ... or check that you can fully restore a file from both locations
backup check --file ./some/important/file

# Mount one of your backups to access / restore the data inside
backup mount offsite
```

For more details, see `backup --help`
