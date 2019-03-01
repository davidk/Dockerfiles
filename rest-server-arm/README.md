# rest-server ARM Dockerfile

[![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/rest-server-arm.svg?style=plastic)](https://hub.docker.com/r/keyglitch/rest-server-arm)

This folder contains a script to re-pack the rest-server ARM release. It is intended for use with devices such as the Raspberry Pis and Odroids.

Docker Hub: `docker pull keyglitch/rest-server-arm`

### Quick Start

Assuming the storage directory for restic data will land in /var/rest-server (change as appropriate).

#### Generate the .htpasswd file

If you have the `htpasswd` utility installed locally:

	htpasswd -B -c /var/rest-server/.htpasswd $USER

If you don't, run the testing configuration, then this command (which will install `htpasswd`). The container ID is output after `docker run` finishes.

	docker exec -it $CONTAINER_ID create_user $USER

#### Docker CLI

##### Testing / setup configuration

	docker run -d \
	-p 8000:8000 \
	-v /var/rest-server:/data \
	--name rest_server \
	-e OPTIONS="--path /data" \
	keyglitch/rest-server-arm

##### With certificates

It's better to have Lets Encrypt setup, so that `restic` doesn't need a CA certificate.

	docker run -d \
	-p 8000:8000 \
	-v /var/rest-server:/data:rw \
	-v $HOME/.lego/certificates:/certs:ro \
	--name rest_server \
	--restart=unless-stopped \
	-e OPTIONS="--path /data --tls --tls-cert /certs/example.crt --tls-key /certs/example.key --private-repos" \
	keyglitch/rest-server-arm

Self-signed instructions are available in the [Usage section](https://github.com/restic/rest-server#usage) of the rest-server documentation, but hasn't been tested in this configuration.

#### restic setup

The scheme is mostly: `restic -r rest:https://user:pass@hostname:8000/user backup -x /`

[restic init for REST server](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html#rest-server)

### License

Portions of this folder contain excerpts from the [rest-server](https://github.com/restic/rest-server/) repository; these are BSD licensed. Please see the LICENSE file for more information.