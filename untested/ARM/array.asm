
    code32

    format  ELF
    public _sumArray

section '.text' executable align 16

_sumArray:
	cmp r1, #0
	beq .return0
	
	sub r3, r0, #4
	add ip, r3, r1, lsl #2
	
	mov r0, #0
	mov r1, #1
	
.loop:
	ldr r2, [r3, #4]
	adds r0, r0, r2
	adc r1, r1, r2, asr #31
	
	cmp ip, r3
	bne .loop
	
	mov pc, lr
	
.return0:
	mov r0, #0
	mov r1, #0
	mov pc, lr 
	
	
	
_sumArrayARMv6z:
	subs ip, r1, #0
	
	mov r3, r0
	
	mov r1, #0
	mov r0, #0
	
	bxeq lr
	sub r3, r3, #4
	add ip, r3, ip, lsl #2
	
.loop:
	ldr r2, [r3, #4]
	adds r0, r0, r2
	adc r1, r1, r2, asr #31
	
	cmp ip, r3
	bne .loop
	
	bx lr 