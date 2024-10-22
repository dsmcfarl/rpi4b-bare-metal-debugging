#!/bin/sh
#openocd --file interface/jlink.cfg --file ./rpi4b.cfg
openocd --file interface/ftdi/um232h.cfg --file ./rpi4b.cfg
