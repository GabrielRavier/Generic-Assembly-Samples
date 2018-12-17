
    code32

    format  ELF
    public _intDiv

section '.text' executable align 16

_intDiv:
	vmov s15, r0
	vmov s0, r1
	vcvt.f64.s32 d5, s15
	vcvt.f64.s32 d6, s0
	vdiv.f64 d7, d5, d6
	
	vcvt.s32.f64 s1, d7
	vmov r0, s1
	bx lr 