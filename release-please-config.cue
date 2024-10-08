"release-type": "simple"
"extra-files": [
	"src/bashly.cue",
]

// manually set next version to be "1.2.3" ignoring conventional commits.
// absence defaults to conventional commits derived next version.
// Note: once the release PR is merged you should either remove this or
// update it to a higher version. Otherwise subsequent `manifest-pr` runs
// will continue to use this version even though it was already set in the
// last release.
// "release-as": "1.2.3",

// BREAKING CHANGE only bumps semver minor if version < 1.0.0
// absence defaults to false
"bump-minor-pre-major": true

// feat commits bump semver patch instead of minor if version < 1.0.0
// absence defaults to false
"bump-patch-for-minor-pre-major": true

// setting the type of prerelease in case of prerelease strategy
"prerelease-type": "beta"

// set default conventional commit => changelog sections mapping/appearance.
// absence defaults to https://git.io/JqCZL
// "changelog-sections": [...]

// when `manifest-release` creates GitHub Releases per package, create
// those as "Draft" releases (which can later be manually published).
// absence defaults to false and Releases are created as already Published.
draft: false

// when `manifest-release` creates GitHub Releases per package, create
// those as "Prerelease" releases that have pre-major or prerelease versions.
// absence defaults to false and all versions are fully Published.
// prerelease: true

// Skip creating GitHub Releases
// Absence defaults to false and Releases will be created. Release-Please still
// requires releases to be tagged, so this option should only be used if you
// have existing infrastructure to tag these releases.
"skip-github-release": false

// sets the manifest pull request title for when releasing multiple packages
// grouped together in the one pull request.
// This option has no effect when `separate-pull-requests` is `true`.
// Template values (i.e. ${scope}, ${component} and ${version}) are inherited
// from the root path's (i.e. '.') package, if present
// absence defaults to "chore: release ${branch}"
// "group-pull-request-title-pattern": "chore: release ${branch}"

// When searching for the latest release SHAs, only consider the last N releases.
// This option prevents paginating through all releases in history when we
// expect to find the release within the last N releases. For repositories with
// a large number of individual packages, you may want to consider raising this
// value, but it will increase the number of API calls used.
"release-search-depth": 400

// When fetching the list of commits to consider, only consider the last N commits.
// This option limits paginating through every commit in history when we may not
// find the release SHA of the last release (there may not be one). We expect to
// only need to consider the last 500 commits on a branch. For repositories with
// a large number of individual packages, you may want to consider raising this
// value, but it will increase the number of API calls used.
"commit-search-depth": 500

// when creating multiple pull requests or releases, issue GitHub API requests
// sequentially rather than concurrently, waiting for the previous request to
// complete before issuing the next one.
// This option may reduce failures due to throttling on repositories releasing
// large numbers of packages at once.
// absence defaults to false, causing calls to be issued concurrently.
// "sequential-calls": false

// per package configuration: at least one entry required.
// the key is the relative path from the repo root to the folder that contains
// all the files for that package.
// the value is an object with the following optional keys:
// - overrides for above top-level defaults AND
// - "package-name": Ignored by packages whose release-type implements source
//                   code package name lookup (e.g. "node"). Required for all
//                   other packages (e.g. "python")
// - "changelog-path": Path + filename of the changelog relative to the
//                     *package* directory. defaults to "CHANGELOG.md". E.g.
//                     for a package key of "path/to/mypkg", the location in
//                     the repo is path/to/pkg/CHANGELOG.md
// - "changelog-host": Override the GitHub host when writing changelog.
//                     Defaults to "https://github.com". E.g. for a commit of
//                     "abc123", it's hyperlink in changelog is
//                     https://github.com/<org>/<repo>/commit/abc123
packages: {
	".": {}
}
