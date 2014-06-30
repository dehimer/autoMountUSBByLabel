#!/bin/bash
#
# USAGE: usb-automounter.sh DEVICE 
#   DEVICE   is the actual device node at /dev/DEVICE
/lib/udev/udev-auto-mount.sh ${1} &

