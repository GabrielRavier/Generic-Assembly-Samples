global _intDiv

segment .text align=16

_intDiv:
	pxor xmm0, xmm0
	pxor xmm1, xmm0
	cvtsi2ss xmm0, edi
	cvtsi2ss xmm1, esi
	divss xmm0, xmm1
	cvttss2si eax, xmm0
	ret
	
	
	
	align 16
_intDivAVX:
	vxorps xmm0, xmm0, xmm0
	vxorps xmm1, xmm1, xmm1
	vcvtsi2ss xmm0, xmm0, edi
	vcvtsi2ss xmm1, xmm1, esi
	vdivss xmm2, xmm0, xmm1
	vcvttss2si eax, xmm2
	ret