#!/bin/bash
MOUNTDIR="/home/USERNAME/TARGEDDIR/" #change on your path

# set the mountpoint name according to partition or device name
export ID_FS_LABEL=$(echo "$ID_FS_LABEL" | tr '[:upper:]' '[:lower:]')
mount_point=$ID_FS_LABEL

if [ -z $mount_point ]; then
    mount_point=${DEVNAME##*/}
fi

# remove the mountpoint directory from /media/ (if not empty)
if [ -n $mount_point ]; then
    umount -l $MOUNTDIR$mount_point
fi
