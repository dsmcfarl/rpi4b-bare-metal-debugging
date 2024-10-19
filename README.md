# Raspberry Pi 4 Model B Bare Metal Debugging

Example code and instructions for debugging Raspberry Pi 4 Model B bare metal programs.

I created this repo as an offshoot of my (AArch64OS)[https://github.com/dsmcfarl/aarch64os] project. I found there
wasn't great information about how to setup to debug a bare metal program on the Raspberry Pi 4 Model B using GDB and
JTAG. There were a lot of resources taht helped get JTAG working, but not much on how to actually setup a good work
flow. This repo is meant to help with that.

1. Clone the repository

```sh
git clone git@github.com:dsmcfarl/rpi4b-bare-metal-debugging.git
cd rpi4b-bare-metal-debugging
```

2. Install tools

```sh
./get-tools.sh
```
    
3. build

```sh
./build.sh
```

4. Create a bootable sd card
   Insert an sd card into a card reader and run:

```sh
sudo dmesg | tail # to see the device name
./sdcard.sh /dev/sdX # where /dev/sdX is the device name of the sd card
```

5. Start a serial terminal

```sh
./serial.sh
```

6. Boot
   Insert the sd card into the Rasberry Pi and power it on. You should see the kernel booting in the serial terminal.

7. Start openocd in another terminal

```sh
./openocd.sh
```

8. Start gdb in another terminal

```sh
./gdb.sh
```

9. Load the kernel and test
   In gdb, run:

```gdb
resetload
continue
```

10. Make changes to kernel.s

11. Reload the kernel and test

```gdb
resetload
continue
```
