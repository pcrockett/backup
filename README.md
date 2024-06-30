# Phil's Backup Script

A very opinionated backup tool, based on [Restic](https://restic.net/).

This implements my version of a 3-2-1 backup system:

**3 copies of your data:** Your local copy, a USB drive, and a copy in the cloud via an
S3-compatible storage API.

**2 storage mediums:** Your USB & local drive, and an S3-compatible service.

**1 copy off-site:** The S3-compatible service.

The other goal of this script is to minimize configuration. The only things you need to configure
are:

* Your S3 credentials and bucket URL
* What USB drive partition you're going to backup to
* The end-to-end encryption key
* _Optional:_ What directories you want to backup
* _Optional:_ What files and directories you want to ignore

The script assists you in configuring all of these things.
