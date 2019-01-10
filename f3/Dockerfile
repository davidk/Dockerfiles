# F3 - Fight Flash Fraud
# https://github.com/AltraMayor/f3
#
# Instructions:
#
# `docker build -t f3 .`
#
# Running
# docker run --cap-add SYS_ADMIN --device /dev/mmcblk0p1 -it f3 bash^C
#

FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
apt-get upgrade -y && \
apt-get -y install f3 && \
rm -rf /var/lib/apt/lists/*

