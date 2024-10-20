#!/bin/sh -e

if [ $(id -u) -ne 0 ]; then
  echo "must be run as root"
  exit 1
fi

if [ $# -ne 1 ]; then
  echo "usage: sdcard.sh <device>"
  exit 1
fi

if [ ! -d "build/boot" ]; then
  echo "boot directory not found - run build.sh"
  exit 1
fi

# make a 100MiB partition
sh -c "echo 'start=2048, size=204800, type=b' | sfdisk $1"

# format the partition
part="${1}1"  # normal /dev/sda1 format, /dev/mmcblk... format needs a p before the number
mkfs.vfat -F 32 -n BOOT "$part"

# mount the partion, copy boot files, then unmount
mount "$part" /mnt/
cp -r build/boot/* /mnt/
umount /mnt/
