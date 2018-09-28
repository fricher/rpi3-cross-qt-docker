#!/bin/bash

docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.123,rw --opt device=:/ rpi3_sysroot
docker volume inspect rpi3_sysroot


docker run -it -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v $HOME/.Xauthority:/home/developer/.Xauthority \
           -v rpi3_sysroot:/home/developer/RPI3_DEV/sysroot \
           --net=host db3718682b09 qtcreator
