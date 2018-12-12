
    code32

    format  ELF
    public _gf_mul
    public _AES_RotWord
	
section '.text' executable align 16

_gf_mul:
	mov r3, r0
	
	cmp r1, #0
	beq .b0
	
	mov r0, #0
	mov r2, #280	; I'd replace the mov and add with a movw for later procs but pfffff
	add r2, #3
	
.loop:
	tst r1, #1
	eorne r0, r3
	lsl r3, #1
	lsr r1, #1
	
	cmp r3, #255
	eorhi r3, r2
	
	cmp r1, #0
	bne .loop
	
	mov pc, lr
	
.b0:
	mov r0, r1
	mov pc, lr
	
	
	
	
	
	align 16
_AES_RotWord:
	ror r0, #8
	mov pc, lr
	