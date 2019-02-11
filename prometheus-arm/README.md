# prometheus - ARM

`getLatestPrometheus2Release.sh` writes out a Dockerfile to re-pack the upstream ARM distribution into a Docker container. This allows `prometheus` to be easily pulled in for use on a Raspberry Pi (or equivalent).

This script isn't intended for use by an end user (unless you want to generate your own Dockerfile, or see how the pieces fit together).

	usage: ./getLatestPrometheus2Release.sh [ windows | openbsd | netbsd | linux | freebsd | darwin | dragonfly ] [ armv5 | armv6 | armv7 ] [ latest | tag ]

	example (latest, for armv7): ./getLatestPrometheus2Release.sh linux armv7 latest
	example (tagged, version v0.7.0 for armv5): ./getLatestPrometheus2Release.sh linux armv5 v0.7.0

