# build, reset, and load the kernel
define resetload
	# reset the RPi4B using the srst signal (connected to J2 RUN pin)
	monitor adapter assert srst
	shell sleep 1
	monitor adapter deassert srst

	shell printf "Waiting 15 seconds for RPi4B to boot and openocd to reconnect...\r\n"
	shell sleep 15

	# halt the core
	monitor halt

	# build the kernel
	shell ./build.sh

	# load the kernel to the RPi4B memory at 0x80000
	restore build/kernel.bin binary 0x80000

	# load the corresponding debug symbols in gdb
	add-symbol-file build/kernel.sym 0x80000

	# set the program counter to the kernel entry point
	set $pc=0x80000
end

# Connect to openocd gdb server (must already be running and the RPi4B must be powered on).
target extended-remote :3333
