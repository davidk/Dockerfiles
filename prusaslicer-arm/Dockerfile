FROM arm32v7/debian
RUN apt-get update && apt-get install git -y
RUN git clone https://github.com/prusa3d/PrusaSlicer
RUN apt-get install -y git cmake libboost-dev libboost-regex-dev libboost-filesystem-dev libboost-thread-dev libboost-log-dev libboost-locale-dev libcurl4-openssl-dev libwxgtk3.0-dev build-essential pkg-config libtbb-dev zlib1g-dev
RUN cd PrusaSlicer/ && mkdir rpi-build && cd rpi-build && cmake -DSLIC3R_WX_STABLE=1 .. && make -j4
