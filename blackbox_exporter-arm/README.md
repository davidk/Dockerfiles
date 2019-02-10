# blackbox_exporter - ARM

[![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/blackbox_exporter.svg?style=plastic)](https://hub.docker.com/r/keyglitch/blackbox_exporter)

`getLatestBlackBoxExporter2Release.sh` writes out a Dockerfile to re-pack the upstream ARM distribution into a Docker container. This allows `blackbox_exporter` to be easily pulled in for use on a Raspberry Pi (or equivalent).

This script isn't intended for use by an end user (unless you want to generate your own Dockerfile, or see how the pieces fit together).

	usage: ./getLatestBlackBoxExporter2Release.sh [ windows | openbsd | netbsd | linux | freebsd | darwin | dragonfly ] [ armv5 | armv6 | armv7 ] [ latest | tag ]

	example (latest): ./getLatestBlackBoxExporter2Release.sh linux armv7 latest
	example (tagged): ./getLatestBlackBoxExporter2Release.sh linux armv5 v0.7.0
