
    code32

    format  ELF
    public _calcPi
	
section '.text' executable align 16

_calcPi:	; The calculation is just impossible to implement
	adr r1, .pi
	ldmia r1, {r0-r1}
	bx lr
	
.pi:
	dw 0x54442D18, 0x400921FB