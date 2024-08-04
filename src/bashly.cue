name:    "backup"
help:    "A very opinionated backup tool"
version: "0.1.0"

#DestFlag: {
	long:  "--dest"
	short: "-d"
	arg:   "destination"
	help:  "Destination repository"
	allowed: ["local", "remote"]
}

#DestArg: {
	name:     "destination"
	help:     "Destination repository"
	required: true
	allowed: ["local", "remote"]
}

commands: [
	{
		name: "init"
		help: "Initialize a new repository"
		args: [
			#DestArg,
		]
		examples: [
			"backup init remote",
		]
	},
	{
		name: "run"
		help: "Backup data to one or both repositories"
		flags: [
			#DestFlag,
		]
		examples: [
			"backup run",
			"backup run --dest remote",
		]
	},
	{
		name: "check"
		help: "Check your backup repository for errors"
		flags: [
			#DestFlag,
			{
				long:  "--file"
				short: "-f"
				help:  "Verify a file on your local device matches the backup"
			},
		]
		examples: [
			"backup check",
			"backup check --dest local",
			"backup check --file foo/bar.txt",
		]
	},
	{
		name: "mount"
		help: "Mount your backup repository"
		args: [
			#DestArg,
		]
	},
	{
		name: "unmount"
		help: "Unmount your backup repository"
		args: [
			#DestArg,
		]
	},
	{
		name: "config"
		help: "View or edit your backup config"
		flags: [
			{
				long:  "--edit"
				short: "-e"
				help:  "Open your config in \\$EDITOR"
			},
			{
				long:  "--no-pager"
				short: "-n"
				help:  "Don't use `bat` or `less`"
			},
		]
	},
]
