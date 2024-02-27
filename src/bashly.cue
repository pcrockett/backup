name:    "backup"
help:    "A very opinionated backup tool"
version: "0.1.0"

#DestFlag: {
	long:  "--dest"
	short: "-d"
	arg:   "destination"
	help:  "Destination repository (s3 or usb)"
}

#DestArg: {
	help:     "Destination repository (s3 or usb)"
	name:     "destination"
	required: true
}

commands: [
	{
		name: "init"
		help: "Initialize a new repository"
		args: [
			#DestArg,
		]
		examples: [
			"backup init s3",
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
			"backup run --dest s3",
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
			"backup check --dest usb",
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
]
