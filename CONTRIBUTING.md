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

If you want to cut a new release, make sure you include the phrase `Release-As: x.x.x` in your pull
request's final commit message. _Don't worry about bumping any version numbers in the source._ The
Release Please bot will do that for you in a new release PR.
