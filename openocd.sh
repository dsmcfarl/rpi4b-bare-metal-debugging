#!/bin/sh
#openocd --file interface/jlink.cfg --file ./rpi4b.cfg
openocd --file ./ft232h.cfg --file ./rpi4b.cfg
