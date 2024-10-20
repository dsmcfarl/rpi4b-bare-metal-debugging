#!/bin/sh
if [ $# -ne 1 ]; then
  echo "usage: serial.sh <device>"
  exit 1
fi
picocom -b 115200 $1
