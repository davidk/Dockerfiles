# Perkeep in a container (ARMified)

[![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/perkeep-arm.svg?style=plastic)](https://hub.docker.com/r/keyglitch/perkeep-arm)

This directory contains a script to build and repack upstream Perkeep into a Docker image that is suitable for running on ARM-based systems. Note that it isn't intended for direct consumption; only if you're curious about what the plumbing looks like.

To grab and run the Docker image (assuming you are using Lets Encrypt):

	docker run -d -p 0.0.0.0:3179:3179 \
	  --name perkeep \
	  -v $HOME/.config/lego/certificates/$HOSTNAME.key:/home/perkeep/.config/perkeep/certs/private.key \
	  -v $HOME/.config/lego/certificates/$HOSTNAME.crt:/home/perkeep/.config/perkeep/certs/public.crt \
	  -v $HOME/.config/perkeep:/.config/perkeep/ \
	  -v /media/disk/perkeep_files:/var/perkeep \
	  --restart unless-stopped \
	  keyglitch/perkeep-arm:latest

	*** Recovery mode ***
	If you need to run perkeep in recovery, change this line to this:
		keyglitch/perkeep-arm -recovery=1
