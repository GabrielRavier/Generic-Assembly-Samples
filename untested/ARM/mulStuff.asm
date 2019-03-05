
    code32

    format  ELF
    public _isMulOk
	public _saturatedMul
	
section '.text' executable align 16

_isMulOk:
	cmp r1, #0
	cmpne r0, #0
	beq .return1
	
	umull r2, r3, r0, r1
	rsbs r0, r3, #1
	movcc r0, #0
	bx lr
	
.return1:
	mov r0, #1
	bx lr
	
	
	
	
_isMulOkArmv5:
	cmp r1, #0
	cmpne r0, #0
	
	umullne r2, r3, r0, r1
	clzne r0, r3
	lsrne r0, r0, #5
	
	moveq r0, #1
	
	bx lr
	
	
	
	
	
	
_saturatedMul:
	cmp r1, #0
	cmpne r0, #0
	mov ip, r0
	beq .doTheMul
	
	umull r2, r3, r0, r1
	cmp r3, #0
	bne .nope
	
.doTheMul:
	mul r0, r1, ip
	bx lr
	
.nope:
	mvn r0, #0
	bx lr
	