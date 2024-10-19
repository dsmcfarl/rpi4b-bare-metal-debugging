#!/bin/sh -e
FIRMWARE=tools/firmware-1.20241008
TOOLCHAIN=tools/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-elf/bin
PREFIX=aarch64-none-elf-
AS=${TOOLCHAIN}/${PREFIX}as
OBJCOPY=${TOOLCHAIN}/${PREFIX}objcopy
OBJDUMP=${TOOLCHAIN}/${PREFIX}objdump

# cleanup last build
rm -rf build
mkdir build

# kernel ###############################################################################################################

# assemble
$AS -g -c kernel.s -o build/kernel.o

# extract just the binary without the ELF header; RPi4 bootloader does not want an ELF header
$OBJCOPY -O binary build/kernel.o build/kernel.bin

# extract the debug information from the ELF file (used with gdb)
$OBJCOPY --only-keep-debug build/kernel.o build/kernel.sym

# extract the disassembly from the ELF file (used for inspecting the code)
$OBJDUMP -D build/kernel.o > build/kernel.dump

# loop.bin is used as a dummy kernel that just loops forever waiting for gdb to connect and load the real kernel for development
$AS -c loop.s -o build/loop.o
$OBJCOPY -O binary build/loop.o build/loop.bin

mkdir -p build/boot/overlays

cp $FIRMWARE/boot/bcm2711-rpi-4-b.dtb build/boot/
cp $FIRMWARE/boot/fixup4.dat build/boot/
cp $FIRMWARE/boot/start4.elf build/boot/
cp $FIRMWARE/boot/overlays/disable-bt.dtbo build/boot/overlays/
cp config.txt build/boot/
cp build/kernel.bin build/boot/
cp build/loop.bin build/boot/
