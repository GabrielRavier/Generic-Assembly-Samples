
    code32

    format  ELF
	public _rotateLeft
	public _rotateRight
	
section '.text' executable align 16

_rotateLeft:
	and r1, #31
	rsb r1, #32
	ror r0, r1
	bx lr
	
	
	
	
	
	
_rotateRight:
	and r1, #31
	ror r0, r1
	bx lr
	