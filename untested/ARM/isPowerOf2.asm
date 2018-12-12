
    code32

    format  ELF
    public _isPowerOf2
    public _isPowerOf264

section '.text' executable align 16

_isPowerOf2:
	cmp r0, #0
	moveq pc, lr
	
	sub r3, r0, #1
	tst r3, r0
	moveq r0, #1
	movne r0, #0
	
	mov pc, lr
	
	
	
	
	
	align 16
_isPowerOf264:
	str fp, [sp, #-4]!
	mov fp, r0
	mov ip, r1
	
	orrs r3, fp, ip
	moveq r0, #0
	beq .return
	
	subs r2, fp, #1
	sbc r3, r1, #0
	and r0, fp, r2
	and r1, r1, r3
	orrs r3, r0, r1
	moveq r0, #1
	movne r0, #0
	
.return:
	ldr fp, [sp], #4
	mov pc, lr
	