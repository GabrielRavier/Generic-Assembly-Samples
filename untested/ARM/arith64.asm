
    code32

    format  ELF
    public _add64
    public _sub64
    public _mul64
    public _isEqual64
    public _isGreater64
    public _divide64
    public _modulo64
    public _getVal64
    public _getOpposite64
    public _getComplement64
    public _shiftLeft64
    public _shiftRight64
    public _rol64
    public _ror64

section '.text' executable align 16

_add64:
	adds r0, r2
	adc r1, r3
	bx lr
	
	
	
	
	
	
_sub64:
	subs r0, r2
	sbc r1, r3
	bx lr
	
	
	
	
	
	
_mul64:
	push {r4, r5, r6, r7, r8, lr}
	
	mov r6, #0x10000
	sub r6, #1
	and lr, r0, r6
	and r4, r2, r6
	mul ip, r4, lr
	
	lsr r8, r0, #16
	mul r5, r8, r4
	add r5, ip, lsr #16
	
	and ip, r6
	
	add ip, r5, lsl #16
	
	lsr r7, r2, #16
	mul r4, r7, lr
	add r4, ip, lsr #16
	
	and ip, r6
	
	mul lr, r7, r8
	add lr, r5, lsr #16
	add lr, r4, lsr #16
	
	mla r5, r0, r3, lr
	
	add r0, ip, r4, lsl #16
	mla r1, r2, r1, r5
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
	
_isEqual64:
	cmp r1, r3
	cmpeq r0, r2
	
	moveq r0, #1
	movne r0, #0
	bx lr
	
	
	
	
	
	
_isGreater64:
	cmp r2, r0
	sbcs r3, r1
	
	movlt r0, #1
	movge r0, #0
	bx lr
	
	
	
	
	
	
ctz32:
	lsl r3, r0, #16
	lsr r3, r3, #16
	cmp r3, #0
	lsreq r0, #16
	moveq r3, #24
	moveq r1, #16
	movne r3, #8
	movne r1, #0
	
	tst r0, #255
	lsreq r0, #8
	moveq r1, r3
	
	tst r0, #15
	lsreq r0, #4
	addeq r1, #4
	
	tst r0, #3
	lsreq r0, #2
	addeq r1, #2
	
	lsr r2, r0, #1
	and r2, #1
	rsb r2, #2
	mvn r3, r0
	ands r3, #1
	mvnne r3, #0
	and r3, r2
	
	add r0, r3, r1
	bx lr
	
	
	
	
	
	
clz32:
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
	lsrne r0, #4
	addeq r2, #4
	
	tst r0, #0xC
	lsrne r0, #2
	addeq r2, #2
	
	lsr r3, r0, #1
	eor r3, #1
	ands r3, #1
	mvnne r3, #0
	rsb r0, #2
	and r0, r3
	
	add r0, r2
	bx lr
	
	
	
	
	
	
udiv32:
	push {r4, r5, r6, r7, r8, lr}
	
	rsbs r5, r1, #1
	movcc r5, #0
	
	cmp r0, #0
	moveq r5, #1
	cmp r5, #0
	beq .nAndDNot0
	
.ret0:
	mov r0, #0
	pop {r4, r5, r6, r7, r8, pc}
	
.nAndDNot0:
	mov r6, r1
	mov r4, r0
	
	mov r0, r1
	bl clz32
	
	mov r7, r0
	mov r0, r4
	bl clz32
	sub r0, r7, r0
	
	cmp r0, #31
	bhi .ret0
	
	beq .retN
	
	add ip, r0, #1
	rsb r0, ip, #32
	lsl r1, r4, r0
	lsr r3, r4, ip
	sub lr, r6, #1
	mov r0, r5
	
.loop:
	lsr r2, r1, #31
	orr r3, r2, r3, lsl #1
	orr r1, r0, r1, lsl #1
	
	sub r2, lr, r3
	asr r2, #31
	
	and r0, r2, #1
	
	and r2, r6
	sub r3, r2
	
	subs ip, #1
	bne .loop
	
	orr r0, r1, lsl #1
	pop {r4, r5, r6, r7, r8, pc}

.retN:
	mov r0, r4
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
	
_divide64:	; requires ARMv7ve
	push {r4, r5, r6, r7, r8, r9, lr}
	asr lr, r1, #31
	asr ip, r3, #31
	
	eor r0, lr
	subs r6, r0, lr
	eor r1, lr
	eor r2, ip
	sbc r1, lr
	
	eor r3, ip
	subs r2, ip
	
	eor r0, lr, ip
	
	sbc r4, r3, ip
	
	cmp r1, #0
	mov r5, r1
	mov lr, r0
	bne .nHighNot0
	
	cmp r4, #0
	movne r3, r1
	udiveq r3, r6, r2
