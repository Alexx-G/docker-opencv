FROM debian:jessie
MAINTAINER Alex Gavrisco <alexandr@gavrisco.com>

# Build tools
RUN apt-get update && apt-get upgrade
RUN apt-get update && apt-get install -y \
    build-essential cmake git pkg-config gfortran \
    unzip curl


# Required deps and codecs
RUN apt-get install -y \
    libopencv-dev gfortran \
    libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev \
    python-dev python-numpy

# Additional libs and deps
RUN apt-get install -y \
    libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev \
    libv4l-dev libxvidcore-dev x264 v4l-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd ~ && \
    mkdir -p ocv-tmp && \
    cd ocv-tmp && \
    curl -L https://github.com/opencv/opencv/archive/3.2.0.zip -o ocv.zip && \
    unzip ocv.zip && \
    curl -L https://github.com/opencv/opencv_contrib/archive/3.2.0.zip -o ocv_contrib.zip && \
    unzip ocv_contrib.zip && \
    cd opencv-3.2.0 && \
    mkdir release && \
    cd release && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_PYTHON_SUPPORT=ON \
          -D BUILD_TESTS=NO \
          -D BUILD_PERF_TESTS=NO \
          -DOPENCV_EXTRA_MODULES_PATH=~/ocv-tmp/opencv_contrib-3.2.0/modules \
          .. && \
    make -j4 && \
    make install && \
    rm -rf ~/ocv-tmp