#!/bin/sh

update_files() {
	make -C ./ci-box-fileserver/ build
}

clean_files() {
	rm -rf Makefile
	rm -rf deploy.sh
	rm -rf udev_reload.sh
	rm -rf udev-forward.sh
	rm -rf udev-forward.service
	rm -rf docker-compose.yml
	rm -rf ./udev
	rm -rf ./ci-box-lava-master/configs/lava_http_fqdn
	rm -rf ./ci-box-lava-master/configs/settings.conf
	rm -rf ./ci-box-lava-master/configs/instance.conf
	rm -rf ./ci-box-lava-master/configs/.pgpass
	rm -rf ./ci-box-lava-master/configs/lava-coordinator
	rm -rf ./ci-box-lava-master/configs/groups
	rm -rf ./ci-box-lava-master/configs/users
	rm -rf ./ci-box-lava-master/configs/tokens
	rm -rf ./ci-box-lava-master/configs/devices
	rm -rf ./ci-box-lava-master/configs/env/*
	rm -rf ./ci-box-lava-worker/configs/conmux/*
	rm -rf ./ci-box-lava-worker/configs/devices
	rm -rf ./ci-box-lava-worker/configs/lava-coordinator
	rm -rf ./ci-box-lava-worker/configs/phyhostname
	rm -rf ./ci-box-lava-worker/configs/lava-slave
	rm -rf ./ci-box-lava-worker/configs/tftpd-hpa
	rm -rf ./ci-box-lava-worker/configs/ser2net.conf
	rm -rf ./docker-udev-tools/udev-forward.conf
}

if [ "$1" = "mrproper" ];then
	exit 0
elif [ "$1" = "update" ]; then
	update_files
	exit 0
elif [ "$1" = "clean" ]; then
	clean_files
	exit 0
fi

clean_files

./ci-box-gen.py $* || exit 1
