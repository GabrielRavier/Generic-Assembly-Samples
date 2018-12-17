
    code32

    format  ELF
    public _andn
	public _blsi
	public _blsr
	public _andn64
	public _blsi64
	public _blsr64
	
section '.text' executable align 16

_andn:
	bic r0, r1, r0
	bx lr
	
	
	
	
	
	
_blsi:
	rsb r3, r0, #0
	and r0, r0, r3
	bx lr
	
	
	
	
	
	
_blsr:
	sub r3, r0, #1
	and r0, r0, r3
	bx lr
	
	
	
	
	
_andn64:
	bic r0, r2, r0
	bic r1, r3, r1
	bx lr
	
	
	
	
	
	
_blsi64:
	rsbs r2, r0, #0
	rsc r3, r1, #0
	
	and r0, r0, r2
	and r1, r1, r3
	bx lr
	
	
	
	
	
	
_blsr64:
	subs r2, r0, #1
	sbc r3, r1, #0
	
	and r0, r0, r2
	and r1, r1, r3
	bx lr
	