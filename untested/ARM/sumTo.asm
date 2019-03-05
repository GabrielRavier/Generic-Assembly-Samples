
    code32

    format  ELF
    public _sumTo
    public _sumTo64

section '.text' executable align 16
	
_sumTo:
	cmp r0, #0
	bxeq lr
	
	push {r4, r5, r6, r7, fp, lr}
	sub sp, #24
	
	sub ip, r0, #1
	sub r1, r0, #2
	lsr r3, r1, #1
	
	lsr r7, r1, #17
	lsr r6, ip, #16
	
	lsl r1, r3, #16
	lsr r1, #16
	mul r2, r1, r6
	
	lsl ip, #16
	lsr ip, #16
	mul lr, ip, r7
	
	mov ip, #0
	adds r4, lr, r2
	adc r5, ip, #0
	
	lsl r3, r5, #16
	mla r1, r6, r7, r3
	str r1, [sp, #4]
	
	add r3, r2, lr
	lsl r2, r3, #16
	str r2, [sp, #16]
	
	lsr r3, #16
	str r3, [sp, #20]
	
	ldr r3, [sp]
	adds r3, r2
	
	sub r3, #1
	add r0, r3
	
	add sp, #24
	pop {r4, r5, r6, r7, fp, pc}
	
	
	
	
_sumToARMv3m:
	cmp r0, #0
	bxeq lr
	
	sub r1, r0, #1
	sub r0, #2
	umull r2, r3, r0, r1
	lsr r0, r2, #1
	orr r0, r3, lsr #31
	add r0, r1, r0
	bx lr
	
	
	
	
	
	
_sumTo64:
	orrs r3, r0, r1
	bxeq lr
	
	push {r4, r5, r6, r7, r8, lr}
	sub sp, #24
	
	subs r2, r0, #2
	sbc r4, r1, #0
	subs r3, r0, #1
	sbc ip, r1, #0
	
	mul lr, r2, ip
	mla r5, r3, r4, lr
	lsr lr, r3, #16
	lsr ip, r2, #16
	mla r4, ip, lr, r5
	
	lsl r5, r3, #16
	lsr r5, #16
	mul r6, r5, ip
	
	lsl r2, #16
	lsr r2, #16
	mul ip, r2, lr
	
	mul r3, r2, r5
	str r3, [sp]
	
	mov r8, #0
	adds r2, ip, r6
	adc r3, r8, #0
	
	add r3, r4, r3, lsl #16
	str r3, [sp, #4]
	
	add r3, r6, ip
	lsl r2, r3, #16
	str r2, [sp, #16]
	
	lsr r3, #16
	str r3, [sp, #20]
	
	ldr r3, [sp]
	adds r3, r2
	ldr r2, [sp, #4]
	ldr ip, [sp, #20]
	adc r2, ip
	
	subs r3, #1
	sbc r2, #0
	adds r0, r3
	adc r1, r2
	
	add sp, #24
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
_sumTo64ARMv3m:
	orrs r3, r0, r1
	bxeq lr
	
	subs r2, r0, #1
	sbc r3, r1, #0
	umull r0, r1, r3, r3
	mul r3, r2
	add r1, r3, lsl #1
	bx lr
	