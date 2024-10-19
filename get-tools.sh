#!/bin/sh -e
sudo apt install -y wget xz-utils openocd picocom dosfstools fdisk
rm -rf tools
mkdir tools
cd tools
wget https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-elf.tar.xz
tar -xf arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-elf.tar.xz
wget https://github.com/raspberrypi/firmware/archive/refs/tags/1.20241008.tar.gz
tar -xf 1.20241008.tar.gz
