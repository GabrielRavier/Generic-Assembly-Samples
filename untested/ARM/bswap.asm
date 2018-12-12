
    code32

    format  ELF
    public _bswap16
    public _bswap32
    public _bswap64
	
section '.text' executable align 16

_bswap16:
	lsr r3, r0, #8
	orr r0, r3, r0, lsl #8
	
	lsl r1, r0, #16
	lsr r0, r1, #16
	mov pc, lr
	
	
	
	align  16
_bswap16ARMv6:
	rev16 r0, r0
	uxth r0, r0
	bx lr
	
	
	
	
	
	align 16
_bswap32:
	eor r3, r0, r0, ror #16
	lsr r1, r3, #8
	bic r2, r1, #0xFF00
	
	eor r0, r2, r0, ror #8
	mov pc, lr
	
	
	
	align 16
_bswap32ARMv6:
	rev r0, r0
	bx lr
	
	
	
	
	
	align 16
_bswap64:
	mov r2, r1
	eor r1, r0, r0, ror #16
	eor r3, r2, r2, ror #16
	lsr ip, r1, #8
	lsr r3, r3, #8
	bic r1, ip, #0xFF00
	bic ip, r3, #0xFF00
	
	eor r1, r1, r0, ror #8
	eor r0, ip, r2, ror #8
	mov pc, lr
	
	
	
	align 16
_bswap64ARMv6:
	rev r3, r0
	rev r0, r1
	mov r1, r3
	bx lr
	