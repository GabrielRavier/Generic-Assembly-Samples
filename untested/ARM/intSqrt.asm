
    code32

    format  ELF
    public _intSqrt

section '.text' executable align 16

_intSqrt:
	vmov s15, r0
	vcvt.f64.s32 d6, s15
	vsqrt.f64 d7, d6
	
	vcvt.s32.f64 s0, d7
	vmov r0, s0 
	bx lr 