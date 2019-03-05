    code32

    format  ELF
    public _rand
    public _srand
	
section '.data' writeable align 16

	next dw 1
	
section '.text' executable align 16

_rand:	; requires ARMv3m
	ldr r1, [.oNext]
	ldr r2, [r1]
	cmp r2, #0
	beq .zeroIsForbiddenLol
	
	ldr r0, [.magic1]
	umull r3, ip, r2, r0
	sub r3, r2, ip
	add r0, ip, r3, lsr #1
	ldr ip, [.magic2]
	lsr r3, r0, #16
	mul r0, ip, r3
	sub r2, r0
	
	add r0, r2, r2, lsl #2
	rsb r0, r0, lsl #4
	add r2, r0, lsl #5
	ldr r0, [.magic3]
	rsb r2, r2, lsl #3
	mla ip, r3, r0, r2
	
	cmp ip, #0
	sublt ip, #-0x7FFFFFFF
	mov r3, ip
	
.finish:
	str r3, [r1]
	mov r0, ip
	bx lr
	
.zeroIsForbiddenLol:
	ldr r3, [.valFor0]
	mov ip, r3
	b .finish
	
	align 2
.oNext:
	dw next
.magic1:
	dw 110892733
.magic2:
	dw 127773
.magic3:
	dw -2836
.valFor0:
	dw 520932930





	
_srand:
	ldr r3, [.oNext]
	str r0, [r3]
	bx lr
	
.oNext:
	dw next