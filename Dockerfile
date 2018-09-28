# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images/create_ros_core_image.Dockerfile.em
FROM ubuntu:bionic

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*


# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    sudo \
    build-essential \
    bash-completion \
    net-tools \
    wget \ 
    libx11-xcb1 \
    libx11-dev \
    libdbus-1-3 \
    libfreetype6-dev \
    libfontconfig1 \
    g++ \
    make \
    libglib2.0-dev \
    libsm-dev \
    libxrender-dev \
    libxext-dev \
    libxcursor-dev \
    libxfixes-dev \
    libxft-dev \
    libxi-dev \
    libxrandr-dev \
    libgl-dev \
    libglu-dev \
    && rm -rf /var/lib/apt/lists/*
    
RUN echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

RUN echo "xpi3" > /etc/hostname

RUN useradd -rms /bin/bash -u 1000 developer

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

USER developer:developer
WORKDIR /home/developer

RUN wget http://download.qt.io/official_releases/qt/5.11/5.11.2/qt-opensource-linux-x64-5.11.2.run
COPY container/qt-installer.qs /home/developer
RUN chmod +x qt-opensource-linux-x64-5.11.2.run && QT_INSTALL_DIR=/home/developer/Qt ./qt-opensource-linux-x64-5.11.2.run --platform minimal --verbose --script qt-installer.qs
RUN sudo ln -s /home/developer/Qt/Tools/QtCreator/bin/qtcreator /bin/qtcreator

# RPI3 Cross compilation
RUN sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y git python

RUN mkdir RPI3_DEV && cd RPI3_DEV && \
    git clone git://github.com/raspberrypi/tools.git && \
    mkdir qt-host-tools && mkdir sysroot && \
    mv tools/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++ tools/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++.real

COPY container/arm-linux-gnueabihf-g++ /home/developer/RPI3_DEV/tools/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++

RUN sudo chown developer:developer /home/developer/RPI3_DEV/tools/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++
RUN chmod +x /home/developer/RPI3_DEV/tools/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++

COPY container/build_qt.sh /home/developer

RUN sed -i '31iINCLUDEPATH += $$[QT_SYSROOT]/usr/include/arm-linux-gnueabihf\nLIBS += -L$$[QT_SYSROOT]/usr/lib/arm-linux-gnueabihf' \
/home/developer/Qt/5.11.2/Src/qtbase/mkspecs/devices/linux-rasp-pi3-vc4-g++/qmake.conf

CMD ["/bin/bash"]
