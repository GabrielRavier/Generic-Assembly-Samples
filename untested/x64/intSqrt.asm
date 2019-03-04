global _intSqrt

segment .text align=16

_intSqrt:
	pxor xmm0, xmm0
	cvtsi2sd xmm0, edi
	sqrtsd xmm1, xmm0
	cvttsd2si eax, xmm1
	ret
	
	
	
	align 16
_intSqrtAVX:
	vxorpd xmm0, xmm0, xmm0
	vcvtsi2sd xmm0, xmm0, edi
	vsqrtsd xmm1, xmm0, xmm0
	vcvttsd2si eax, xmm1
	ret