# Contributing

## Two ways to play

If you want to get started editing the code, you have two options:

1. Install all dev-time dependencies on your machine. _Check out [.tool-versions](.tool-versions)
   and / or the [Dockerfile](Dockerfile) to discover what the build environment looks like._ Then
   you can use `make build`, `make test`, etc.
2. Use Docker. `make ci` will build a Docker container and run the CI process inside, producing a
   final `backup` script at the end. This is the same process that runs in GitHub Actions.

## Creating a new release

[Release Please](https://github.com/googleapis/release-please) and [Conventional Commits](https://www.conventionalcommits.org/)
automate the release process. _You don't need to use Conventional Commits for your day-to-day
committing._ You just need to make sure all _pull requests_ have a Conventional Commit title.

If you did your Conventional Commits correctly, Release Please will have generated a
correct "release" pull request for you. Once that PR is merged, a new release will be created and
the `backup` build artifact will be added to it.

However if you want to release with a specific version number, get a commit onto the main branch
with the phrase `Release-As: x.x.x` somewhere in the commit message. That will instruct Release
Please to modify its "release" PR with the correct version number.

## Testing

Generally we only do automated testing for the "offsite" use case. This is because it requires no
root privileges or physical devices. All it requires is running an ephemeral S3-compatible service
in the background during tests. For this, we use [MinIO](https://github.com/minio/minio) in a
Docker container.
