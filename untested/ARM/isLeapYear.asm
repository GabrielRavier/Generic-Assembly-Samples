
    code32

    format  ELF
    public _isLeapYear

section '.text' executable align 16

_isLeapYear:	; requires ARMv3m
	push {r4, r5}
	
	ldr r3, [.dat1]
	umull r4, r5, r0, r3
	lsr r1, r5, #7
	add r2, r1, r1, lsl #2
	add r4, r2, r2, lsl #2
	cmp r0, r4, lsl #4
	moveq r0, #1
	beq .return
	
	lsr r5, r5, #5
	add ip, r5, r5, lsl #2
	add r3, ip, ip, lsl #2
	subs r1, r0, r3, lsl #2
	moveq r0, r1
	beq .return
	
	tst r0, #3
	moveq r0, #1
	movne r0, #0
	
.return:
	pop {r4, r5}
	bx lr
	
.dat1:
	dd 0x51EB851F