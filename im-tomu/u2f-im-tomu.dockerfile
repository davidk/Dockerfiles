# tomu-u2f builder
# This Dockerfile will build firmware that turns a tomu.im into a U2F token
# For more information about the tomu MCU, please visit: https://tomu.im/
#
# Instructions:
# * Download this Dockerfile
# * Build the container: 
# `docker build -t u2f-autobuild -f u2f-im-tomu.dockerfile .`
#
# * Copy the file out of the image, change :z to :rw, etc (if you've got SELinux)
# `docker run --rm -v $PWD:/outside:z -it u2f-autobuild cp /chopstx/u2f/build/u2f.bin /outside`
# 
# * Follow the instructions here to complete flashing to your tomu
# https://github.com/im-tomu/chopstx/tree/efm32/u2f#flashing
#

FROM ubuntu:artful

RUN apt-get update && \
apt-get install -y software-properties-common git && \
apt-add-repository -y ppa:team-gcc-arm-embedded/ppa && \
apt-get update && \
apt-get install -y gcc-arm-embedded && \
apt-get install -y build-essential openssl python-pip && \
pip install --user --upgrade asn1crypto

RUN git clone https://github.com/im-tomu/chopstx && \
cd chopstx/u2f/cert && \
./gen.sh && \
cd ../ && \
make ENFORCE_DEBUG_LOCK=1
