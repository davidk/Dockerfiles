# aptly Dockerfile to build and create a local Raspbian Debian repository
#
# Build: docker build -t aptly . 
# Update/sync: docker run -v /home/pi/Dockerfiles/aptly/aptly-repo:/home/aptly/.aptly/pool:rw -it aptly mirror update rasp
# Serve repository: docker run -v /home/pi/Dockerfiles/aptly/aptly-repo:/home/aptly/.aptly/pool:rw -it aptly serve -listen=:8080

FROM golang:1.16-buster

ARG RASPBIAN_REPO=http://mirrors.ocf.berkeley.edu/raspbian/raspbian
ARG RASPBIAN_DIST=buster

ENV GOARCH=arm

RUN apt-get update && \
apt-get upgrade -y && \
apt-get install gnupg2 wget -y

RUN git clone https://github.com/aptly-dev/aptly && \
cd aptly && \
make modules install

RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys ED75B5A4483DA07C && \
wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - && \
gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import

RUN useradd -ms /bin/bash aptly
USER aptly
WORKDIR /home/aptly

RUN gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver pool.sks-keyservers.net --recv-keys 9165938D90FDDD2E && \
aptly mirror create rasp $RASPBIAN_REPO $RASPBIAN_DIST

ENTRYPOINT ["aptly"]
