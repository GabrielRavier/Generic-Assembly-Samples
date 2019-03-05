
    code32

    format  ELF
    public _isPowerOf4
    public _isPowerOf464
	
section '.text' executable align 16

_isPowerOf4:
	cmp r0, #0
	bne .startLoop
	
	bx lr
	
	
.loop:
	add r3, r0, #3
	cmp r0, #0
	movlt r0, r3
	asr r0, r0, #2
	
.startLoop:
	cmp r0, #1
	bxeq lr
	
	tst r0, #3
	beq .loop
	
	mov r0, #0
	bx lr
	
	
	
	
	
	
_isPowerOf464:
	orrs r3, r0, r1
	beq .return0
	
	cmp r1, #0
	cmpeq r0, #1
	beq .return1
	
	and r2, r0, #3
	mov r3, #0
	orrs r3, r2, r3
	bne .return0
	
	str fp, [sp, #-4]
	b .startLoop
	
	
.loop:
	and r2, r0, #3
	mov r3, #0
	orrs r3, r2, r3
	bne .return02
	
.startLoop:
	asr fp, r1, #31
	and ip, fp, #3
	mov r3, #0
	adds r0, ip, r0
	adc r1, r3, r1
	lsr fp, r0, #2
	orr r0, fp, r1, lsl #30
	asr r1, r1, #2
	
	cmp r1, #0
	cmpeq r0, #1
	bne .loop
	
	mov r0, #1
	
	ldr fp, [sp], #4
	bx lr
	
.return0:
	mov r0, #0
	bx lr
	
.return02:
	mov r0, #0
	ldr fp, [sp], #4
	bx lr
	
.return1:
	mov r0, #1
	bx lr
	