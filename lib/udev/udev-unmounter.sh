#!/bin/bash

# set the mountpoint name according to partition or device name
#echo START UNMOUNT >> /home/vam/intrahouse/udev_test_log.txt
export ID_FS_LABEL=$(echo "$ID_FS_LABEL" | tr '[:upper:]' '[:lower:]')
mount_point=$ID_FS_LABEL
#echo "$mount_point 1" >> /home/vam/intrahouse/udev_test_log.txt
if [ -z $mount_point ]; then
    mount_point=${DEVNAME##*/}
fi

#echo "$mount_point 2" >> /home/vam/intrahouse/udev_test_log.txt

# remove the mountpoint directory from /media/ (if not empty)
if [ -n $mount_point ]; then
    #echo "$mount_point unmount" >> /home/vam/intrahouse/udev_test_log.txt
    umount -l /home/vam/intrahouse/$mount_point
    #rm -R /home/vam/intrahouse/$mount_point
fi
