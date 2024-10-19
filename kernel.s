// kernel.s

_start:
	mrs	x9,mpidr_el1	// multi-processor affinity register for EL1
	and	x9,x9,0xFF	// mask bits 0-7 (Aff0) which contain processor ID for RPi4B
	cmp	x9,0	// check if core 0
	b.eq	.core_0	// continue on core 0

.stop_core:			// put other cores to sleep
	wfe		// wait for an event
	b	.stop_core	// loop forever

.core_0:
	adr	x0,hello_msg
	mov	x1,hello_msg_size
	bl	write_bytes_pri_uart

	b	.stop_core	// done


	.set	MMIO,0xFE000000	// base address of memory-mapped I/O for RPi4B
	.set	PRI_UART,0x201000	// primary UART MMIO offset for RPi4B

// write_bytes_pri_uart - write bytes to the primary UART
// size write_bytes_pri_uart(byte const * const data, size const count);
write_bytes_pri_uart:
	add	x9,x0,x1	// x9 = data + count (byte after last)
.write_b_p_u_loop:	ldrb	w10,[x0],1	// w10 = *data++ (load byte then increment address)
	mov	x12,MMIO
	add	x12,x12,PRI_UART	// x12 = uart data register adddress
.write_b_p_u_inner:	ldr	w11,[x12,0x18]	// w11 = uart flag register
	tst	w11,0x20	// test uart flag register bit 5 (TXFF) is set
	bne	.write_b_p_u_inner	// if set, wait for it to clear
	strb	w10,[x12]	// store byte in uart data register
	cmp	x0,x9	// check if we are done
	b.ne	.write_b_p_u_loop	// if not done, repeat
	mov	x0,x1	// return count
	ret

hello_msg:	.ascii	"hello world\r\n"
	.set	hello_msg_size,(. - hello_msg)
