
    code32

    format  ELF
    public _findFirstSet
    public _findFirstSet64
	
section '.text' executable align 16

_findFirstSet:
	cmp r0, #0
	bxeq lr
	
	lsl r3, r0, #16
	lsr r3, #16
	
	cmp r3, #0
	lsreq r0, #16
	moveq r3, #24
	moveq r2, #16
	movne r3, #8
	movne r2, #0
	
	tst r0, #255
	lsreq r0, #8
	moveq r2, r3
	
	tst r0, #15
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
	
	add r0, #1
	bx lr
	
	
	
	
_findFirstSetARMv5:
	rsb r3, r0, #0
	and r0, r3
	clz r0, r0
	
	rsb r0, #32
	bx lr
	
	
	
	
_findFirstSetARMv7:
	cmp r0, #0
	rbit r0, r0
	clz r0, r0
	it eq
	moveq r0, #-1
	
	adds r0, #-1
	bx lr
	
	
	
	
_findFirstSetARMv7a:
	cmp r0, #0
	rbit r0, r0
	clz r0, r0
	mvneq r0, #0
	
	add r0, #1
	bx lr
	
	
	
	
	
	
_findFirstSet64:
	cmp r0, #0
	bne .lowNot0
	
	cmp r1, #0
	beq .ret0
	
	lsl r3, r1, #16
	lsr r3, #16
	
	cmp r3, #0
	lsreq r1, #16
	moveq r2, #57
	moveq r3, #49
	movne r2, #41
	movne r3, #33
	
	tst r1, #255
	lsreq r1, #8
	moveq r3, r2
	
	tst r1, #15
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
	and r0, r1
	
	add r0, r3
	mov r1, #0
	bx lr
	
.lowNot0:
	lsl r3, r0, #16
	lsr r3, #16
	cmp r3, #0
	lsreq r0, #16
	moveq r3, #24
	moveq r2, #16
	movne r3, #8
	movne r2, #0
	
	tst r0, #255
	lsreq r0, #8
	moveq r2, r3
	
	tst r0, #15
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
	mvnne r0, #1
	and r0, r3
	add r0, r2
	
	add r0, #1
	asr r1, r0, #31
	bx lr
	
	
.ret0:
	mov r0, #0
	mov r1, #0
	bx lr
	
	
	
	
	
	
_findFirstSet64ARMv5:
	cmp r0, #0
	bne .lowNot0
	
	cmp r1, #0
	bne .highNot0
	
	mov r0, #0
	mov r1, #0
	bx lr
	
.highNot0:
	rsb r0, r1, #0
	and r0, r1
	clz r0, r0
	mov r1, #0
	rsb r0, #64
	bx lr
	
.lowNot0:
	rsb r3, r0, #0
	and r0, r3
	clz r0, r0
	rsb r0, #32
	asr r1, r0, #31
	bx lr
	