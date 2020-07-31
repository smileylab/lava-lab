
all: builders servers

builders:
	docker-compose build yocto-builder ubuntu-builder android-builder kernel-builder buildroot-builder qcgui-builder

servers:
	docker-compose build postgres jenkins healthcheck squad lava-server lava-worker

start:
	./udev_reload.sh && docker-compose up -d postgres jenkins healthcheck squad lava-server lava-worker && sudo /home/lava/ci-box/docker-udev-tools/udev-forward.sh

stop:
	docker-compose stop postgres jenkins healthcheck squad lava-server lava-worker && sudo systemctl disable udev-forward.service

status:
	docker-compose ps

clean:
	docker-compose down

distclean:
	docker-compose down
	docker image rm tn/postgres tn/jenkins tn/yocto-builder tn/ubuntu-builder tn/android-builder tn/kernel-builder tn/buildroot-builder tn/qcgui-builder tn/healthcheck tn/squad tn/lava-server tn/lava-worker

.PHONY: all run start stop status restart clean distclean
