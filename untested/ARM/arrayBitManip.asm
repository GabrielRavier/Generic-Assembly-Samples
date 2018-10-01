
    code32

    format  ELF
    public _setBit
	public _clearBit
	public _getBit

section '.text' executable align 16

_setBit:
	and r2, r1, #7
	ldrb r3, [r0, r1, lsr #3]
	mov ip, #1
	orr r2, r3, ip, lsl r2
	strb r2, [r0, r1, lsr #3]
	mov pc, lr
	
	
	
	
	
_clearBit:
	and r2, r1, #7
	ldrb r3, [r0, r1, lsr #3]
	mov ip, #1
	bic r2, r3, ip, lsl r2
	strb r2, [r0, r1, lsr #3]
	mov pc, lr
	
	
	
	
	
_getBit:
	ldrb r0, [r0, r1, lsr #3]
	and r1, r1, #7
	asr r2, r0, r1
	
	and r0, r2, #1
	mov pc, lr 