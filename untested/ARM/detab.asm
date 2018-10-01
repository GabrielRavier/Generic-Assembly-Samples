
    code32

    format  ELF
    public _detab

section '.text' executable align 16

_detab:
	ldrb r3, [r8]
	cmp r3, #0
	beq .return
	
.loop:
	cmp r3, #9
	beq .replace
	
	ldrb r3, [r0, #1]
	cmp r3, #0
	bne .loop
	
.return:
	mov r0, #0
	mov pc, lr
	
.replace:
	strb r2, [r0]
	ldrb r3, [r0, #1]
	cmp r3, #0
	bne .loop
	
	mov r0, #0
	mov pc, lr
	