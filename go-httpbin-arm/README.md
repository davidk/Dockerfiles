# go-httpbin - ARM

[![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/go-httpbin-arm.svg?style=plastic)](https://hub.docker.com/r/keyglitch/go-httpbin-arm)

# Running this

	docker run -p 8080:8080 keyglitch/go-httpbin-arm

The container will begin serving go-httpbin's contents on port 8080. To daemonize, change the parameters to:

	docker run -d --name httpbin -p 8080:8080 keyglitch/go-httpbin

Shutting down/cleaning up:

	docker stop httpbin && docker rm httpbin

# Dockerfile generator

`getLatestGoHttpBin2Release.sh` writes out a Dockerfile to re-pack the upstream ARM distribution into a Docker container. This allows `go-httpbin` to be easily pulled in for use on a Raspberry Pi (or equivalent).

This script isn't intended for use by an end user (unless you want to generate your own Dockerfile, or see how the pieces fit together).

	usage: ./getLatestGoHttpBin2Release.sh [ commit ]

	example (head): ./getLatestGoHttpBin2Release.sh HEAD
	example (commit): ./getLatestGoHttpBin2Release.sh c5cb2f4802fac63859778c72989fe88dce35fe35
