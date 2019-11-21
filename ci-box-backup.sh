#!/bin/sh -x

BACKUP_DIR="backup-$(date +%Y%m%d_%H%M)"

mkdir $BACKUP_DIR
if [ -f ci-box-conf.yaml ]; then cp ci-box-conf.yaml $BACKUP_DIR; fi

# Get LAVA-Master Docker ID
DOCKERID=$(docker ps |grep server | cut -d' ' -f1)
if [ -z "$DOCKERID" ];then
	exit 1
fi

# copy out the devices configuration
docker exec -ti $DOCKERID tar czf /root/devices.tar.gz /etc/lava-server/dispatcher-config/devices/ || exit $?
docker cp $DOCKERID:/root/devices.tar.gz $BACKUP_DIR/ || exit $?
docker exec -ti $DOCKERID rm /root/devices.tar.gz || exit $?

# copy out the postgresql database
# for an unknown reason pg_dump > file doesnt work
docker exec -ti $DOCKERID sudo -u postgres pg_dump --create --clean lavaserver --file /tmp/db_lavaserver || exit $?
docker exec -ti $DOCKERID gzip /tmp/db_lavaserver || exit $?
docker cp $DOCKERID:/tmp/db_lavaserver.gz $BACKUP_DIR/ || exit $?
docker exec -ti $DOCKERID rm /tmp/db_lavaserver.gz || exit $?

# copy out the job results
docker exec -ti $DOCKERID tar czf /root/joboutput.tar.gz /var/lib/lava-server/default/media/job-output/ || exit $?
docker cp $DOCKERID:/root/joboutput.tar.gz $BACKUP_DIR/ || exit $?
docker exec -ti $DOCKERID rm /root/joboutput.tar.gz || exit $?


# Get Slave Docker ID
DOCKERID=$(docker ps |grep worker | cut -d' ' -f1)
if [ -z "$DOCKERID" ];then
	exit 1
fi

# copy out the ssh configuration from slave
docker exec -ti $DOCKERID tar czf /root/ssh.tar.gz /root/.ssh/ || exit $?
docker cp $DOCKERID:/root/ssh.tar.gz $BACKUP_DIR/ || exit $?
docker exec -ti $DOCKERID rm /root/ssh.tar.gz || exit $?

echo "Backup done in $BACKUP_DIR"
rm -f backup-latest
ln -sf $BACKUP_DIR backup-latest
