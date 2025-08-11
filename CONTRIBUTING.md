# Contributing

## Two ways to play

If you want to get started editing the code, you have two options:

1. Install all dev-time dependencies on your machine. _Check out
   [.tool-versions](.tool-versions) and / or the [Dockerfile](Dockerfile) to discover
   what the build environment looks like._ Then you can use `make build`, `make test`,
   etc.
2. Use Docker. `make ci` will build a Docker container and run the CI process inside,
   producing a final `backup` script at the end. This is the same process that runs in
   GitHub Actions.

## Creating a new release

[git-cliff](https://git-cliff.org/) and [Conventional Commits](https://www.conventionalcommits.org/)
partially automate the release process. _You don't need to use Conventional Commits
for your day-to-day committing._ You just need to make sure all _pull requests_ have a
Conventional Commit title.

If you did your Conventional Commits correctly, you can create a release PR with a
version bump and a `make changelog`. Make sure the final commit message looks like
`chore(release): ...`.

After that's merged, you can run the Release workflow via `make release`.

## Testing

Generally we only do automated testing for the "offsite" use case. This is because it requires no
root privileges or physical devices. All it requires is running an ephemeral S3-compatible service
in the background during tests. For this, we use [MinIO](https://github.com/minio/minio) in a
Docker container.
