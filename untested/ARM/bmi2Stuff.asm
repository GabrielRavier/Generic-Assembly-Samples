
    code32

    format  ELF
    public _mulx

section '.text' executable align 16

_mulx:	; requires ARMv3m
	str r4, [sp, #-4]
	
	umull r3, r4, r1, r0
	mov r1, r4
	mov r0, r3
	
	str r4, [r2]
	
	ldr r4, [sp]
	bx lr
	
	
	
	
_mulxARMv4:
	str r4, [sp, #-4]
	
	umull r3, r4, r1, r0
	mov r1, r4
	mov r0, r3
	
	str r4, [r2]
	
	ldr r4, [sp]
	bx lr
	
	
	
_mulxARMv5e:
	push {r4, r5}
	
	umull r4, r5, r1, r0
	mov r0, r4
	mov r1, r5
	
	str r5, [r2]
	
	pop {r4, r5}
	bx lr
	
	
	
	
_mulxARMv6:
	umull r0, r1, r1, r0
	
	str r1, [r2]
	
	bx lr 