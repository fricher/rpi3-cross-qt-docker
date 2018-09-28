#!/bin/bash

docker build -t rpi3-prothese .

ssh pi@192.168.1.123 'sudo apt-get update && \
	sudo apt-get upgrade -y && \
	sudo apt-get build-dep -y qt5-default && \
	sudo apt-get install -y symlinks ntpdate && \
	sudo symlinks -cr /lib /usr/lib /usr/local/lib && \
	sudo ntpdate-debian ntp.isir.upmc.fr && \
	sudo systemctl restart nfs-server.service '


docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.123,rw,vers=4,soft --opt device=:/ rpi3_sysroot
docker volume inspect rpi3_sysroot

docker run -it \
	-v rpi3_sysroot:/home/developer/RPI3_DEV/sysroot \
	--net=host rpi3-prothese /bin/bash -c './build_qt.sh'

./update.sh
