#!/bin/bash
#
# USAGE: udev-auto-mount.sh DEVICE
#   DEVICE   is the actual device node at /dev/DEVICE
# 
# This script takes a device name, looks up the partition label and
# type, creates /media/LABEL and mounts the partition.  Mount options
# are hard-coded below.

#eval echo ~$USER >> /home/vam/intrahouse/udev_test_log.txt

DEVICE=$1
#echo "$DEVICE" > /home/vam/intrahouse/udev_test_log.txt
# check input
if [ -z "$DEVICE" ]; then
   #echo NO DEVICE >> /home/vam/intrahouse/udev_test_log.txt
   exit 1
fi

# test that this device isn't already mounted
device_is_mounted=`grep ${DEVICE} /etc/mtab`
if [ -n "$device_is_mounted" ]; then
   #echo "error: seems /dev/${DEVICE} is already mounted" >> /home/vam/intrahouse/udev_test_log.txt
   exit 1
fi

# If there's a problem at boot-time, this is where we'd put
# some test to check that we're booting, and then run
#     sleep 60
# so the system is ready for the mount below.
#
# An example to experiment with:
# Assume the system is "booted enough" if the HTTPD server is running.
# If it isn't, sleep for half a minute before checking again.
#
# The risk: if the server fails for some reason, this mount script
# will just keep waiting for it to show up.  A better solution would
# be to check for some file that exists after the boot process is complete.
#
# HTTPD_UP=`ps -ax | grep httpd | grep -v grep`
# while [ -z "$HTTPD_UP" ]; do
#    sleep 30
#    HTTPD_UP=`ps -ax | grep httpd | grep -v grep`
# done


# pull in useful variables from blkid -o udev, quote everything Just In Case
eval `/sbin/blkid -o udev /dev/${DEVICE} | sed 's/^/export /; s/=/="/; s/$/"/'`

echo "$ID_FS_LABEL" | tr '[:upper:]' '[:lower:]'
export ID_FS_LABEL=$(echo "$ID_FS_LABEL" | tr '[:upper:]' '[:lower:]')

#echo "test label $ID_FS_LABEL on equal to photo" >> /home/vam/intrahouse/udev_test_log.txt
if [ "$ID_FS_LABEL" != "photo" ]; then
    #echo NO PHOTO >> /home/vam/intrahouse/udev_test_log.txt
    exit 1
fi

#export ID_FS_LABEL="USB13"

if [ -z "$ID_FS_LABEL" ] || [ -z "$ID_FS_TYPE" ]; then
   #echo "error: ID_FS_LABEL is empty! did blkid -o udev break? tried /dev/${DEVICE}" > /home/vam/intrahouse/udev_test_log.txt
   exit 1
fi
#echo "$ID_FS_LABEL" >> /home/vam/intrahouse/udev_test_log.txt

# test mountpoint - it shouldn't exist
if [ ! -e "/home/vam/intrahouse/${ID_FS_LABEL}" ]; then

   # make the mountpoint
   #echo "/home/vam/intrahouse/${ID_FS_LABEL} create" >> /home/vam/intrahouse/udev_test_log.txt
   mkdir -m 777 "/home/vam/intrahouse/${ID_FS_LABEL}"
   #echo "/home/vam/intrahouse/${ID_FS_LABEL} created" >> /home/vam/intrahouse/udev_test_log.txt
fi

# test mountpoint used
#echo "TEST BUSY MOUNT_POINT /home/vam/intrahouse/${ID_FS_LABEL}"  >> /home/vam/intrahouse/udev_test_log.txt
# MOUNT_POINT_BUSY = `mount | grep /home/vam/intrahouse/${ID_FS_LABEL}`
#MOUNT_POINT_BUSY = `mount | grep /home/vam/intrahouse/${ID_FS_LABEL}`
#echo "BUSY MOUNT_POINT: ${MOUNT_POINT_BUSY}"  >> /home/vam/intrahouse/udev_test_log.txt
#if [ -т $MOUNT_POINT_BUSY ]; then
#    echo $MOUNT_POINT_BUSY >> /home/vam/intrahouse/udev_test_log.txt
#    exit 1
#fi


# mount the device
# 
# If expecting thumbdrives, you probably want 
#      mount -t auto -o sync,noatime [...]
# 
# If drive is VFAT/NFTS, this mounts the filesystem such that all files
# are owned by a std user instead of by root.  Change to your user's UID
# (listed in /etc/passwd).  You may also want "gid=1000" and/or "umask=022", eg:
#      mount -t auto -o uid=1000,gid=1000 [...]
# 
#
#echo "$ID_FS_TYPE" >> /home/vam/intrahouse/udev_test_log.txt 
case "$ID_FS_TYPE" in

vfat)  mount -t vfat -o sync,noatime,uid=1000 /dev/${DEVICE} "/home/vam/intrahouse/${ID_FS_LABEL}"
      ;;

      # I like the locale setting for ntfs
ntfs)  mount -t auto -o sync,noatime,uid=1000,locale=en_US.UTF-8 /dev/${DEVICE} "/home/vam/intrahouse/${ID_FS_LABEL}"
      ;;

      # ext2/3/4 don't like uid option
ext*)  mount -t auto -o sync,noatime /dev/${DEVICE} "/home/vam/intrahouse/${ID_FS_LABEL}"
      ;;
esac

# all done here, return successful
exit 0