.divRet:
	eor r3, r0
	eor r1, lr, r5
	subs r0, r3, r0
	sbc r1, lr
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.nHighNot0:
	cmp r2, #0
	mov r7, r2
	bne .dLowNot0
	
	cmp r4, #0
	beq .undef
	
	cmp r6, #0
	beq .nLow0
	
	sub r5, r4, #1
	ands r5, r4
	beq .dHighNotPowOf2
	
	clz r8, r4
	clz r3, r1
	sub r8, r3
	
	cmp r8, #30
	bhi .divRet0
	
	add r8, #1
	rsb r3, r8, #32
	lsr ip, r6, r8
	lsl r5, r6, r3
	orr ip, r1, lsl r3
	lsr r9, r1, r8
	b .startLoopOne0
	
.dLowNot0:
	cmp r4, #0
	mov ip, r1
	beq .dHighNot0
	
	clz r8, r4
	clz r3, r1
	sub r8, r3
	
	cmp r8, #31
	bhi .divRet0
	
	add r8, #1
	cmp r8, #32
	moveq r9, #0
	moveq r5, r6
	moveq r7, r9
	beq .startLoopOne0
	
.srBelow31:
	rsb ip, r8, #32
	lsr r3, r6, r8
	lsl r5, r6, ip
	lsr r9, r1, r8
	orr ip, r3, r1, lsl ip
	
.startLoopBoth0:
	mov r7, #0
	
.startLoopOne0:
	mov r3, #0
	
.loop:
	lsr r6, r5, #31
	lsr r1, ip, #31
	orr ip, r6, ip, lsl #1
	orr r9, r1, r9, lsl #1
	
	lsr r1, r7, #31
	orr r7, r3, r7, lsl #1
	
	mvn r3, ip
	adds r3, r2
	mvn r3, r9
	adc r3, r4
	
	orr r5, r1, r5, lsl #1
	
	asr r3, #31
	and r1, r3, r2
	and r6, r3, r4
	subs ip, r1
	and r3, r3, #1
	sbc r9, r6
	
	subs r8, #1
	bne .loop

	adds r7, r7
	adc r5, r5
	orr r3, r7, r3
	b .divRet
	
.dHighNot0:
	sub r7, r2, #1
	tst r7, r2
	bne .dLowNotPowOf2
	
	cmp r2, #1
	mov r3, r6
	beq .divRet
	
	rbit r5, r2
	clz r5, r5
	
	lsr r3, r6, r5
	rsb r2, r5, #32
	orr r3, r1, lsl r2
	
	lsr r5, r1, r5
	b .divRet
	
.undef:
	dw 0xE7F0DEF0	; make invalid instruction exception
	
.divRet0:
	mov r3, #0
	mov r5, r3
	b .divRet
	
.dLowNotPowOf2:
	clz r5, r1
	clz r3, r2
	sub r3, r5
	mov r9, r4
	add r8, r3, #33
	
	mov r5, r6
	cmp r8, #32
	beq .startLoopBoth0
	
	cmp r8, #31
	bls .srBelow31
	
	add ip, r3, #1
	rsb r7, r8, #64
	
	lsr r5, r6, ip
	lsr ip, r1, ip
	orr r5, r1, lsl r7
	lsl r7, r6, r7
	b .startLoopOne0

.nLow0:
	udiv r3, r1, r4
	mov r5, r6
	b .divRet
	
.dHighNotPowOf2:
	rbit r3, r4
	clz r3, r3
	lsr r3, r1, r3
	b .divRet
	
	
	
	
	
