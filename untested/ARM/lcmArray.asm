
    code32

    format  ELF
    public _lcmArray
	
section '.text' executable align 16

_lcmArray:	; Requires armv7ve
	cmp r1, #1
	ldr r2, [r0]
	ble .return
	
	str lr, [sp, #-4]
	add lr, r0, r1, lsl #2
	add r0, r0, #4
	
.loop:
	ldr r1, [r0], #4
	cmp r2, #0
	mul ip, r2, r1
	bne .startGcdLoop
	b .check
	
	
.gcdLoop:
	mov r2, r3
	
.startGcdLoop:
	sdiv r3, r1, r2
	mls r3, r2, r3, r1
	mov r1, r2
	
	cmp r3, #0
	bne .gcdLoop
	
	cmp r0, lr
	sdiv r2, ip, r2
	bne .loop
	
.return2:
	mov r0, r2
	ldr pc, [sp], #4
	
.check:
	cmp r0, lr
	mov r2, r1
	sdiv r2, ip, r2

	bne .loop
	b .return2
	
.return:
	mov r0, r2
	bx lr 