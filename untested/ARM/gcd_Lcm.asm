
    code32

    format  ELF
    public _gcd
    public _lcm
    public _gcd64
    public _lcm64
	
section '.text' executable align 16

_gcd:
	cmp r1, #0
	cmpne r0, #0
	beq .return0
	
	cmp r1, r0
	beq .returnR1
	
	subge r1, r1, r0
	sublt r0, r0, r1
	b _gcd
	
.return0:
	mov r0, #0
	bx lr
	
.returnR1:
	mov r0, r1
	bx lr
	
	
	
	
	
	
_lcm:	; requires armv7ve
	push {r4, lr}	
	mul r4, r0, r1
	bl _gcd
	
	sdiv r0, r4, r0
	pop {r4, pc}
	
	
	
	
	
	
_gcd64:
	push {r4, lr}
	
	orr lr, r0, r1
	orr ip, r2, r3
	
.bigLoop:
	cmp ip, #0
	cmpne lr, #0
	beq .ret0
	
.loop:
	cmp r3, r1
	cmpeq r2, r0
	beq .retR2R3
	
	cmp r2, r0
	sbcs r4, r3, r1
	blt .neither
	
	subs r2, r0
	sbc r3, r1
	orr ip, r2, r3
	
	cmp ip, #0
	cmpne lr, #0
	bne .loop
	
.ret0:
	mov r0, #0
	mov r1, r0
	pop {r4, pc}
	
	
.neither:
	subs r0, r2
	sbc r1, r3
	orr lr, r0, r1
	b .bigLoop
	
.retR2R3:
	mov r0, r2
	mov r1, r3
	pop {r4, pc}
	
	
	
	
	
	
_lcm64:
	push {r4, r5, r6, r7, r8, r9, lr}
	sub sp, #28
	mov r8, r0
	mov r6, r1
	mov r4, r2
	mov r5, r3
	
	bl _gcd64
	
	lsr r1, #31
	eor r9, r1, r6, lsr #31
	and r6, r9, #255
	
	eor r2, r8, r8, asr #31
	sub r2, r8, asr #31
	asr r3, r2, #31
	
	cmp r0, #0
	rsblt r0, r0, #0
	asr r1, r0, #31
	
	cmp r0, r2
	sbcs ip, r1, r3
	bge .noLoop
	
	mov ip, #0
	mov r8, ip
	
.loop:
	subs r2, r0
	sbc r3, r1
	
	adds ip, #1
	adc r8, #0
	
	cmp r0, r2
	sbcs lr, r1, r3
	blt .loop
	
	mul lr, r8, r9
	
.doTheMul:
	lsl r2, r6, #16
	lsr r2, #16
	lsr r3, ip, #16
	
	lsl r1, ip, #16
	lsr r1, #16
	mul ip, r2, r1
	
	mul r6, r3, r2
	lsl r3, r6, #16
	
	lsr r6, #16
	adds r1, ip, r3
	adc r3, lr, r6
	
	mul r2, r4, r3
	mla r0, r1, r5, r2
	lsr r3, r1, #16
	lsr r2, r4, #16
	mla r5, r2, r3, r0
	
	lsl r3, r1, #16
	lsr r3, #16
	mul ip, r2, r3
	
	lsl r4, #16
	lsr r4, #16
	lsr r2, r1, #16
	mul r3, r4, r2
	
	lsl r2, r1, #16
	lsr r2, #16
	mul r1, r4, r2
	str r1, [sp]
	
	mov r7, #0
	adds r0, r3, ip
	adc r1, r7, #0
	
	add r5, r1, lsl #16
	str r5, [sp, #4]
	
	add r3, ip, r3
	lsl r2, r3, #16
	str r2, [sp, #16]
	
	lsr r3, #16
	str r3, [sp, #20]
	ldr r3, [sp]
	
	adds r0, r3, r2
	ldr r3, [sp, #20]
	adc r1, r5, r3
	add sp, sp, #28
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.noLoop:
	mov lr, #0
	mov ip, lr
	b .doTheMul
	
	
	
	
_lcm64ARMv3m:
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r4, r0
	mov r8, r1
	mov r9, r2
	mov r10, r3
	
	bl _gcd64
	
	eor r2, r4, r4, asr #31
	
	cmp r0, #0
	rsblt r0, #0
	
	sub r2, r4, asr #31
	asr r3, r2, #31
	asr r5, r0, #31
	
	cmp r0, r2
	mov r4, r0
	sbcs r0, r5, r3
	
	lsr r0, r1, #31
	eor r0, r8, lsr #31
	bge .ret0
	
	mov ip, #0
	mov lr, ip
	and r0, #255
	
.loop:
	subs r2, r4
	sbc r3, r5
	
	adds ip, #1
	adc lr, #0
	
	cmp r4, r2
	sbcs r6, r5, r3
	blt .loop
	
	umull r2, r3, r0, ip
	mla r3, r0, lr, r3
	mul r7, r2, r10
	umull r0, r1, r2, r9
	mla r6, r3, r9, r7
	add r1, r6, r1
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
.ret0:
	mov r0, #0
	mov r1, #0
	pop {r4, r5, r6, r7, r8, r9, r10, pc}