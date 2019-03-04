# Lego

[![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/lego-arm.svg?style=plastic)](https://hub.docker.com/r/keyglitch/lego-arm)


This is a Dockerfile to wrap [Lego](https://github.com/xenolf/lego) into an ARM container (a Let's Encrypt client in Go).

### Example invocations

#### Getting a certificate using the DNS challenge
	
	docker run --rm \
	-v $HOME/.config/lego:/.lego \
	-e CLOUDFLARE_EMAIL="REPLACE_ME@example.com" \
	-e CLOUDFLARE_API_KEY="REPLACE_ME" \
	keyglitch/lego-arm:latest \
	--email="REPLACE_ME@example.com" \
	--domains="REPLACE_ME.example.com" \
	--dns="cloudflare" \
	--dns-resolvers="8.8.8.8" \
	--dns-resolvers="8.8.4.4" \
	-a \
	run \
	
#### Renewing a certificate

	docker run --rm \
	-v $HOME/.config/lego:/.lego \
	-e CLOUDFLARE_EMAIL="REPLACE_ME@example.com" \
	-e CLOUDFLARE_API_KEY="REPLACE_ME" \
	keyglitch/lego-arm:latest \
	--email="REPLACE_ME@example.com" \
	--domains="REPLACE_ME.example.com" \
	--dns="cloudflare" \
	--dns-resolvers="8.8.8.8" \
	--dns-resolvers="8.8.4.4" \
	renew \
	--days=60