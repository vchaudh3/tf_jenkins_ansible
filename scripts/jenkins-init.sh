#!/bin/bash

# volume setup
echo "vgchange..."
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
	echo "DEVICEEXISTS: $DEVICEEXISTS"
    if [[ $DEVICEEXISTS != "1" ]]; then
		echo "waiting lsblk..."
		echo `date`
      sleep 15
	  echo `date`
	  echo "marking DEVICEEXISTS as NULL"
	  DEVICEEXISTS=''
    fi
  done
  echo "pvcreate..."
  pvcreate ${DEVICE}
  echo "vgcreate..."
  vgcreate data ${DEVICE}
  echo "lvcreate..."
  lvcreate --name volume1 -l 100%FREE data
  echo "mkfs.ext4..."
  mkfs.ext4 /dev/data/volume1
fi
echo "mkdir..."
mkdir -p /var/lib/jenkins
echo "fstab..."
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
echo "mounting..."
mount /var/lib/jenkins
echo "mounted..."

