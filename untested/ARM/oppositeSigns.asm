
    code32

    format  ELF
    public _oppositeSigns
    public _oppositeSigns64

section '.text' executable align 16

_oppositeSigns:
	eor r0, r0, r1
	lsr r0, r0, #31
	mov pc, lr
	
	
	
	
	
	align 16
_oppositeSigns64:
	str fp, [sp, #-4]!
	
	eor fp, r0, r2
	eor ip, r1, r3
	lsr r3, fp, #31
	orr r1, r3, ip, lsl #1
	orrs r3, r1, ip, asr #31
	
	movne r0, #1
	moveq r0, #0
	ldr fp, [sp], #4
	mov pc, lr
	