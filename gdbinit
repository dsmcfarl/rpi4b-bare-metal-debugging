# prevent confirmation everytime we try to quit
define hook-quit
	set confirm off
end

# load the kernel, load symbols, and set the program counter
define buildload
	shell printf '\r\nbuilding kernel...\r\n'
	shell ./build.sh

	shell printf 'loading kernel...\r\n'
	restore build/kernel.bin binary 0x80000
	add-symbol-file build/kernel.sym 0x80000

	shell printf 'setting program counter...\r\n'
	set $pc=0x80000
end

# reset the RPi4B using the srst signal (connected to J2 RUN pin) and wait 15
# second for reboot and openocd to reconnect then halt
define resethalt
	shell printf 'resetting...\r\n'
	monitor adapter assert srst
	shell sleep 1
	monitor adapter deassert srst

	shell printf 'waiting 15 seconds...\r\n'
	shell sleep 15

	shell printf 'halting...\r\n'
	monitor halt
end

# build, reset, and load the kernel
define resetload
	resethalt
	buildload
	# redraw TUI
	refresh
end

# Connect to openocd (must already be running and the RPi4B must be powered on).
target extended-remote :3333

# Setup the GDB TUI to show three windows with registers in one and assembly in the other.
layout split
layout regs

# Call our custom command to reset and load
# resetload
