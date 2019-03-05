
    code32

    format  ELF
    public _MulDiv
	
section '.text' executable align 16

_MulDiv:	; Requires ARMv3m
	push {r4, r5, lr}
	
	smull r3, r4, r0, r1
	mov r0, r3
	
	lsr r3, r2, #31
	cmp r3, r4, lsr #31
	
	mvnne ip, #0
	moveq ip, #1
	
	cmp r0, #0
	rsblt r0, r0, #0
	
	cmp r2, #0
	rsblt r2, r2, #0
	
	asr r1, r0, #31
	asr r3, r2, #31
	
	cmp r0, r2
	sbcs lr, r1, r3
	blt .return0
	
	mov r4, #0
	mov r5, #0
	
.loop:
	subs r0, r0, r2
	sbc r1, r1, r3
	
	adds r4, r4, #1
	adc r5, r5, #0
	
	cmp r0, r2
	sbcs lr, r1, r3
	bge .loop
	
	umull r0, r1, r4, ip
	pop {r4, r5, pc}
	
.return0:
	mov r0, #0
	pop {r4, r5, pc}