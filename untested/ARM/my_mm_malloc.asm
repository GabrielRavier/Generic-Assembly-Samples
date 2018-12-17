
    code32

    format  ELF
	public _my_mm_malloc
	public _my_mm_free
	
	extrn _malloc
	extrn _free
	extrn ___errno_location
	
section '.text' executable align 16

_my_mm_malloc:
	push {r4, lr}
	
	sub r3, r1, #1
	tst r3, r1
	bne .notPowOf2
	
	cmp r0, #0
	beq .ret0
	
	cmp r1, #8
	movcs r4, r1
	movcc r4, #8
	
	add r0, r4
	bl _malloc
	
	subs r3, r0, #0
	beq .ret0
	
	add r0, r3, r4
	
	rsb r1, r4, #0
	and r0, r1
	
	str r3, [r0, #-4]
	pop {r4, pc}
	
	
.ret0:
	mov r0, #0
	pop {r4, pc}
	
	
.notPowOf2:
	bl ___errno_location
	mov r3, #22
	str r3, [r0]
	
	mov r0, #0
	pop {r4, pc}
	
	
	
	
	
	
_my_mm_free:
	cmp r0, #0
	bxeq lr
	
	ldr r0, [r0, #-4]
	b _free