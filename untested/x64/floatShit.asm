global _fmin	; float fmin(float a1, float a2)
global _fmax	; float fmax(float a1, float a2)
global _ftrunc	; float ftrunc(float a1)
global _fround	; float fround(float a1)
global _fabs	; float fabs(float x)
global _fadd	; float fadd(float a1, float a2)
global _fchs	; float fchs(float a1)
global _fdiv	; float fdiv(float a1, float a2)
global _fatan	; float fatan(float a1)
global _fpatan	; float fpatan(float a1, float a2)

extern _atanf
extern _atan2

segment .text align=16

_fmin:
	minss xmm0, xmm1
	ret
	
	
	
_fminAVX:
	vminss xmm0, xmm0, xmm1
	ret
	
	
	
	
	
_fmax:
	maxss xmm0, xmm1
	ret
	
	
	
_fmaxAVX:
	vmaxss xmm0, xmm0, xmm1
	ret
	
	
	
	
	
_ftrunc:
	movss xmm1, [rel .dat1]
	andps xmm1, xmm0
	movss xmm2, [rel .dat2]
	comiss xmm2, xmm1
	jbe .return
	
	cvttss2si eax, xmm0
	pxor xmm0, xmm0
	cvtsi2ss xmm0, eax
	
.return:
	ret
	
	align 4
.dat1 dd 0x7FFFFFFF, 0, 0, 0

	align 4
.dat2 dd 0x4B000000



_ftruncSSE4:
	roundss xmm0, xmm0, 11
	ret
	
	
	
_ftruncAVX:
	vroundss xmm0, xmm0, xmm0, 11
	ret
	
	
	
_ftruncAVX512F:
	vrndscaless xmm0, xmm0, xmm0, 11
	ret
	
	
	
	
	
_fround:
	movss xmm2, [rel .dat1]
	movaps xmm1, xmm0
	andps xmm1, xmm2
	movss xmm3, [rel .dat2]
	comiss xmm3, xmm1
	jbe .return
	
	addss xmm1, [rel .dat3]
	cvttss2si eax, xmm1
	pxor xmm4, xmm4
	cvtsi2ss xmm4, eax
	andnps xmm2, xmm0
	movaps xmm0, xmm2
	orps xmm0, xmm4
	
.return:
	ret
	
	align 4
.dat1 dd 0x7FFFFFFF, 0, 0, 0
	
	align 4
.dat2 dd 0x4B000000

	align 4
.dat3 dd 0x3EFFFFFF



_froundSSE4:
	movaps xmm1, xmm0
	andps xmm1, [rel .dat1]
	orps xmm1, [rel .dat2]
	addss xmm0, xmm1
	roundss xmm0, xmm0, 3
	ret
	
	align 4
.dat1 dd 0x80000000, 0, 0, 0

	align 4
.dat2 dd 0x3EFFFFFF, 0, 0, 0



_froundAVX:
	vmovaps xmm1, xmm0
	vandps xmm2, xmm1, [rel .dat1]
	vorps xmm3, xmm2, [rel .dat2]
	vaddss xmm0, xmm0, xmm3
	vroundss xmm0, xmm0, 3
	ret
	
	align 4
.dat1 dd 0x80000000, 0, 0, 0

	align 4
.dat2 dd 0x3EFFFFFF, 0, 0, 0





_fabs:
	cvttss2si eax, xmm0
	cdq
	xor eax, edx
	xorps xmm0, xmm0
	sub eax, edx
	cvtsi2ss xmm0, eax
	ret
	
	
	
_fabsAVX:
	vcvttss2si eax, xmm0
	vxorps xmm0, xmm0, xmm0
	cdq
	xor eax, edx
	sub eax, edx
	vcvtsi2ss xmm0, xmm0, eax
	ret
	
	
	
	
	
_fadd:
	addss xmm0, xmm1
	ret
	
	
	
_faddAVX:
	vaddss xmm0, xmm0, xmm1
	ret
	
	
	
	
	
_fchs:
	xorps xmm0, [rel .dat]
	ret
	
	align 4
.dat dd 0x80000000, 0, 0, 0



_fchsAVX:
	vxorps xmm0, xmm0, [rel .dat]
	ret
	
	align 4
.dat dd 0x80000000, 0, 0, 0





_fdiv:
	pxor xmm2, xmm2
	comiss xmm1, xmm2
	je .return0
	
	divss xmm0, xmm1
	ret
	
.return0:
	pxor xmm0, xmm0
	ret


	
_fdivAVX:
	vxorps xmm2, xmm2, xmm2
	vcomiss xmm1, xmm2
	je .return0
	
	vdivss xmm0, xmm0, xmm1
	ret
	
.return0:
	vxorps xmm0, xmm0, xmm0
	ret
	
	
	
	
	
_fatan:
	jmp _atanf
	
	
	
	
	
_fpatan:
	push rsi
	
	xorps xmm2, xmm2
	ucomiss xmm0, xmm2
	jne .yup
	jp .yup
	
	xorps xmm0, xmm0
	pop rcx
	ret
	
.yup:
	divss xmm1, xmm0
	cvtss2sd xmm1, xmm1
	movsd xmm0, [rel .dat]
	call _atan2
	cvtsd2ss xmm0, xmm0
	pop rcx
	ret
	
	align 4
.dat dd 0, 0x3FF00000, 0x3F800000