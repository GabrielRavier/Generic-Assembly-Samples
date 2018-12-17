
    code32

    format  ELF
    public _wav_parse
    public _wav_write
	
section '.text' executable align 16

_wav_parse:
	ldrb r3, [r1]
	ldrb r2, [r1, #1]
	orr r3, r2, lsl #8
	ldrb r2, [r1, #2]
	orr r3, r2, lsl #16
	ldrb r2, [r1, #3]
	orr r3, r2, lsl #24
	
	eor r2, r3, r3, ror #16
	lsr r2, #8
	bic r2, #0xFF00
	eor r3, r2, r3, ror #8
	
	ldr r2, [.aRiff]
	cmp r3, r2
	bne .retMin1
	
	ldrb r3, [r1, #8]
	ldrb r2, [r1, #9]
	orr r3, r2, lsl #8
	ldrb r2, [r1, #10]
	orr r3, r2, lsl #16
	ldrb r2, [r1, #11]
	orr r3, r2, lsl #24
	
	eor r2, r3, r3, ror #16
	lsr r2, #8
	bic r2, #0xFF00
	eor r3, r2, r3, ror #8
	
	ldr r2, [.aWave]
	cmp r3, r2
	bne .retMin2
	
	push {r4, r5, r6, lr}
	add r1, #12
	ldr lr, [.aFmt]
	ldr r4, [.aData]
	b .startLoop
	
	
.loop:
	add r3, #8
	add r1, r3
	
.startLoop:
	ldrb r3, [r1]
	ldrb r2, [r1, #1]
	orr r3, r2, lsl #8
	ldrb r2, [r1, #2]
	orr r3, r2, lsl #16
	ldrb r2, [r1, #3]
	orr r3, r2, lsl #24
	
	eor r2, r3, r3, ror #16
	lsr r2, #8
	bic r2, #0xFF00
	eor r2, r3, ror #8
	
	ldrb r3, [r1, #4]
	ldrb r5, [r1, #5]
	orr r3, r5, lsl #8
	ldrb r5, [r1, #6]
	orr r3, r5, lsl #16
	ldrb r5, [r1, #7]
	orr r3, r5, lsl #24
	
	cmp r2, lr
	addeq ip, r1, #8
	beq .loop
	
	cmp r2, r4
	bne .loop
	
	add r1, #8
	str r1, [r0]
	
	mov r4, #0
	str r3, [r0, #8]
	str r4, [r0, #12]
	
	ldrb r2, [ip, #4]
	ldrb r1, [ip, #5]
	orr r2, r1, lsl #8
	ldrb r1, [ip, #6]
	orr r2, r1, lsl #16
	ldrb lr, [r1, #7]
	orrs lr, r2, lr, lsl #24
	
	moveq r1, #0
	moveq r2, r1
	bne .origNot0
	
.afterConv:
	mov r4, r1
	mov r5, r2
	str r4, [r0, #16]
	str r5, [r0, #20]
	
	ldrb r2, [ip]
	ldrb r1, [ip, #1]
	orr r2, r1, lsl #8
	str r2, [r0, #36]
	
	ldrb r2, [ip, #2]
	ldrb r1, [ip, #3]
	orr r2, r1, lsl #8
	lsl r2, #16
	lsr r4, r2, #16
	str r4, [r0, #32]
	
	cmp r3, #0
	cmpne r4, #0
	bne .not0
	
.frameCnt0:
	mov r2, #0
	mov r3, r2
	
.return:
	str r2, [r0, #24]
	str r3, [r0, #28]
	mov r0, #0
	pop {r4, r5, r6, pc}
	
	
.origNot0:
	lsr r2, lr, #16
	lsl r2, #16
	cmp r2, r4
	lsrne r1, lr, #16
	movne r5, #8
	moveq r1, lr
	moveq r5, #24
	moveq r4, #16
	
	tst r1, #0xFF00
	lsrne r1, #8
	movne r5, r4
	
	tst r1, #0xC
	lsrne r1, #2
	addeq r5, #2
	
	lsr r2, r1, #1
	eor r2, #1
	ands r2, #1
	mvnne r2, #0
	rsb r1, #2
	and r2, r1
	add r2, r5
	
	add r1, r2, #21
	
	sub r4, r2, #11
	rsb r5, r1, #32
	lsl r4, lr, r4
	orr r4, lr, lsr r5
	lsl r5, lr, r1
	eor r6, r4, #0x100000
	
	rsb r2, #0x410
	add r2, #14
	lsl lr, r2, #20
	mov r1, #0
	
	adds r1, r5
	adc r2, lr, r6
	b .afterConv
	
	
.not0:
	tst r4, #0xFF00
	lsrne r2, #24
	movne lr, #20
	movne r1, #16
	moveq r2, r4
	moveq lr, #28
	moveq r1, #24
	
	tst r2, #0xF0
	lsrne r2, #4
	movne lr, r1
	
	tst r2, #0xC
	lsrne r2, #2
	addeq lr, #2
	
	lsr r1, r2, #1
	eor r1, #1
	ands r1, #1
	mvnne r1, #0
	rsb r2, #2
	and r2, r1
	add r2, lr
	
	lsr r5, r3, #16
	lsl r5, #16
	cmp r5, #0
	lsrne r1, r3, #16
	movne r6, #8
	movne lr, #0
	moveq r1, r3
	moveq r6, #24
	moveq lr, #16
	
	tst r1, #0xF0
	lsrne r1, #8
	movne r6, lr
	
	tst r1, #0xF0
	lsrne r1, #4
	addeq r6, #4
	
	tst r1, #0xC
	lsrne r1, #2
	addeq r6, #2
	
	lsr lr, r1, #1
	eor lr, #1
	ands lr, #1
	mvnne lr, #0
	rsb r1, #2
	and r1, lr
	add r1, r6
	
	sub r1, r2, r1
	
	cmp r1, #31
	bhi .frameCnt0
	
	ldrb r2, [ip, #14]
	ldrb lr, [ip, #15]
	orr r2, lr, lsl #8
	lsr lr, r2, #3
	beq .retN
	
	add r2, r1, #1
	
	rsb r5, r2, #32
	lsl r5, r3, r5
	
	lsr r1, r3, r2
	
	sub r6, r4, #1
	mov ip, #0
	
.divLoop:
	lsr r3, r5, #31
	orr r3, r1, lsl #1
	
	orr r5, ip, r5, lsl #1
	
	sub ip, r6, r3
	asr r1, ip, #31
	
	and ip, r1, #1
	
	and r1, r4
	sub r1, r3, r1
	
	subs r2, #1
	bne .divLoop
	
	orrs r3, ip, r5, lsl #1
	moveq r1, #1
	movne r1, #0
	cmp lr, #0
	moveq r1, #1
	cmp r1, #0
	bne .extendAndRet
	
	lsr r5, r3, #16
	lsl r5, #16
	
.yetAnotherClz:
	tst lr, #0x1F00
	lsrne r1, lr, #8
	movne ip, #20
	movne r2, #16
	moveq r1, lr
	moveq ip, #28
	moveq r2, #24
	
	tst r1, #0xF0
	lsrne r1, #4
	movne ip, r2
	
	tst r1, #0xC
	lsrne r1, #2
	addeq ip, #2
	
	lsr r2, r1, #1
	eor r2, #1
	ands r2, #1
	mvnne r2, #0
	rsb r1, #2
	and r2, r1
	add r2, ip
	
	cmp r5, #0
	lsrne r1, r3, #16
	movne r4, #8
	movne ip, #0
	moveq r1, r3
	moveq r4, #24
	moveq ip, #16
	
	tst r1, #0xFF00
	lsrne r1, #8
	movne r4, ip
	
	tst r1, #0xF0
	lsrne r1, #4
	addeq r4, #4
	
	tst r1, #0xC
	lsrne r1, #2
	addeq r4, #2
	
	lsr ip, r1, #1
	eor ip, #1
	ands ip, #1
	mvnne ip, #0
	rsb r1, #2
	and r1, ip
	add r1, r4
	
	sub r2, r1
	
	cmp r2, #31
	bhi .frameCnt0
	
	moveq r2, r3
	moveq r3, #0
	beq .return
	
	add r5, r2, #1
	
	rsb r2, r5, #32
	lsl r4, r3, r2
	
	lsr r1, r3, r5
	
	sub r6, lr, #1
	mov r2, #0
	
.divLoop2:
	lsr r3, r4, #31
	orr r3, r1, lsl #1
	
	orr r4, r2, r4, lsl #1
	
	sub ip, r6, r3
	asr r1, ip, #31
	
	and r2, r1, #1
	
	and r1, lr
	sub r1, r3, r1
	
	subs r5, #1
	bne .divLoop2
	
	orr r2, r4, lsl #1
	mov r3, r5
	b .return
	
	
.retN:
	cmp lr, #0
	bne .yetAnotherClz
	
	mov r2, lr
	
.extendAndRet:
	mov r3, r2
	b .return
	
	
.retMin2:
	mvn r0, #1
	bx lr
	
	
.retMin1:
	mvn r0, #0
	bx lr
	
.aRiff:
	dw 0x52494646
	
.aWave:
	dw 0x57415645
	
.aFmt:
	dw 0x666D7420
	
.aData:
	dw 0x64617461
	
	
	
	
	
	
_wav_parseARMv5t:
	ldrb r2, [r1, #1]
	ldrb r3, [r1]
	ldrb ip, [r1, #2]
	orr r3, r2, lsl #8
	ldrb r2, [r1, #3]
	orr r3, ip, lsl #16
	orr r3, r2, lsl #24
	
	eor r2, r3, ror #16
	lsr r2, #8
	bic r2, #0xFF00
	
	ldr ip, [.aRiff]
	eor r3, r2, r3, ror #8
	cmp r3, ip
	bne .retMin1
	
	ldrb r2, [r1, #9]
	ldrb r3, [r1, #8]
	ldrb ip, [r1, #10]
	orr r3, r2, lsl #8
	ldrb r2, [r1, #11]
	orr r3, ip, lsl #16
	orr r3, r2, lsl #24
	
	eor r2, r3, r3, ror #16
	lsr r2, #8
	bic r2, #0xFF00
	
	ldr ip, [.aWave]
	eor r3, r2, r3, ror #8
	cmp r3, ip
	bne .retMin2
	
	push {r4, r5, r6, r7, lr}
	
	add r1, #12
	
	ldr r4, [.aFmt]
	ldr r5, [.aData]
	b .startLoop
	
.loop:
	add r3, #8
	add r1, r3
	
.startLoop:
	ldrb r3, [r1, #1]
	ldrb r2, [r1]
	ldrb ip, [r1, #2]
	orr r2, r3, lsl #8
	ldrb r3, [r1, #3]
	orr r2, ip, lsl #16
	orr r2, r3, lsl #24
	
	eor ip, r2, r2, ror #16
	lsr ip, #8
	
	ldrb r3, [r1, #4]
	ldrb r7, [r1, #5]
	bic ip, #0xFF00
	eor r2, ip, r2, ror #8
	orr r3, r7, lsl #8
	ldrb ip, [r1, #7]
	cmp r2, r4
	orr r3, r6, lsl #16
	orr r3, ip, lsl #24
	addeq lr, r1, #8
	beq .loop
	
	cmp r2, r5
	bne .loop
	
	mov ip, #0
	add r1, #8
	str ip, [r0, #12]
	str r1, [r0]
	str r3, [r0, #8]
	
	ldrb r1, [lr, #5]
	ldrb r2, [lr, #4]
	ldrb r4, [lr, #6]
	orr r2, r1, lsl #8
	ldrb r1, [lr, #7]
	orr r2, r4, lsl #16
	orrs r2, r1, lsl #24
	
	moveq ip, #0
	moveq r2, ip
	bne .origNot0
	
.afterConv:
	mov r4, ip
	mov r5, r2
	
	ldrb r1, [lr, #1]
	ldrb r2, [lr]
	
	str r4, [r0, #16]
	str r5, [r0, #20]
	
	orr r2, r1, lsl #8
	str r2, [r0, #36]
	
	ldrb r2, [lr, #3]
	ldrb r4, [lr, #2]
	
	cmp r3, #0
	orr r4, r2, lsl #8
	clz r2, r4
	lsr r2, #5
	
	moveq r2, #1
	cmp r2, #0
	str r4, [r0, #32]
	beq .n0
	
.frameCnt0:
	mov r2, #0
	mov r1, r2
	
.return:
	str r2, [r0, #24]
	str r1, [r0, #28]
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
	
.origNot0:
	clz r1, r2
	add r5, r1, #21
	sub r4, r1, #11
	lsl r6, r2, r5
	lsl r4, r2, r4
	
	rsb r1, #0x410
	rsb r5, #0x20
	orr r4, r2, lsr r5
	
	add r1, #14
	adds ip, r6
	
	eor r4, #0x100000
	lsl r2, r1, #20
	
	adc r2, r4
	b .afterConv
	
	
.n0:
	clz ip, r4
	clz r5, r3
	sub ip, r5
	
	cmp ip, #31
	bhi .extendAndRet
	
	ldrb r1, [lr, #14]
	ldrb lr, [lr, #15]
	orr lr, r1, lr, lsl #8
	lsr lr, #3
	beq .retN
	
	add ip, #1
	rsb r5, ip, #32
	lsl r5, r3, r5
	
	sub r7, r4, #1
	lsr r3, ip
	
.divLoop:
	lsr r1, r5, #31
	orr r3, r1, r3, lsl #1
	
	sub r1, r7, r3
	asr r1, #31
	
	and r6, r4, r1
	subs ip, #1
	orr r5, r2, r5, lsl #1
	sub r3, r6
	and r2, r1, #1
	bne .divLoop
	
	orrs r3, r2, r5, lsl #1
	moveq r2, #1
	movne r2, #0
	cmp lr, #0
	moveq r2, #1
	cmp r2, #0
	bne .frameCnt0
	
	clz r5, r3
	
.div2:
	clz r1, lr
	sub r1, r5
	
	cmp r1, #31
	bhi .frameCnt0
	
	moveq r2, r3
	moveq r1, #0
	beq .return
	
	mov r2, #0
	add r1, #1
	rsb r4, r1, #0x20
	lsl r4, r3, r4
	sub r6, lr, #1
	lsr r3, r1
	
.divLoop2:
	lsr ip, r4, #31
	orr r3, ip, r3, lsl #1
	
	sub ip, r6, r3
	asr ip, #31
	
	and r5, ip, lr
	subs r1, #1
	orr r4, r2, r4, lsl #1
	sub r3, r5
	and r2, ip, #1
	bne .divLoop2
	
	orr r2, r4, lsl #1
	b .return
	
	
.retN:
	cmp lr, #0
	bne .div2
	
	mov r2, lr
	
.extendAndRet:
	mov r1, r2
	b .return
	
	
.retMin2:
	mvn r0, #1
	bx lr
	
.retMin1:
	mvn r0, #0
	bx lr
	
.aRiff:
	dw 0x52494646
	
.aWave:
	dw 0x57415645
	
.aFmt:
	dw 0x666D7420
	
.aData:
	dw 0x64617461
	
	
	
	
	
	
_wav_parseARMv7ve:
	ldr r2, [r1]
	movw r3, #0x4952
	movt r3, 0x4646
	cmp r2, r3
	bne .retMin1
	
	ldr r2, [r1, #8]
	movw r3, #0x4157
	movt r3, 0x4556
	cmp r2, r3
	bne .retMin2
	
	push {r4, r5, r6, r7, lr}
	
	movw ip, #0x7420
	movw lr, #0x7461
	add r1, #12
	movt ip, 0x666D
	movt lr, 0x6461
	b .startLoop
	
	
.loop:
	add r2, #8
	add r1, r2
	
.startLoop:
	ldr r3, [r1]
	ldr r2, [r1, #4]
	rev r3, r3
	cmp r3, ip
	addeq r4, r1, #8
	beq .loop
	
	cmp r3, lr
	bne .loop
	
	add r1, #8
	str r2, [r0, #8]
	str r1, [r0]
	
	mov r1, #0
	str r1, [r0, #12]
	
	ldr lr, [r4, #4]
	cmp lr, r1
	moveq r1, #0
	moveq r3, r1
	bne .continueConv
	
.afterConv:
	ldrh ip, [r4]
	mov r6, r1
	mov r7, r3
	strd r6, [r0, #16]
	
	mov r1, #0
	str ip, [r0, #36]
	
	ldrh r3, [r4, #2]
	udiv r2, r3
	str r3, [r0, #32]
	
	ldrh r3, [r4, #14]
	str r1, [r0, #28]
	lsr r3, #3
	
	udiv r2, r3
	str r2, [r0, #24]
	
	mov r0, r1
	pop {r4, r5, r6, r7, pc}
	
	
.continueConv:
	clz r3, lr
	add r5, r3, #21
	sub ip, r3, #11
	rsb r3, #0x410
	lsr r6, lr, r5
	lsl ip, lr, ip
	
	add r3, #14
	rsb r5, #32
	adds r1, r6
	orr ip, lr, lsr r5
	lsl r3, #20
	eor ip, #0x100000
	
	adc r3, ip
	b .afterConv
	
	
.retMin2:
	mvn r0, #1
	bx lr
	
	
.retMin1:	
	mvn r0, #0
	bx lr
	
	
	
	
	
	
_wav_write:
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	sub sp, #8
	
	ldr r4, [r1, #36]
	cmp r4, #1
	beq .nBytes2
	
	cmp r4, #3
	bne .retMin1
	
	mov lr, #32
	mov r6, #4
	mov r7, r6
	
.afterNbytesCheck:
	mov r3, #0
	mov r2, #82
	strb r2, [r0]
	mov r2, #73
	strb r2, [r0, #1]
	mov r2, #70
	strb r2, [r0, #2]
	strb r2, [r0, #3]
	
	ldr r2, [r1, #8]
	add ip, r2, #36
	strb ip, [r0, #4]
	lsr r5, ip, #8
	strb r5, [r0, #5]
	lsr r5, ip, #16
	strb r5, [r0, #6]
	lsr ip, #24
	strb ip, [r0, #7]
	
	mov ip, #87
	strb ip, [r0, #8]
	mov ip, #65
	strb ip, [r0, #9]
	mov ip, #86
	strb ip, [r0, #10]
	mov ip, #69
	strb ip, [r0, #11]
	
	mov ip, #102
	strb ip, [r0, #12]
	mov ip, #109
	strb ip, [r0, #13]
	mov ip, #116
	strb ip, [r0, #14]
	mov ip, #32
	strb ip, [r0, #15]
	
	mov ip, #16
	strb ip, [r0, #16]
	strb r3, [r0, #17]
	strb r3, [r0, #18]
	strb r3, [r0, #19]
	
	strb r4, [r0, #20]
	lsr r4, #8
	strb r4, [r0, #21]
	
	ldr r9, [r1, #32]
	lsl r4, r9, ip
	lsr ip, r4, ip
	strb ip, [r0, #22]
	lsr r4, #24
	strb r4, [r0, #23]
	
	add r5, r1, #16
	ldmia r5, {r4-r5}
	stm sp, {r4-r5}
	
	cmp r4, #0
	sbcs r1, r5, #0
	blt .zero
	
	lsr r10, r5, #20
	sub r1, r10, #0x3FC
	sub r1, #3
	
	mov r4, r5
	bic r8, r5, #-0x1000000
	bic r8, #0xF00000
	orr r8, #0x100000
	
	cmp r1, r3
	blt .zero
	mul r3, r7, r9
	
	cmp r1, #32
	rsbhi r5, r3, #0
	mvnhi r4, #0
	bhi .finishConv
	
	cmp r1, #51
	bgt .shiftLeftToRes
	
	rsb r1, #52
	rsb r7, r1, #32
	sub r5, r1, #32
	ldr r4, [sp]
	lsr r4, r1
	orr r4, r8, lsl r7
	orr r4, r8, lsr r5
	mul r5, r4, r3
	
.finishConv:
	strb r4, [r0, #24]
	lsr r1, r4, #8
	strb r1, [r0, #25]
	lsr r1, r4, #16
	strb r1, [r0, #26]
	lsr r4, #24
	strb r4, [r0, #27]
	
	strb r5, [r0, #28]
	lsr r1, r5, #8
	strb r1, [r0, #29]
	lsr r1, r5, #16
	strb r1, [r0, #30]
	lsr r3, r5, #24
	strb r3, [r0, #31]
	
	mul r3, r6, ip
	strb r3, [r0, #32]
	lsr r3, #8
	strb r3, [r0, #33]
	
	strb lr, [r0, #34]
	mov r3, #0
	strb r3, [r0, #35]
	
	mov r3, #100
	strb r3, [r0, #36]
	mov r3, #97
	strb r3, [r0, #37]
	mov r1, #116
	strb r1, [r0, #38]
	strb r1, [r0, #39]
	
	strb r2, [r0, #40]
	lsr r3, r2, #8
	strb r3, [r0, #41]
	lsr r3, r2, #16
	strb r3, [r0, #42]
	lsr r2, #24
	strb r2, [r0, #43]
	
	mov r0, #0
	
.return:
	add sp, #8
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
	
.shiftLeftToRes:
	sub r10, #0x430
	sub r10, #3
	ldr r1, [sp]
	lsl r4, r1, r10
	mul r5, r4, r3
	b .finishConv
	
	
.zero:
	mov r5, r3
	mov r4, r3
	b .finishConv
	
	
.nBytes2:
	mov lr, #16
	mov r6, #2
	mov r7, r6
	b .afterNbytesCheck
	
	
.retMin1:
	mvn r0, #0
	b .return
	
	
	
	
	
	
_wav_writeARMv7:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	mov r3, r0
	ldr r5, [r1, #36]
	sub sp, #12
	
	cmp r5, #1
	beq .nBytes2
	
	cmp r5, #3
	bne .retMin1
	
	movs r4, #4
	movs r6, #32
	mov r9, r4
	
.afterNbytesCheck:
	ldr r8, [r1, #32]
	movs r2, #0
	ldr r6, [r1, #8]
	mov lr, #82
	ldrd r0, [r1, #16]
	uxth ip, r8
	strh r5, [r3, #20]
	
	cmp r0, #0
	add r5, r6, #36
	mov fp, r1
	sbcs r1, fp, #0
	mov r10, r0
	
	str r5, [r3, #4]
	strd r10, [sp]
	
	mov r5, #73
	strh ip, [r3, #22]
	strb r5, [r3, #1]
	
	mov r5, #70
	strb r2, [r3, #17]
	strb r5, [r3, #2]
	strb r5, [r3, #3]
	
	mov r5, #87
	strb r2, [r3, #18]
	strb r5, [r3, #8]
	
	mov r5, #65
	strb r2, [r3, #19]
	strb r5, [r3, #9]
	
	mov r5, #86
	strb lr, [r3]
	strb r5, [r3, #10]
	
	mov r5, #69
	strb r5, [r3, #11]
	
	mov r5, #102
	strb r5, [r3, #12]
	
	mov r5, #109
	strb r5, [r3, #13]
	
	mov r5, #116
	strb r5, [r3, #14]
	
	mov r5, #32
	strb r5, [r3, #15]
	
	mov r5, #16
	strb r5, [r3, #16]
	
	blt .conv0
	
	lsr r10, fp, #20
	ldr r1, [sp, #4]
	sub r5, r10, #1020
	sub r5, #3
	
	cmp r5, r2
	ubfx lr, r1, #0, #20
	orr lr, #0x100000
	
	blt .conv0
	
	mul r2, r9, r8
	
	cmp r5, #32
	
	itt hi
	movhi r0, #-1
	rsbhi r2, #0
	
	bhi .finishConv
	
	cmp r5, #51
	bgt .shiftLeftToRes
	
	ldr r0, [sp]
	rsb r5, #52
	rsb r1, r5, #32
	lsr r1, lr, r1
	lsrs r0, r5
	subs r5, #32
	orrs r0, r1
	lsr r5, lr, r5
	orrs r0, r5
	mul r2, r0
	
.finishConv:
	str r0, [r3, #24]
	mul r4, ip
	
	movs r0, #100
	strb r0, [r3, #26]
	
	movs r0, #0
	str r2, [r3, #28]
	
	movs r1, #116
	movs r2, #97
	strh r7, [r3, #34]
	str r6, [r3, #40]
	strh r4, [r3, #32]
	strb r2, [r3, #37]
	strb r2, [r3, #39]
	strb r1, [r3, #38]
	
.return:
	add sp, #12
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
	
.shiftLeftToRes:
	ldr r1, [sp]
	subw r10, #0x400
	sub r10, #0x23
	lsl r0, r1, r10
	mul r2, r0
	b .finishConv
	
	
.conv0:
	mov r0, r2
	b .finishConv
	
	
.nBytes2:
	movs r4, #2
	movs r7, #16
	mov r9, r4
	b .afterNbytesCheck
	
	
.retMin1:
	mov r0, #-1
	b .return