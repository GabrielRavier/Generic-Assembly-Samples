
    code32

    format  ELF
    public _getSign1
    public _getSign2
    public _getSign3
    public _isNotNegative
    public _areSignsOpposite
    public _signExtendFromWidth
    public _conditionalClearOrSet
    public _swapBits
    public _hasZeroByte
    public _parity
    public _getSign164
    public _getSign264
    public _getSign364
    public _isNotNegative64
    public _areSignsOpposite64
    public _signExtendFromWidth64
    public _conditionalClearOrSet64
    public _swapBits64
    public _hasZeroByte64
    public _parity64

section '.text' executable align 16

_getSign1:
	asr r0, #31
	bx lr
	
	
	
	
	
	
_getSign2:
	asr r0, #31
	orr r0, #1
	bx lr
	
	
	
	
	
	
_getSign3:
	lsr r3, r0, #31
	cmp r0, #0
	rsble r0, r3, #0
	rsbgt r0, r3, #1
	bx lr
	
	
	
	
	
	
_isNotNegative:
	mvn r0, r0
	lsr r0, #31
	bx lr
	
	
	
	
	
	
_areSignsOpposite:
	eor r0, r1
	lsr r0, #31
	bx lr
	
	
	
	
	
	
_signExtendFromWidth:
	sub r3, r1, #1
	mov r2, #1
	lsl r2, r3
	
	mvn r3, #0
	bic r0, r3, lsl r1
	eor r0, r2
	
	sub r0, r2
	bx lr
	
	
	
	
	
	
_conditionalClearOrSet:
	rsb r2, #0
	eor r2, r0
	and r2, r3
	
	eor r0, r2
	bx lr
	
	
	
	
	
	
_swapBits:
	str lr, [sp, #-4]
	lsr ip, r3, r1
	eor ip, r3, lsr r0
	mvn lr, #0
	bic r2, ip, lr, lsl r2
	
	lsl r1, r2, r1
	orr r0, r1, r2, lsl r0
	
	eor r0, r3
	ldr pc, [sp], #4
	
	
	
	
	
	
_hasZeroByte:
	ands r3, r0, #255
	beq .ret0
	
	lsr r3, r0, #8
	ands r3, #255
	beq .ret0
	
	lsr r3, r0, #16
	and r3, #255
	beq .ret0
	
	lsrs r3, r0, #24
	movne r0, #1
	moveq r0, #0
	bx lr
	
	
.ret0:
	mov r0, r3
	bx lr
	
	
	
	
	
	
_parity:
	eor r0, r0, lsr #16
	eor r0, r0, lsr #8
	eor r0, r0, lsr #4
	
	and r0, #0xF
	mov r3, #0x6900
	add r3, #0x96
	asr r0, r3, r0
	
	and r0, #1
	bx lr
	
	
	
	
	
	
_getSign164:
	asr r0, r1, #31
	bx lr
	
	
	
	
	
	
_getSign264:
	asr r1, #31
	orr r0, r1, #1
	bx lr
	
	
	
	
	
	
_getSign364:
	mov r2, r1
	
	cmp r0, #1
	sbcs r3, r2, #0
	movge r0, #1
	movlt r0, #0
	
	sub r0, r2, lsr #31
	bx lr
	
	
	
	
	
	
_isNotNegative64:
	mvn r0, r1
	lsr r0, #31
	bx lr
	
	
	
	
	
	
_areSignsOpposite64:
	eor r3, r1
	lsr r0, r3, #31
	bx lr
	
	
	
	
	
	
_signExtendFromWidth64:
	push {r4, r5, r6, lr}
	
	sub ip, r2, #1
	mov r3, #1
	sub r6, r2, #33
	rsb r5, ip, #32
	lsl lr, r3, r6
	orr lr, r3, lsr r5
	lsl r4, r3, ip
	
	mvn ip, #0
	sub r6, r2, #32
	rsb r5, r2, #32
	lsl r3, ip, r2
	orr r3, ip, lsl r6
	orr r3, ip, lsr r5
	bic ip, r0, ip, lsl r2
	bic r3, r1, r3
	
	eor r0, ip, r4
	eor r1, r3, lr
	
	subs r0, r4
	sbc r1, lr
	pop {r4, r5, r6, pc}
	
	
	
	
	
	
_conditionalClearOrSet64:
	push {r4, r5, lr}
	ldrb ip, [sp, #12]
	
	rsb ip, #0
	mov r4, ip
	asr r5, ip, #31
	eor ip, r0
	eor lr, r5, r1
	and ip, r2
	and r3, lr
	
	eor r0, ip
	eor r1, r3
	pop {r4, r5, pc}
	
	
	
	
	
	
_swapBits64:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub sp, #12
	add r5, sp, #48
	ldm r5, {r5, ip}
	
	rsb r8, r0, #32
	sub r9, r0, #32
	lsr lr, r5, r0
	orr lr, ip, lsl r8
	orr lr, ip, lsr r9
	rsb r6, r1, #32
	sub r7, r1, #32
	lsr r3, r5, r1
	orr r3, ip, lsl r6
	orr r3, ip, lsr r7
	lsr r4, ip, r1
	eor lr, r3
	eor r3, r4, ip, lsr r0
	str r3, [sp, #4]
	mvn r3, #0
	sub fp, r2, #32
	rsb r10, r2, #32
	lsr r4, r3, r2
	orr r4, r3, lsl fp
	orr r4, r3, lsr r10
	bic r3, lr, r3, lsl r2
	ldr r2, [sp, #4]
	bic r4, r2, r4
	
	lsl r2, r4, r0
	orr r2, r3, lsl r9
	orr r2, r3, lsr r8
	lsl r4, r1
	orr r4, r3, lsl r7
	orr r4, r3, lsr r6
	lsl r1, r3, r1
	orr r0, r1, r3, lsl r0
	orr r4, r2, r4
	
	eor r0, r5
	eor r1, r4, ip
	add sp, #12
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
	
	
	
	
	
_hasZeroByte64:
	ands r3, r0, #255
	beq .ret0
	
	lsr r3, r0, #8
	ands r3, #255
	beq .ret0
	
	lsr r3, r0, #16
	ands r3, #255
	beq .ret0
	
	lsrs r0, #24
	bxeq lr
	
	ands r0, r1, #255
	bxeq lr
	
	lsr r0, r1, #8
	ands r0, #255
	bxeq lr
	
	lsr r3, r1, #8
	ands r0, r3, #255
	bxeq lr
	
	lsrs r3, r1, #24
	movne r0, #1
	moveq r0, #0
	bx lr
	
	
.ret0:
	mov r0, r3
	bx lr
	
	
	
	
	
	
_parity64:
	eor r0, r1
	eor r0, r0, lsr #16
	eor r0, r0, lsr #8
	eor r0, r0, lsr #4
	
	and r0, #0xF
	mov r3, #0x6900
	add r3, #0x96
	asr r0, r3, r0
	
	and r0, #1
	bx lr
	