_modulo64:	; requires ARMv7ve
	asr ip, r1, #31
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	asr lr, r3, #31
	
	eor fp, r0, ip
	eor r6, r2, lr
	subs fp, ip
	eor r10, r1, ip
	sbc r10, ip
	
	eor r7, r3, lr
	subs r6, lr
	
	sub sp, #12
	
	sbc r7, lr
	
	cmp r10, #0
	eor r4, ip, lr
	mov lr, r10
	str r4, [sp]
	str r4, [sp, #4]
	bne .nHighNot0
	
	cmp r7, #0
	movne ip, r10
	udiveq ip, fp, r6
	
.divRet:
	ldr r7, [sp]
	ldr r4, [sp, #4]
	eor ip, r7
	subs ip, r7
	eor lr, r4
	sbc lr, r4
	
	mul r3, ip, r3
	mla lr, r2, lr, r3
	umull r2, r3, ip, r2
	
	subs r0, r2
	add r3, lr, r3
	sbc r1, r3
	add sp, #12
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
.nHighNot0:
	cmp r6, #0
	mov r8, r6
	bne .dLowNot0
	
	cmp r7, #0
	beq .undef
	
	cmp fp, #0
	beq .nLowNot0
	
	sub lr, r7, #1
	ands lr, r7
	beq .dHighNotPowOf2
	
	clz r9, r7
	clz ip, r10
	sub r9, ip
	
	cmp r9, #30
	bhi .divRet0
	
	add r9, #1
	rsb ip, r9, #32
	lsr r4, fp, r9
	lsl lr, fp, ip
	orr r4, r10, lsl ip
	lsr r5, r10, r9
	b .startLoopOne0
	
.dLowNot0:
	cmp r7, #0
	mov r4, r10
	beq .dHighNot0
	
	clz r9, r7
	clz ip, r10
	sub r9, ip
	
	cmp r9, #31
	bhi .divRet0
	
	add r9, #1
	cmp r9, #32
	moveq r5, #0
	moveq lr, fp
	moveq r8, r5
	beq .startLoopOne0
	
.srBelow31:
	rsb r4, r9, #32
	lsr ip, fp, r9
	lsl lr, fp, r4
	lsr r5, r10, r9
	orr r4, ip, r10, lsl r4
	
.startLoopBoth0:
	mov r8, #0
	
.startLoopOne0:
	mov ip, #0
	
.loop:
	lsr fp, lr, #31
	lsr r10, r4, #31
	orr r4, fp, r4, lsl #1
	orr r5, r10, r5, lsl #1
	
	lsr r10, r8, #31
	orr r8, ip, r8, lsl #1
	
	mvn ip, r4
	adds ip, r6
	mvn ip, r5
	adc ip, r7
	
	orr lr, r10, lr, lsl #1
	
	asr ip, #31
	and fp, ip, r6
	and r10, ip, r7
	subs r4, fp
	and ip, #1
	sbc r5, r10
	
	subs r9, #1
	bne .loop
	
	adds r8, r8
	adc lr, lr
	orr ip, r8, ip
	b .divRet
	
.dHighNot0:
	sub r8, r6, #1
	tst r8, r6
	bne .dLowNotPowOf2
	
	cmp r6, #1
	mov ip, fp
	beq .divRet
	
	rbit lr, r6
	clz lr, lr
	
	lsr ip, fp, lr
	rsb fp, lr, #32
	orr ip, r10, lsl fp
	
	lsr lr, r10, lr
	b .divRet
	
.undef:
	dw 0xE7F0DEF0	; make invalid instruction exception
	
.divRet0:
	mov ip, #0
	mov lr, ip
	b .divRet
	
.dLowNotPowOf2:
	clz lr, r10
	clz ip, r6
	sub ip, lr
	mov r5, r7
	add r9, ip, #33
	
	mov lr, fp
	cmp r9, #32
	beq .startLoopBoth0
	
	cmp r9, #31
	bls .srBelow31
	
	add r4, ip, #1
	rsb r8, r9, #64
	
	lsr lr, fp, r4
	lsr r4, r10, r4
	orr lr, r10, lsl r8
	lsl r8, fp, r8
	b .startLoopOne0
	
.nLowNot0:
	udiv ip, r10, r7
	mov lr, fp
	b .divRet
	
.dHighNotPowOf2:
	rbit ip, r7
	clz ip, ip
	lsr ip, r10, ip
	b .divRet
	
	
	
	
	
_getVal64:
	bx lr
	
	
	
	
	
_getOpposite64:
	rsbs r0, #0
	rsc r1, #0
	bx lr
	
	
	
	
	
_getComplement64:
	mvn r0, r0
	mvn r1, r1
	bx lr
	
	
	
	
	
_shiftLeft64:
	mov r3, r0
	
	sub r0, r2, #32
	rsb ip, r2, #32
	lsl r1, r2
	orr r1, r3, lsl r0
	
	lsl r0, r3, r2
	orr r1, r3, lsr ip
	bx lr
	
	
	
	
	
_shiftRight64:
	rsb r3, r2, #32
	subs ip, r2, #32
	lsr r0, r2
	orr r0, r1, lsl r3
	orrpl r0, r1, asr ip
	
	asr r1, r2
	bx lr
	
	
	
	
	
_rol64:
	push {r4, r5, lr}
	
	and r2, #0x3F
	
	sub lr, r2, #32
	rsb r3, r2, #32
	lsl ip, r1, r2
	orr ip, r0, lsl lr
	orr ip, r0, lsr r3
	rsb r3, r2, #0
	and r3, #63
	rsb r5, r3, #32
	sub r4, r3, #32
	lsr lr, r0, r3
	orr lr, r1, lsl r5
	orr lr, r1, lsr r4
	
	orr r0, lr, r0, lsl r2
	orr r1, ip, r1, lsr r3
	pop {r4, r5, pc}
	
	
	
	
	
_ror64:
	push {r4, r5, lr}
	
	and r2, #63
	
	rsb ip, r2, #32
	sub r3, r2, #32
	lsr lr, r0, r2
	orr lr, r1, lsl ip
	orr lr, r1, lsr r3
	rsb r3, r2, #0
	and r3, #63
	sub r5, r3, #32
	rsb r4, r3, #32
	lsl ip, r1, r3
	orr ip, r0, lsl r5
	orr ip, r0, lsr r4
	
	orr r0, lr, r0, lsl r3
	orr r1, ip, r1, lsr r2
	pop {r4, r5, pc}