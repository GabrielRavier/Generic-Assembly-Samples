
    code32

    format  ELF
    public _sumArray
    public _getMedian

section '.text' executable align 16

_sumArray:
	cmp r1, #0
	beq .ret0
	
	sub r3, r0, #4
	add r1, r3, r1, lsl #2
	mov r0, #0
	
.loop:
	ldr r2, [r3, #4]!
	add r0, r2
	
	cmp r3, r1
	bne .loop
	
	bx lr
	
.ret0:
	mov r0, r1
	bx lr
	
	
	
	
	
	
_getMedian:
	push {r4, r5, r6, r7, lr}
	
	cmp r2, #0
	beq .n0
	
	mov r7, #0
	mov ip, #0
	mov r4, ip
	mov lr, ip
	mov r6, ip
	mov r5, ip
	b .startLoop
	
	
.loop:
	mov r5, lr
	cmp lr, r2
	beq .iEqN
	
	mov r6, r4
	mov r7, r3
	cmp r4, r2
	beq .jEqN
	
.startLoop:
	ldr r3, [r0, r5, lsl #2]
	ldr r5, [r1, r6, lsl #2]
	cmp r3, r5
	
	addlt lr, #1
	addge r4, #1
	movge r3, r5
	
	add ip, #1
	cmp r2, ip
	bcs .loop
	
.return:
	add r3, r7, r3
	add r3, r3, lsr #31
	
	asr r0, r3, #1
	pop {r4, r5, r6, r7, pc}
	
	
.n0:
	mvn r3, #0
	
.iEqN:
	mov r7, r3
	ldr r3, [r1]
	b .return
	
	
.jEqN:
	ldr r3, [r0]
	b .return