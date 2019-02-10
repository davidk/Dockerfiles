# alertmanager - ARM
[![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/alertmanager.svg?style=plastic)](https://hub.docker.com/r/keyglitch/alertmanager)

`getLatestAlertManager.sh` writes out a Dockerfile to re-pack the upstream ARM distribution into
a Docker container. This allows `Alertmanager` to be easily pulled in for use on a Raspberry Pi (or equivalent).

This script isn't intended for use by an end user (unless you want to generate your own Dockerfile, or see how the pieces fit together).

	usage: ./getLatestAlertManager.sh [ windows | openbsd | netbsd | linux | freebsd | darwin | dragonfly ] [ armv5 | armv6 | armv7 ] [ latest | tag ]

	example (latest): ./getLatestAlertManager.sh linux armv7 latest
	example (tagged): ./getLatestAlertManager.sh linux armv5 v0.7.0

	set example.com to the domain you'll use to access alertmanager
	this allows it to work from within a container

