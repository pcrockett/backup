name:    "backup"
help:    "A very opinionated backup tool"
version: "0.1.0"

#External: "external"
#Offsite:  "offsite"

#DestOptionalArg: {
	name:     "destination"
	help:     "Destination repository"
	required: false
	allowed: [#External, #Offsite]
}

#DestRequiredArg: {
	name:     "destination"
	help:     "Destination repository"
	required: true
	allowed: [#External, #Offsite]
}

commands: [
	{
		name: "init"
		help: "Initialize a new repository"
		args: [
			#DestRequiredArg,
		]
		examples: [
			"backup init \(#Offsite)",
		]
	},
	{
		name: "run"
		help: "Backup data to one or both repositories"
		args: [
			#DestOptionalArg,
		]
		examples: [
			"backup run",
			"backup run \(#External)",
			"backup run \(#Offsite)",
		]
	},
	{
		name: "check"
		help: "Check one or both repositories for errors"
		flags: [
			{
				long:  "--file"
				short: "-f"
				arg:   "file"
				help:  "Verify a file on your device matches the backup"
			},
		]
		args: [
			#DestOptionalArg,
		]
		examples: [
			"backup check",
			"backup check \(#External)",
			"backup check --file foo/bar.txt",
			"backup check \(#Offsite) --file foo/bar.txt",
		]
	},
	{
		name: "mount"
		help: "Mount your backup repository"
		args: [
			#DestRequiredArg,
		]
	},
	{
		name: "unmount"
		help: "Unmount your backup repository"
		args: [
			#DestRequiredArg,
		]
	},
	{
		name: "unlock"
		help: "Remove a stale lock from a backup repository"
		args: [
			#DestRequiredArg,
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
