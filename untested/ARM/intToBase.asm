
    code32

    format  ELF
    public _intToBase
    public _intToBase64
	extrn __divmodsi4

section '.text' executable align 16
	
_intToBase:
	cmp r0, #0
	beq .prnt0
	
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	rsblt r0, #0
	movlt r9, #1
	movge r9, #0
	asr r8, r2, #31
	
	eor r6, r2, r8
	sub r6, r8
	sub r4, r1, #1
	
	mov r7, r4
	mov r5, #0
	
.digitsLoop:
	asr lr, r0, #31
	eor r10, lr, r8
	cmp r6, #0
	moveq lr, r6
	beq .den0
	
	mov r3, r6
	mov ip, #1
	blt .denNegative
	
.countShiftLoop:
	lsl ip, #1
	lsls r3, #1
	bpl .countShiftLoop
	
	cmp ip, #0
	beq .qbit0
	
.denNegative:
	eor fp, lr, r0
	sub fp, lr
	mov lr, #0
	
.divLoop:
	cmp r3, fp
	subls fp, r3
	addls lr, ip
	lsr r3, #1
	lsrs ip, #1
	bne .divLoop
	
.den0:
	eor lr, r10
	sub lr, r10
	
	mul r3, lr, r2
	sub r0, r3
	
	and r3, r0, #255
	cmp r0, #9
	addgt r3, #87
	addle r3, #48
	and r3, #255
	add ip, r5, #1
	strb r3, [r7, #1]
	
	subs r0, lr, #0
	
	movne r5, ip
	bne .digitsLoop
	
	cmp r9, #0
	bne .numNegative
	
	strb r9, [r1, ip]
	
	cmp r5, #0
	popeq {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
.startReverse:
	add r2, r1, ip
	
.reverseLoop:
	ldrb r3, [r4, #1]
	ldrb r0, [r2, #-1]
	strb r0, [r4, #1]
	strb r3, [r2]
	
	add r0, r4, #2
	sub r0, r1
	add r4, #1
	mvn r3, r4
	add r3, r1
	add r3, r5
	cmp r3, r0
	bgt .reverseLoop
	
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
.numNegative:
	mov r3, #45
	strb r3, [r1, ip]
	
	add r5, r1, r5
	strb lr, [r5, #2]
	
	mov r5, ip
	add ip, #1
	b .startReverse
	
.qbit0:
	mov lr, ip
	b .den0
	
.prnt0:
	mov r3, #48
	strb r3, [r1]
	strb r0, [r1, #1]
	bx lr
	
	
	
	
	
	
_intToBaseARMv7ve:
	cmp r0, #0
	beq .prnt0
	
	sub r3, r1, #1
	rsblt r0, #0
	
	push {r4, r5, r6, lr}
	
	movlt r6, #1
	movge r6, #0
	mov r5, r3
	b .startDigitsLoop
	
.digitsLoop:
	mov lr, ip
	
.startDigitsLoop:
	sdiv r4, r0, r2
	mls r0, r2, r4, r0
	
	add ip, lr, #1
	cmp r0, #9
	uxtb r0, r0
	addgt r0, #87
	addle r0, #48
	
	cmp r4, #0
	uxtb r0, r0
	strb r0, [r5, #1]!
	mov r0, r4
	bne .digitsLoop
	
	cmp r6, #0
	bne .numNegative
	
	cmp lr, #0
	strb r6, [r1, ip]
	popeq {r4, r5, r6, pc}
	
.startReverse:
	add r0, r1, ip
	
.reverseLoop:
	ldrb r4, [r0, #-1]
	add ip, r3, #2
	ldrb r2, [r3, #1]
	add r3, #1
	sub ip, r1
	
	strb r4, [r3]
	strb r2, [r0]
	
	mvn r2, r3
	add r2, r1
	add r2, lr
	cmp ip, r2
	blt .reverseLoop
	
	pop {r4, r5, r6, pc}
	
.numNegative:
	add r2, r1, lr
	mov r0, #45
	mov lr, ip
	strb r0, [r1, ip]
	strb r4, [r2, #2]
	add ip, #1
	b .startReverse
	
.prnt0:
	mov r3, #48
	strb r0, [r1, #1]
	strb r3, [r1]
	bx lr
	
	
	
	
	
	
_intToBase64:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub sp, #60
	mov r5, r1
	
	orrs r1, r0, r1
	beq .prnt0
	
	mov r4, r0
	mov r1, r5
	cmp r0, #0
	sbcs ip, r5, #0
	
	movge r1, #0
	strge r1, [sp, #44]
	blt .numNegative
	
.startDigitsLoop:
	asr r7, r3, #31
	asr lr, r7, #31
	
	str lr, [sp, #36]
	str lr, [sp, #40]
	
	eor r0, r3, lr
	eor ip, r7, lr
	subs r0, lr
	str r0, [sp, #16]
	sbc r1, ip, lr
	str r1, [sp, #28]
	sub ip, r2, #1
	str ip, [sp, #8]
	mov r8, #0
	
	mov r7, #65536
	sub r7, #1
	and r3, r7
	str r3, [sp, #32]
	str ip, [sp, #48]
	mov r6, r5
	mov r5, r4
	str r2, [sp, #52]
	
.digitsLoop:
	asr ip, r6, #31
	mov lr, ip
	
	ldr r3, [sp, #36]
	eor r3, ip, r3
	str r3, [sp, #12]
	ldr r3, [sp, #40]
	eor r3, ip, r3
	str r3, [sp, #24]
	
	add r3, sp, #16
	ldmia r3, {r2-r3}
	orrs r1, r2, r3
	beq .den0
	
	cmp r2, #0
	sbcs r1, r3, #0
	
	mov r0, #1
	mov r1, #0
	blt .denNegative
	
.denLoop:
	adds r2, r2
	adc r3, r3
	
	adds r0,r0
	adc r1, r1
	
	cmp r2, #0
	sbcs r4, r3, #0
	bge .denLoop
	
	orrs r4, r0, r1
	beq .qbit0
	
.denNegative:
	eor r4, ip, r5
	eor fp, lr, r6
	subs r9, r4, ip
	sbc r10, fp, lr
	
	mov ip, #0
	mov lr, ip
	
.qbitLoop:
	cmp r3, r10
	cmpeq r2, r9
	bhi .denSupNum
	
	subs r9, r2
	sbc r10, r3
	adds ip, r0
	adc lr, r1
	
.denSupNum:
	lsr r4, r2, #1
	orr r4, r3, lsl #31
	lsr fp, r3, #1
	mov r2, r4
	mov r3, fp
	
	lsr r4, r0, #1
	orr r4, r1, lsl #31
	lsr fp, r1, #1
	mov r0, r4
	mov r1, fp
	
	orrs r4, r0, r1
	bne .qbitLoop
	
.endDiv:
	ldr r3, [sp, #12]
	ldr r2, [sp, #24]
	eor ip, r3
	eor lr, r2
	subs r3, ip, r3
	str r3, [sp]
	sbc r3, lr, r2
	str r3, [sp, #4]
	
	ldmia sp, {r3-r4}
	and r1, r7, r3
	ldr r2, [sp, #32]
	mov r0, r2
	mul r0, r1, r0
	
	ldr r3, [sp, #16]
	mul r2, r3, r2
	add r2, r0, lsr #16
	
	and r3, r0, r7
	add r3, r2, lsl #16
	
	ldr r2, [sp, #8]
	mul r2, r1, r2
	add r1, r2, r3, lsr #16
	
	and r3, r7
	add r2, r3, r1, lsl #16
	
	subs r2, r5, r2
	and r3, r2, #255
	
	cmp r2, #9
	addgt r2, r3, #87
	addle r2, r3, #48
	
	and r2, #255
	add r3, r8, #1
	
	ldr r1, [sp, #8]
	strb r2, [r1, #1]!
	str r1, [sp, #8]
	
	ldmia sp, {r5-r6}
	orrs r2, r5, r6
	beq .num0
	
	mov r8, r3
	b .digitsLoop
	
	
.den0:
	dw 0xE7F0DEF0	; make invalid instruction exception
	
	
.num0:
	ldr ip, [sp, #48]
	ldr r2, [sp, #52]
	
	ldr r1, [sp, #44]
	cmp r1, #0
	bne .numIsNegative
	
	strb r1, [r2, r3]
	cmp r8, #0
	beq .return
	
.startReverse:
	add r3, r2, r3
	
.reverseLoop:
	ldrb r1, [ip, #1]
	ldrb r0, [r3, #-1]
	strb r0, [ip, #1]
	strb r1, [r3]
	
	add r0, ip, #2
	sub r0, r2
	add ip, #1
	mvn r1, ip
	add r1, r2
	add r1, r8
	cmp r1, r0
	bgt .reverseLoop
	
.return:
	add sp, #60
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
.numIsNegative:
	mov r1, #45
	strb r1, [r2, r3]
	
	add r8, r2, r8
	mov r1, #0
	strb r1, [r8, #2]
	
	mov r8, r3
	add r3, #1
	b .startReverse
	
	
.numNegative:
	rsbs r0, #0
	rsc r1, #0
	mov r4, r0
	mov r5, r1
	
	mov r1, #1
	str r1, [sp, #44]
	b .startDigitsLoop
	
	
.qbit0:
	mov ip, r0
	mov lr, r1
	b .endDiv
	
	
.prnt0:
	mov r3, #48
	strb r3, [r2]
	
	mov r3, #0
	strb r3, [r2, #1]
	
	add sp, #60
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
	
	
	
_intToBase64ARMv3m:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub sp, #68
	stm sp, {r0-r1}
	
	orrs r1, r0, r1
	beq .prnt0
	
	ldmia sp, {r0-r1}
	cmp r0, #0
	sbcs ip, r1, #0
	
	movge r1, #0
	strge r1, [sp, #52]
	blt .numNegative
	
.startDigitsLoop:
	asr r1, r3, #31
	asr lr, r1, #31
	mov r0, r3
	
	eor r3, lr
	subs r3, lr
	str r3, [sp, #16]
	mov r3, r1
	mov r9, #0
	
	eor r3, lr
	sub ip, r2, #1
	sbc r3, lr
	
	str r0, [sp, #32]
	str r1, [sp, #36]
	str lr, [sp, #44]
	str lr, [sp, #48]
	str r3, [sp, #20]
	str r9, [sp, #12]
	str ip, [sp, #56]
	str ip, [sp, #40]
	str r2, [sp, #60]
	
.digitsLoop:
	ldr r3, [sp, #4]
	asr r6, r3, #31
	
	add r4, sp, #16
	ldmia r4, {r3-r4}
	orrs r2, r3, r4
	
	ldr r2, [sp, #48]
	eor r5, r6, r2
	ldr r2, [sp, #44]
	
	mov r7, r6
	eor lr, r6, r2
	beq .den0
	
	cmp r3, #0
	sbcs r2, r4, #0
	blt .denNegative
	
	mov r2, r3
	mov r0, #1
	mov r1, #0
	mov r3, r4
	
.denLoop:
	adds r2, r2
	adc r3, r3
	
	adds r0, r0
	adc r1, r1
	
	cmp r2, #0
	sbcs ip, r3, #0
	bge .denLoop
	
	str r2, [sp, #24]
	str r3, [sp, #28]
	
	orrs r3, r0, r1
	beq .qbit0
	
.doTheDiv:
	mov ip, #0
	mov r4, ip
	
	ldr r3, [sp]
	eor r3, r6, r3
	subs r8, r3, r6
	ldr r3, [sp, #4]
	eor r6, r7, r3
	add r3, sp, #24
	ldmia r3, {r2-r3}
	sbc r9, r6, r7
	
.qbitLoop:
	cmp r3, r9
	cmpeq r2, r8
	bhi .denSupNum
	
	subs r8, r2
	sbc r9, r3
	
	adds ip, r0
	adc r4, r1
	
.denSupNum:
	lsr r6, r0, #1
	orr r6, r8, r1, lsl #31
	lsr r7, r1, #1
	mov r0, r6
	mov r1, r7
	
	lsr r6, r2, #1
	orr r6, r3, lsl #31
	lsr r7, r3, #1
	mov r2, r6
	orrs r6, r0, r1
	mov r3, r7
	bne .qbitLoop
	
.endDiv:
	eor ip, lr
	subs r10, ip, lr
	eor r4, r5
	sbc fp, r4, r5
	
	add r5, sp, #32
	ldmia r5, {r4-r5}
	umull r2, r3, r4, r10
	ldr r1, [sp]
	subs r2, r1, r2
	
	cmp r2, #9
	and r2, #255
	addgt r2, #87
	addle r2, #48
	
	orrs r3, r10, fp
	
	ldr r3, [sp, #40]
	and r2, #255
	strb r2, [r3, #1]!
	str r3, [sp, #40]
	ldr r3, [sp, #12]
	stm sp, {r10-fp}
	add r3, #1
	
	beq .num0
	
	str r3, [sp, #12]
	b .digitsLoop
	
	
.den0:
	dw 0xE7F0DEF0	; make invalid instruction exception
	
	
.num0:
	ldr r1, [sp, #52]
	cmp r1, #0
	ldr r9, [sp, #12]
	ldr ip, [sp, #56]
	ldr r2, [sp, #60]
	bne .numIsNegative
	
	cmp r9, #0
	strb r1, [r2, r3]
	beq .return
	
.startReverse:
	add r3, r2, r3
	
.reverseLoop:
	ldrb r1, [r3, #-1]!
	ldrb lr, [ip, #1]
	add r0, ip, #2
	strb r1, [ip, #1]
	add ip, #1
	
	mvn r1, ip
	add r1, r2
	sub r0, r2
	add r1, r9
	cmp r1, r0
	
	strb lr, [r3]
	
	bgt .reverseLoop
	
.return:
	add sp, #68
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
.numIsNegative:	
	mov lr, #45
	mov r0, #0
	add r1, r2, r9
	strb lr, [r2, r3]
	mov r9, r3
	strb r0, [r1, #2]
	
	add r3, #1
	b .startReverse
	
	
.numNegative:
	rsbs r0, #0
	rsc r1, #0
	stm sp, {r0-r1}
	
	mov r1, #1
	str r1, [sp, #52]
	b .startDigitsLoop
	
	
.qbit0:
	mov ip, r0
	mov r4, r1
	b .endDiv
	
	
.denNegative:
	str r3, [sp, #24]
	str r4, [sp, #28]
	
	mov r0, #1
	mov r1, #0
	b .doTheDiv
	
	
.prnt0:
	mov r1, #48
	mov r3, #0
	strb r1, [r2]
	strb r3, [r2, #1]

	add sp, #68
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
	
	
	
_intToBase64ARMv5e:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub sp, #60
	strd r0, [sp]
	
	orrs r1, r0, r1
	beq .prnt0
	
	ldrd r0, [sp]
	cmp r0, #0
	sbcs ip, r1, #0
	
	movge r1, #0
	strge r1, [sp, #44]
	blt .numNegative
	
.startDigitsLoop:
	asr r1, r3, #31
	asr lr, r1, #31
	mov r0, r3
	
	eor r3, lr
	subs r3, lr
	str r3, [sp, #16]
	mov r3, r1
	eor r3, lr
	sub ip, r2, #1
	sbc r3, lr
	
	mov r9, #0
	strd r0, [sp, #24]
	str lr, [sp, #36]
	str lr, [sp, #40]
	str r3, [sp, #20]
	str ip, [sp, #12]
	str r9, [sp, #32]
	str ip, [sp, #48]
	str r2, [sp, #52]
	
.digitsLoop:
	ldr r3, [sp, #4]
	asr ip, r3, #31
	ldrd r2, [sp, #16]
	mov r4, ip
	
	orrs r1, r2, r3
	
	ldr r1, [sp, #40]
	eor r5, ip, r1
	ldr r1, [sp, #36]
	eor lr, ip, r1
	
	beq .den0
	
	cmp r2, #0
	sbcs r1, r3, #0
	
	mov r0, #1
	mov r1, #0
	
	blt .startQbitLoop
	
.denLoop:
	adds r2, r2
	adc r3, r3
	
	adds r0, r0
	adc r1, r1
	
	cmp r2, #0
	sbcs r6, r3, #0
	bge .denLoop
	
	orrs r6, r0, r1
	beq .qbit0
	
.startQbitLoop:
	ldr r6, [sp]
	eor r6, ip, r6
	subs r8, r6, ip
	ldr ip, [sp, #4]
	eor ip, r4, ip
	sbc r9, ip, r4
	
	mov ip, #0
	mov r4, ip
	
.qbitLoop:
	cmp r3, r9
	cmpeq r2, r8
	bhi .denSupNum
	
	subs r8, r2
	sbc r9, r3
	
	adds ip, r0
	adc r4, r1
	
.denSupNum:
	lsr r6, r0, #1
	orr r6, r1, lsl #31
	lsr r7, r1, #1
	mov r0, r6
	mov r1, r7
	
	lsr r6, r2, #1
	orr r6, r3, lsl #31
	
	orrs r7, r0, r1
	
	lsr r7, r3, #1
	mov r2, r6
	mov r3, r7
	
	bne .qbitLoop
	
.endDiv:
	eor ip, lr
	subs r10, ip, lr
	eor r4, r5
	sbc fp, r4, r5
	
	ldrd r4, [sp, #24]
	ldr r1, [sp]
	umull r2, r3, r4, r10
	strd r10, [sp]
	subs r2, r1, r2
	
	cmp r2, #9
	and r2, #255
	addgt r2, #87
	addle r2, #48
	
	orrs r3, r10, fp
	
	ldr r3, [sp, #12]
	and r2, #255
	strb r2, [r3, #1]
	str r3, [sp, #12]
	
	ldr r3, [sp, #32]
	add r3, #1
	
	beq .num0
	
	str r3, [sp, #32]
	b .digitsLoop
	
	
.den0:
	dw 0xE7F0DEF0	; make invalid instruction exception
	
	
.num0:
	ldr r1, [sp, #44]
	ldr r9, [sp, #32]
	cmp r1, #0
	ldr ip, [sp, #48]
	ldr r2, [sp, #52]
	bne .numIsNegative
	
	cmp r9, #0
	strb r1, [r2, r3]
	beq .return
	
.startReverse:
	add r3, r2, r3
	
.reverseLoop:
	ldrb r1, [r3, #-1]
	ldrb lr, [ip, #1]
	add r0, ip, #2
	strb r1, [ip, #1]
	add ip, #1
	
	mvn r1, ip
	add r1, r2
	sub r0, r2
	add r1, r9
	cmp r1, r0
	strb lr, [r3]
	bgt .reverseLoop
	
.return:
	add sp, #60
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
	
.numIsNegative:
	mov r0, #45
	add r1, r2, r9
	strb r0, [r2, r3]
	mov r9, r3
	mov r3, #0
	strb r3, [r1, #2]
	
	add r3, r9, #1
	b .startReverse
	
	
.numNegative:
	rsbs r0, #0
	rsc r1, #0
	strd r0, [sp]
	
	mov r1, #1
	str r1, [sp, #44]
	b .startDigitsLoop
	
	
.qbit0:
	mov ip, r0
	mov r4, r1
	b .endDiv
	
	
.prnt0:
	mov r1, #48
	mov r3, #0
	strb r1, [r2]
	strb r3, [r2, #1]
	
	add sp, #60
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}