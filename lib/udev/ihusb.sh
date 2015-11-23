#!/bin/bash
#

DEVICE=$1
HOMEPATH="/opt/intrahouse"

# ON ADD DEVICE
if [ $2 == "add" ]; then

    # check input
    if [ -z "$DEVICE" ]; then
        exit 1
    fi

    # test that this device isn't already mounted
    device_is_mounted=`grep ${DEVICE} /etc/mtab`
    if [ -n "$device_is_mounted" ]; then
        exit 1
    fi


    # pull in useful variables from blkid -o udev, quote everything Just In Case
    eval `/sbin/blkid -o udev /dev/${DEVICE} | sed 's/^/export /; s/=/="/; s/$/"/'`

    export ID_FS_LABEL=$(echo "$ID_FS_LABEL" | tr '[:upper:]' '[:lower:]')

    if [ "$ID_FS_LABEL" == "photo" ] || [ "$ID_FS_LABEL" == "ihservice" ]; then

        if [ -z "$ID_FS_LABEL" ] || [ -z "$ID_FS_TYPE" ]; then
            exit 1
        fi

        # test mountpoint - it shouldn't exist
        if [ ! -e "$HOMEPATH/${ID_FS_LABEL}" ]; then
            mkdir -m 777 "$HOMEPATH/${ID_FS_LABEL}"
        fi

        # different methods to mount for every filesystem
        case "$ID_FS_TYPE" in

            vfat)  mount -t vfat -o sync,noatime,uid=1000 /dev/${DEVICE} "$HOMEPATH/${ID_FS_LABEL}"
            ;;

            # I like the locale setting for ntfs
            ntfs)  mount -t auto -o sync,noatime,uid=1000,locale=en_US.UTF-8 /dev/${DEVICE} "$HOMEPATH/${ID_FS_LABEL}"
            ;;

            # ext2/3/4 don't like uid option
            ext*)  mount -t auto -o sync,noatime /dev/${DEVICE} "$HOMEPATH/${ID_FS_LABEL}"
            ;;
        esac
      

        if [ "$ID_FS_LABEL" == "ihservice" ]; then
            sh "$HOMEPATH/${ID_FS_LABEL}/ihservice.sh" "$HOMEPATH/${ID_FS_LABEL}" &
        fi
        
        # all done here, return successful
        exit 0

    fi
elif [ $2 == "remove" ]; then

    # set the mountpoint name according to partition or device name
    export ID_FS_LABEL=$(echo "$ID_FS_LABEL" | tr '[:upper:]' '[:lower:]')
    mount_point=$ID_FS_LABEL

    if [ -z $mount_point ]; then
        mount_point=${DEVNAME##*/}
    fi

    # remove the mountpoint directory from /media/ (if not empty)
    if [ -n $mount_point ]; then

        umount -l $HOMEPATH/$mount_point

        if [ $mount_point != "photo" ]; then
            rm -R $HOMEPATH/$mount_point
        fi
    fi

fi
