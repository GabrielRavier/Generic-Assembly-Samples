
    code32

    format  ELF
    public _gcd
	
section '.text' executable align 16

_gcd:
	cmp r1, #0
	cmpne r0, #0
	beq .return0
	
	cmp r1, r0
	beq .returnR1
	
	subge r1, r1, r0
	sublt r0, r0, r1
	b _gcd
	
.return0:
	mov r0, #0
	mov pc, lr
	
.returnR1:
	mov r0, r1
	mov pc, lr
	