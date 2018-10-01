
    code32

    format  ELF
    public _nextPowerOf2
    public _nextPowerOf264
	
section '.text' executable align 16

_nextPowerOf2:
	cmp r0, #0
	beq .return1
	
	sub r3, r0, #1
	tst r3, r0
	moveq pc, lr
	
	mov r2, #0
	
.loop:
	add r1, r2, #1
	lsrs r0, r0, #1
	and r2, r1, #0xFF
	bne .loop
	
	mov r0, #1
	lsl r0, r0, r2
	mov pc, lr
	
.return1:
	mov r0, #1
	mov pc, lr
	
	
	
	
	
_nextPowerOf264:
	orrs r3, r0, r1
	beq .return1
	
	str fp, [sp, #-4]
	
	subs fp, r0, #1
	sbc ip, r1, #0
	and r2, fp, r0
	and r3, fp, r1
	orrs r3, r2, r3
	beq .return
	
	mov r2, #0
	
.loop:
	movs r1, r1, lsr #1
	mov r0, r0, rrx
	
	add r3, r2, #1
	
	orrs r2, r0, r1
	
	and r2, r3, #0xFF
	
	bne .loop
	
	mov r0, #1
	lsl r0, r0, r2
	asr r1, r0, #31

.return:
	ldr fp, [sp], #4
	mov pc, lr
	
.return1:
	mov r0, #1
	mov r1, #0
	mov pc, lr
	