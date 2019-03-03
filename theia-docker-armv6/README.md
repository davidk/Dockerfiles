# theia-docker-armv6

[![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/theia-docker-armv6.svg?style=plastic)](https://hub.docker.com/r/keyglitch/theia-docker-armv6)

**Note**: This image is not regularly built on the Docker Hub.

	docker run -it -p 3000:3000 \
	-v $(pwd):/home/project:z \
	keyglitch/theia-docker-armv6

This is a Dockerfile from the [theia-apps repository](https://github.com/theia-ide/theia-apps/tree/master/theia-docker), modified to build on a Raspberry Pi 3.

## Building

### Memory warning

The Raspberry Pi 3 has a limited amount of RAM.

To build this yourself, it is recommended to attach a [USB swap disk](https://raspberrypi.stackexchange.com/questions/70/how-to-set-up-swap-space) (several GB recommended), as microSD write cycles are limited on the Pi 3.

If you don't mind the extra wear on the microSD card, temporarily increasing `CONF_SWAPFILE` (to something like 1024) in /etc/dphys-swapfile and running `/etc/init.d/dphys-swapfile restart` will work too.

### Grab the Dockerfile for this locally

	mkdir theia-docker-armv6 && \
	cd theia-docker-armv6 && \
	curl -sSL https://raw.githubusercontent.com/theia-ide/theia-apps/master/theia-docker/latest.package.json > latest.package.json && \
	curl -sSL https://raw.githubusercontent.com/davidk/Dockerfiles/master/theia-docker-armv6/Dockerfile > Dockerfile && \
	docker build -t theia-docker-armv6 .
