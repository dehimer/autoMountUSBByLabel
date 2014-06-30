#!/bin/bash
#
# USAGE: usb-automounter.sh DEVICE 
#   DEVICE   is the actual device node at /dev/DEVICE
#echo HELLO ! >> /home/vam/intrahouse/udev_test_log.txt
/lib/udev/udev-auto-mount.sh ${1} &

