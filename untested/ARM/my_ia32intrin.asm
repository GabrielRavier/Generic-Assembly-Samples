
    code32

    format  ELF
    public _my_bsfd
    public _my_bsrd
    public _my_bswapd
    public _my_crc32b
    public _my_crc32w
    public _my_crc32d
    public _my_popcntd
    public _my_rolb
    public _my_rolw
    public _my_rold
    public _my_rorb
    public _my_rorw
    public _my_rord
    public _my_bsfq
    public _my_bsrq
    public _my_bswapq
    public _my_crc32q
    public _my_popcntq
    public _my_rolq
    public _my_rorq
	
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
	
	
	
	
	

crc32Polymonial:
	dw 0x1EDC6F41, 1
	
_my_crc32b:
	push {r4, r5, r6, lr}
	mov r5, r10
	
	bl BitReflect32
	mov r4, r0
	
	mov r0, r5
	bl BitReflect8
	and r0, #0xFF
	
	lsl r2, r4, #8
	eor r3, r0, r4, lsr #24
	adr r1, crc32Polymonial
	ldmia r1, {r0-r1}
	bl mod2_64bit
	
	pop {r4, r5, r6, lr}
	
	b BitReflect32
	
	
	
	
	
_my_crc32w:
	push {r4, r5, r6, lr}
	mov r5, r1
	
	bl BitReflect32
	mov r4, r0
	
	mov r0, r5
	bl BitReflect16
	
	lsl r2, r4, #16
	eor r3, r0, r4, lsr #16
	adr r1, crc32Polymonial
	ldmia r1, {r0-r1}
	bl mod2_64bit
	
	pop {r4, r5, r6, lr}
	
	b BitReflect32
	
	
	
	
	
_my_crc32d:
	push {r4, r5, r6, lr}
	mov r5, r1
	
	bl BitReflect32
	mov r4, r0
	
	mov r0, r5
	bl BitReflect32
	
	mov r2, #0
	eor r3, r0, r4
	adr r1, crc32Polymonial
	ldmia r1, {r0-r1}
	bl mod2_64bit
	
	pop {r4, r5, r6, lr}
	
	b BitReflect32
	
	
	
	
	
_my_popcntd:
	mov r3, #0x5500
	add r3, #0x55
	orr r3, r3, lsl #16
	and r3, r0, lsr #1
	sub r3, r0, r3
	
	mov r2, #0x3300
	add r2, #0x33
	orr r2, r2, lsl #16
	and r0, r2, r3, lsr #2
	and r3, r2
	add r0, r3
	
	add r0, r0, lsr #4
	bic r0, #-0x10000000
	bic r0, #0xF00000
	bic r0, #0xF000
	bic r0, #0xF0
	add r0, r0, lsr #16
	add r0, r0, lsr #8
	and r0, #0x3F
	bx lr
	
	
	
	
	
_my_popcntdARMv6t2:
	movw r3, #0x5555
	movw r2, #0x3333
	movw r1, #0xF0F
	movt r3, 0x5555
	and r3, r0, lsr #1
	
	movt r2, 0x3333
	sub r0, r3
	
	and r3, r2, r0, lsr #2
	and r0, r2
	add r0, r3, r0
	
	movt r1, 0xF0F
	add r0, r0, lsr #4
	and r0, r1
	
	add r0, r0, lsr #16
	add r0, r0, lsr #8
	and r0, #0x3F
	bx lr
	
	
	
	
	
_my_rolb:
	and r1, #7
	rsb r3, r1, #0
	and r3, #7
	lsr r3, r0, r3
	orr r0, r3, r0, lsl r1
	
	and r0, #0xFF
	bx lr
	
	
	
	
	
_my_rolw:
	and r1, #0xF
	rsb r3, r1, #0
	and r3, #0xF
	lsr r3, r0, r3
	orr r0, r3, r0, lsl r1
	
	lsl r0, #16
	lsr r0, #16
	bx lr
	
	
	
	
	
_my_rold:
	rsb r1, #32
	ror r0, r1
	bx lr
	
	
	
	
	
_my_rorb:
	and r1, #7
	rsb r3, r1, #0
	and r3, #7
	lsl r3, r0, r3
	orr r0, r3, r0, lsr r1
	
	and r0, #0xFF
	bx lr
	
	
	
	
	
_my_rorw:
	and r1, #0xF
	rsb r3, r1, #0
	and r3, #0xF
	lsl r3, r0, r3
	orr r0, r3, r0, lsr r1
	
	lsl r0, #16
	lsr r0, #16
	bx lr
	
	
	
	
	
_my_rord:
	ror r0, r1
	bx lr
	
	
	
	
	
_my_bsfq:
	rsbs r3, r0, #1
	movcc r3, #0
	rsb r2, r3, #0
	
	sub r3, #1
	and r3, r0
	and r1, r2
	orr r1, r3, r1
	
	lsl r3, r1, #16
	lsr r3, #16
	cmp r3, #0
	lsreq r1, #16
	moveq r0, #24
	moveq r3, #16
	movne r0, #8
	movne r3, #0
	
	tst r1, #0xFF
	lsreq r1, #8
	moveq r3, r0
	
	tst r1, #0xF
	lsreq r1, #4
	addeq r3, #4
	
	tst r1, #3
	lsreq r1, #2
	addeq r3, #2
	
	lsr r0, r1, #1
	and r0, #1
	rsb r0, #2
	mvn r1, r1
	ands r1, #1
	mvnne r1, #0
	and r1, r0
	add r1, r3
	
	and r0, r2, #0x20
	add r0, r1, r0
	bx lr
	
	
	
	
	
