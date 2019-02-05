# theia-docker-armv6

	docker run -it -p 3000:3000 \
	-v $(pwd):/home/project:z \
	keyglitch/theia-docker-armv6

This is a modified Dockerfile from the [theia-apps repository](https://github.com/theia-ide/theia-apps/tree/master/theia-docker), modified
to build on a Raspberry Pi 3.

To build this yourself, it is recommended to attach a [USB swap disk](https://raspberrypi.stackexchange.com/questions/70/how-to-set-up-swap-space) (several GB recommended), as memory/uSD write cycles are limited on the Pi 3.
