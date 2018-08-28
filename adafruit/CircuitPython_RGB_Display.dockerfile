# Adafruit CircuitPython RGB Display (Python Bundle Builder)
# https://github.com/adafruit/Adafruit_CircuitPython_RGB_Display
#
# Instructions:
#
# `docker build -f CircuitPython_RGB_Display.dockerfile -t rgb-display .`
#
# Copying files out with docker-cp:
#
# `mkdir ./rgb-lib && docker cp $(docker run --name circuitpython-copy -idt rgb-display bash):/home/python ./rgb-lib/ && docker rm -f circuitpython-copy`
# 
# Bundles will land in `./rgb-lib/python/Adafruit_CircuitPython_RGB_Display/bundles`

FROM ubuntu:18.04

RUN apt-get update && \
apt-get upgrade -y && \
apt-get -y install python3 python3-pip python3-venv build-essential git

RUN useradd -ms /bin/bash python
USER python
WORKDIR /home/python

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN python3 -m venv .env && \
/bin/bash -c "source $HOME/.env/bin/activate && pip3 install wheel && \
pip3 install circuitpython-build-tools && \
git clone https://github.com/adafruit/Adafruit_CircuitPython_RGB_Display && \
cd Adafruit_CircuitPython_RGB_Display && \
circuitpython-build-bundles --filename_prefix adafruit-circuitpython-rgb_display --library_location ."
