# F3 - Fight Flash Fraud
# [![Docker hub pulls](https://img.shields.io/docker/pulls/keyglitch/f3.svg?style=plastic)](https://hub.docker.com/r/keyglitch/f3)
# https://github.com/AltraMayor/f3
#
# Instructions:
#
# `docker build -f f3.dockerfile -t f3 .`
# 
# Mount the removable drive onto your filesystem somewhere.
#
# Running
#
#	 docker run --privileged \
#	 -v /replace/with/path/to/removable_media:/f3 \
#	 f3 \
#	 bash -c 'f3write /f3 && f3read /f3'
#

FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
apt-get upgrade -y && \
apt-get -y install f3 && \
rm -rf /var/lib/apt/lists/*