_my_bsfqARMv5:
	clz r3, r0
	lsr r3, #5
	rsb r2, r3, #0
	
	sub r3, #1
	and r3, r0
	and r1, r2
	orr r1, r3, r1
	
	rsb r0, r1, #0
	and r1, r0
	clz r1, r1
	
	and r0, r2, #32
	rsb r1, #31
	add r0, r1
	bx lr
	
	
	
	
	
_my_bsrq:
	rsbs r3, r1, #1
	movcc r3, #0
	rsb r2, r3, #0
	
	sub r3, #1
	and r1, r3
	and r0, r2
	orr r1, r0
	
	lsr r3, r1, #16
	lsl r3, #16
	
	cmp r3, #0
	lsrne r1, #16
	moveq r3, #24
	moveq r0, #16
	movne r3, #8
	movne r0, #0
	
	tst r1, #0xFF00
	lsrne r1, #8
	movne r3, r0
	
	tst r1, #0xF0
	lsrne r1, #4
	addeq r4, #4
	
	tst r1, #0xC
	lsrne r1, #2
	addeq r3, #2
	
	lsr r0, r1, #1
	eor r0, #1
	ands r0, #1
	mvnne r0, #0
	rsb r1, #2
	and r1, r0
	add r1, r3
	
	and r0, r2, #0x20
	add r0, r1, r0
	bx lr
	
	
	
	
	
_my_bsrqARMv5:
	clz r3, r1
	lsr r3, #5
	rsb r2, r3, #0
	
	sub r3, #1
	and r0, r2
	and r3, r1
	orr r3, r0
	
	clz r3, r3
	
	and r0, r2, #32
	add r0, r3
	bx lr
	
	
	
	
	
_my_bswapq:
	mov ip, r0
	
	eor r3, r0, r0, ror #16
	lsr r3, #8
	bic r3, #0xFF00
	eor r0, r1, r1, ror #16
	lsr r0, #8
	bic r0, #0xFF00
	
	eor r0, r1, ror #8
	eor r1, r3, ip, ror #8
	bx lr
	
	
	
	
	
_my_bswapqARMv6:
	rev r3, r0
	rev r0, r1
	mov r1, r3
	bx lr
	
	
	
	
	
	
_my_crc32q:
	push {r4, r5, r6, r7, r8, lr}
	mov r4, r2
	mov r8, r3
	
	bl BitReflect32
	mov r5, r0
	
	mov r0, r4
	bl BitReflect32
	mov r4, #0
	
	adr r7, crc32Polymonial
	ldmia r7, {r6-r7}
	mov r2, r4
	eor r3, r0, r5
	mov r0, r6
	mov r1, r7
	bl mod2_64bit
	mov r5, r0
	
	mov r0, r8
	bl BitReflect32
	
	mov r2, r4
	eor r3, r0, r5
	mov r0, r6
	mov r1, r7
	bl mod2_64bit
	
	bl BitReflect32
	
	mov r1, r4
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
_my_popcntq:
	push {r4, lr}
	
	lsr ip, r0, #1
	orr ip, r1, lsl #31
	mov r3, #0x5500
	add r3, #0x55
	orr r3, r3, lsl #16
	and r2, ip, r3
	and lr, r3, r1, lsr #1
	subs r0, r2
	sbc r1, lr
	
	lsr lr, r0, #2
	orr lr, r1, lsl #30
	mov ip, #0x3300
	add ip, #0x33
	orr ip, ip, lsl #16
	and r2, lr, ip
	and r3, ip, r1, lsr #2
	and lr, r0, ip
	and r4, r1, ip
	adds r1, r2, lr
	adc r0, r3, r4
	
	lsr r2, r1, #4
	orr r2, r0, lsl #28
	lsr r3, r0, #4
	adds r2, r1
	adc r3, r0
	mov r0, #0xF00
	add r0, #0xF
	orr r0, r0, lsl #16
	and r2, r0
	and r0, r3
	
	add r0, r2
	add r0, r0, lsr #16
	add r0, r0, lsr #8
	and r0, #0x7F
	asr r1, r0, #31
	pop {r4, pc}
	
	
	
	
	
_my_rolq:	
	push {r4, r5, lr}
	
	sub lr, r2, #0x20
	rsb r3, r2, #0x20
	lsl ip, r1, r2
	orr ip, r0, lsl lr
	orr ip, r0, lsr r3
	rsb r3, r2, #0
	and r3, #0x3F
	rsb r5, r3, #0x20
	sub r4, r3, #0x20
	lsr lr, r0, r3
	orr lr, r1, lsl r5
	orr lr, r1, lsr r4
	
	orr r0, lr, r0, lsl r2
	orr r1, ip, r1, lsr r3
	pop {r4, r5, pc}
	
	
	
	
	
_my_rorq:
	push {r4, r5, lr}
	
	rsb ip, r2, #0x20
	sub r3, r2, #0x20
	lsr lr, r0, r2
	orr lr, r1, lsl ip
	orr lr, r1, lsr r3
	rsb r3, r2, #0
	and r3, r3, #0x3F
	sub r5, r3, #0x20
	rsb r4, r3, #0x20
	lsl ip, r1, r3
	orr ip, r0, lsl r5
	orr ip, r0, lsr r4
	
	orr r0, lr, r0, lsl r3
	orr r1, ip, r1, lsr r2
	pop {r4, r5, pc}