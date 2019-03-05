
    code32

    format  ELF
    public _mostSignificantBitIndex32
    public _mostSignificantBitIndex32Alt
	
section '.rodata' align 16

	msbiAltDat dw 2, 0xC, 0xF0, 0xFF00, 0xFFFF0000, 1, 2, 4, 8, 16

section '.text' executable align 16

_mostSignificantBitIndex32:
	cmp r0, #0
	beq .retMin1
	
	lsr r3, r0, #16
	lsl r3, #16
	cmp r3, #0
	lsrne r0, #16
	movne r2, #8
	movne r3, #0
	moveq r2, #24
	moveq r3, #16
	
	tst r0, #65280
	lsrne r0, #8
	movne r2, r3
	
	tst r0, #12
	lsrne r0, #2
	addeq r2, #2
	
	lsr r3, r0, #1
	eor r3, #1
	ands r3, #1
	mvnne r3, #0
	rsb r0, #2
	and r0, r3
	add r0, r2
	
	rsb r0, #31
	bx lr
	
	
.retMin1:
	mvn r0, #0
	bx lr
	
	
	
	
_mostSignificantBitIndex32ARMv5:
	cmp r0, #0
	clzne r0, r0
	rsbne r0, #31
	mvneq r0, #0
	bx lr
	
	
	
	
	
	
_mostSignificantBitIndex32Alt:
	push {r4, lr}
	sub sp, sp, #40
	mov lr, r0
	
	mov r4, sp
	ldr ip, [.oMsbiAltDat]
	ldmia ip!, {r0, r1, r2, r3}
	stmia r4!, {r0, r1, r2, r3}
	ldr r3, [ip], #4
	str r3, [r4]
	
	add r4, sp, #20
	ldmia ip!, {r0, r1, r2, r3}
	stmia r4!, {r0, r1, r2, r3}
	ldr r3, [ip]
	str r3, [r4]
	
	cmp lr, #0
	beq .retMin1
	
	ldr r0, [sp, #36]
	ands r0, lr, r0
	
	ldrne r0, [sp, #36]
	lsrne lr, r0
	
	ldr r3, [sp, #12]
	tst lr, r3
	
	ldrne r3, [sp, #32]
	lsrne lr, r3
	orrne r0, r3
	
	ldr r3, [sp, #8]
	tst lr, r3
	
	ldrne r3, [sp, #28]
	lsrne lr, r3
	orrne r0, r3
	
	ldr r3, [sp, #4]
	tst lr, r3
	
	ldrne r3, [sp, #24]
	lsrne lr, r3
	orrne r0, r3
	
	ldr r3, [sp]
	tst lr, r3
	
	ldrne r3, [sp, #20]
	orrne r0, r3
	
.return:
	add sp, #40
	pop {r4, pc}
	
	
.retMin1:
	mvn r0, #0
	b .return
	
.oMsbiAltDat:
	dw msbiAltDat