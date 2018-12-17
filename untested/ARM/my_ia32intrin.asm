
    code32

    format  ELF
    public _my_bsfd
    public _my_bsrd
    public _my_bswapd
	
section '.text' executable align 16

_my_bsfd:
	lsr r3, r0, #16
	lsl r3, #16
	cmp r3, #0
	lsreq r0, #16
	moveq r3, #24
	moveq r2, #16
	movne r3, #8
	movne r2, #0
	
	tst r0, #0xFF
	lsreq r0, #8
	moveq r2, r3
	
	tst r0, #0xF
	lsreq r0, #4
	addeq r2, #4
	
	tst r0, #3
	lsreq r0, #2
	addeq r2, #2
	
	lsr r3, r0, #1
	and r3, #1
	rsb r3, #2
	mvn r0, r0
	ands r0, #1
	mvnne r0, #0
	and r0, r3
	add r0, r2
	
	and r0, #0xFF
	bx lr
	
	
	
	
	
_my_bsfdARMv5:
	rsb r3, r0, #0
	and r0, r3
	clz r0, r0
	rsb r0, #31
	
	and r0, #0xFF
	bx lr
	
	
	
	
	
_my_bsfdARMv6t2:
	rbit r0, r0
	clz r0, r0
	bx lr
	
	
	
	
	
_my_bsrd:
	lsr r3, r0, #16
	lsl r3, #16
	
	cmp r3, #0
	lsrne r0, #16
	movne r2, #8
	movne r3, #0
	moveq r2, #24
	moveq r3, #16
	
	tst r0, #0xFF00
	lsrne r0, #8
	movne r2, r3
	
	tst r0, #0xF0
	lsrne r0, #2
	addeq r2, #2
	
	lsr r3, r0, #1
	eor r3, #1
	ands r3, #1
	mvnne r3, #0
	rsb r0, #2
	and r0, r3
	add r0, r2
	
	and r0, #0xFF
	bx lr
	
	
	
	
	
_my_bsrdARMv5:
	clz r0, r0
	bx lr
	
	
	
	
	
_my_bswapd:
	eor r3, r0, r0, ror #16
	lsr r3, #8
	bic r3, #0xFF00
	
	eor r0, r3, r0, ror #8
	bx lr
	
	
	
	
	
_my_bswapdARMv6:
	rev r0, r0
	bx lr
	
	
	
	
	
BitReflect8:
	lsl r3, r0, #7
	
	orr r3, r0, lsr #7
	asr r2, r0, #5
	and r2, #2
	
	orr r3, r2
	asr r2, r0, #3
	and r2, #4
	
	orr r3, r2
	asr r2, r0, #1
	and r2, #8
	
	orr r3, r2
	lsl r2, r0, #1
	and r2, #16
	
	orr r3, r2
	lsl r2, r0, #3
	and r2, #32
	
	orr r3, r2
	lsl r0, #5
	and r0, #64
	orr r0, r3, r0
	
	and r0, #0xFF
	bx lr
	
	
	
	
	
BitReflect16:
	push {r4, r5, r6, lr}
	mov r5, r0
	
	and r0, #255
	bl BitReflect8
	mov r4, r0
	lsr r0, r5, #8
	bl BitReflect8
	orr r0, r4, lsl #8
	
	lsl r0, #16
	lsr r0, #16
	pop {r4, r5, r6, pc}
	
	
	
	
	
BitReflect32:
	push {r4, r5, r6, lr}
	mov r4, r0
	
	lsl r0, #16
	lsr r0, #16
	bl BitReflect16
	mov r5, r0
	lsr r0, r4, #16
	bl BitReflect16
	
	orr r0, r5, lsl #16
	pop {r4, r5, r6, pc}
	
	
	
	
	
mod2_64bit:
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r7, r0
	
	mov r0, r3
	mov ip, #0
	
	mov r6, #31
	mov r8, ip
	
.loop:
	adds r0, r0
	adc ip, ip
	rsb r10, r6, #32
	sub r9, r6, #32
	lsr ip, r2, r6
	orr ip, r3, lsl r10
	orr ip, r3, lsr r9
	and ip, #1
	orr r0, ip, r0
	mov ip, lr
	
	mov r4, r8
	and r5, lr, #1
	orrs lr, r4, r5
	
	eorne r9, r0, r7
	eorne lr, ip, r10
	movne r0, r9
	movne ip, lr
	
	subs r6, #1
	popcc {r4, r5, r6, r7, r8, r9, r10, pc}
	b .loop
	