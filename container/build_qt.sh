#!/bin/bash

cd /home/developer/RPI3_DEV && \
mkdir qt-build && cd qt-build && \
chmod +x /home/developer/Qt/5.11.2/Src/configure && chmod +x /home/developer/Qt/5.11.2/Src/qtbase/configure && \
/home/developer/Qt/5.11.2/Src/configure --sysroot=/home/developer/RPI3_DEV/sysroot \
	-device linux-rasp-pi3-vc4-g++ \
	-device-option CROSS_COMPILE=/home/developer/RPI3_DEV/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf- \
	-device-option INCLUDEPATH+=$$[QT_SYSROOT]/usr/include/arm-linux-gnueabihf \
	-device-option LIBS+=-L$$[QT_SYSROOT]/usr/lib/arm-linux-gnueabihf \
	-nomake examples -opensource -confirm-license -v -pkg-config -no-qml-debug -opengl es2 -optimized-qmake \
	-c++std c++11 -hostprefix ../qt-host-tools -release -force-debug-info -shared -skip wayland -skip script -qt-xcb && \
make -j16 && \
sudo mkdir -p /home/developer/RPI3_DEV/sysroot/usr/local/Qt-5.11.2 && sudo chown 1000:1000 /home/developer/RPI3_DEV/sysroot/usr/local/Qt-5.11.2 && \
make install && \
rm -rf /home/developer/RPI3_DEV/qt-build
