global _fmin
global _fmax
global _ftrunc
global _fround
global _fabs
global _fadd
global _fchs
global _fdiv
global _fpatan
global _fclamp
global _fsign
global _fintersect
global _ftoi
global _facos
global _fasin
global _fatan
global _fceil
global _fexp
global _ffloor
global _ffmod
global _fldexp
global _flog
global _flog10
global _ffpclassify
global _fisfinite
global _fpow
global _fisinf
global _fisnormal
global _fsignbit
global _fisunordered
global _fcopysign
global _fexp2
global _fexpm1
global _filogb
global _fllrint
global _fllround
global _flog1p
global _flog2
global _flogb
global _fnearbyint
global _fremainder
global _fhypot

extern _atanf
extern _atan2
extern _acosf
extern _asinf
extern _expf
extern _ldexpf
extern _logf
extern _log10f
extern _exp2f
extern _expm1f
extern _ilogbf
extern _log1pf
extern _log2f
extern _logbf
extern _nearbyintf

segment .rodata align=16

	NaNAnd0s dd 0x7FFFFFFF, 0, 0, 0
	
	align 16
	twoPow23And0s dd 8388608.0, 0, 0, 0
	
	align 16
	minus0And0s dd -0.0, 0, 0, 0
	
	align 16
	num2 dd 0.49999997, 0, 0, 0
	
	align 16
	weird1 dd 0
	       dq 1.0
		   
	align 16
	oneAnd0s dd 1.0, 0, 0, 0
	one equ oneAnd0s
	
	align 16
	plusInf dd 0x7F800000
	
	align 16
	smallestFlt dd 0x800000
	
	align 16
	fourNaNs dd 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF
	
	align 16
	maxFlt dd 3.40282347E+38
	
	align 16
	fourMinus0 dd -0.0, -0.0, -0.0, -0.0
	
	align 16
	almost0Dot5 dd 0.49999997

segment .text align=16

_fmin:
	minss xmm0, xmm1
	ret
	
	
	
	align 16
_fminAVX:
	vminss xmm0, xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_fmax:
	maxss xmm0, xmm1
	ret
	
	
	
	align 16
_fmaxAVX:
	vmaxss xmm0, xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_ftrunc:
	movss xmm1, [rel NaNAnd0s]
	andps xmm1, xmm0
	movss xmm2, [rel twoPow23And0s]
	comiss xmm2, xmm1
	jbe .return
	
	cvttss2si eax, xmm0
	pxor xmm0, xmm0
	cvtsi2ss xmm0, eax
	
.return:
	ret
	
	



	align 16
_ftruncSSE4:
	roundss xmm0, xmm0, 11
	ret
	
	
	
	align 16
_ftruncAVX:
	vroundss xmm0, xmm0, xmm0, 11
	ret
	
	
	
	align 16
_ftruncAVX512F:
	vrndscaless xmm0, xmm0, xmm0, 11
	ret
	
	
	
	
	
	align 16
_fround:
	movss xmm2, [rel NaNAnd0s]
	movaps xmm1, xmm0
	andps xmm1, xmm2
	movss xmm3, [rel twoPow23And0s]
	comiss xmm3, xmm1
	jbe .return
	
	addss xmm1, [rel almost0Dot5]
	cvttss2si eax, xmm1
	pxor xmm4, xmm4
	cvtsi2ss xmm4, eax
	andnps xmm2, xmm0
	movaps xmm0, xmm2
	orps xmm0, xmm4
	
.return:
	ret
	
	



	align 16
_froundSSE4:
	movaps xmm1, xmm0
	andps xmm1, [rel minus0And0s]
	orps xmm1, [rel num2]
	addss xmm0, xmm1
	roundss xmm0, xmm0, 3
	ret
	
	
	


	align 16
_froundAVX:
	vmovaps xmm1, xmm0
	vandps xmm2, xmm1, [rel minus0And0s]
	vorps xmm3, xmm2, [rel num2]
	vaddss xmm0, xmm0, xmm3
	vroundss xmm0, xmm0, 3
	ret





	align 16
_fabs:
	cvttss2si eax, xmm0
	cdq
	xor eax, edx
	xorps xmm0, xmm0
	sub eax, edx
	cvtsi2ss xmm0, eax
	ret
	
	
	
	align 16
_fabsAVX:
	vcvttss2si eax, xmm0
	vxorps xmm0, xmm0, xmm0
	cdq
	xor eax, edx
	sub eax, edx
	vcvtsi2ss xmm0, xmm0, eax
	ret
	
	
	
	
	
	align 16
_fadd:
	addss xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_fchs:
	xorps xmm0, [rel minus0And0s]
	ret





	align 16
_fdiv:
	pxor xmm2, xmm2
	comiss xmm1, xmm2
	je .return0
	
	divss xmm0, xmm1
	ret
	
.return0:
	pxor xmm0, xmm0
	ret


	
	align 16
_fdivAVX:
	vxorps xmm2, xmm2, xmm2
	vcomiss xmm1, xmm2
	je .return0
	
	vdivss xmm0, xmm0, xmm1
	ret
	
.return0:
	vxorps xmm0, xmm0, xmm0
	ret
	
	
	
	
	
	align 16
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
	movsd xmm0, [rel weird1]
	call _atan2
	cvtsd2ss xmm0, xmm0
	pop rcx
	ret
	
	
	
	
	
	align 16
_fclamp:
	minss xmm0, xmm2
	maxss xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_fsign:
	andps xmm0, [rel oneAnd0s]
	orps xmm0, [rel minus0And0s]
	ret
	
	
	
	
	
	align 16
_fintersect:
	movaps xmm2, xmm0
	subss xmm2, xmm1
	divss xmm0, xmm2
	ret
	
	
	
	align 16
_fintersectAVX:
	vsubss xmm1, xmm0, xmm1
	vdivss xmm0, xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_ftoi:
	cvtss2si eax, xmm0
	ret
	
	
	
	
	
	align 16
_facos:
	jmp _acosf
	
	
	
	
	
	align 16
_fasin:
	jmp _asinf
	
	
	
	
	
	align 16
_fatan:
	jmp _atanf
	
	
	
	
	
	align 16
_fceil:
	movaps xmm1, xmm0
	movss xmm3, [rel NaNAnd0s]
	
	movaps xmm2, xmm0
	andps xmm2, xmm3
	movss xmm4, [rel twoPow23And0s]
	
	ucomiss xmm4, xmm2
	jbe .retXmm1
	
	cvtss2si eax, xmm0
	pxor xmm2, xmm2
	cvtsi2ss xmm2, eax
	
	cmpnless xmm1, xmm2
	movss xmm4, [rel one]
	andps xmm1, xmm4
	addss xmm1, xmm2
	andnps xmm3, xmm0
	orps xmm1, xmm3
	
.retXmm1:
	movaps xmm0, xmm1
	ret
	
	
	
	align 16
_fceilSSE4:
	roundss xmm0, xmm0, 10
	ret
	
	
	
	
	
	align 16
_fexp:
	jmp _expf
	
	
	
	
	
	align 16
_ffloor:
	movss xmm1, [rel NaNAnd0s]
	andps xmm1, xmm0
	
	movss xmm2, [rel twoPow23And0s]
	comiss xmm2, xmm1
	jbe .ret
	
	cvtss2si eax, xmm0
	pxor xmm1, xmm1
	cvtsi2ss xmm1, eax
	
	movaps xmm3, xmm1
	cmpnless xmm3, xmm0
	
	movaps xmm0, xmm3
	movss xmm2, [rel one]
	andps xmm0, xmm2
	subss xmm1, xmm0
	movaps xmm0, xmm1
	
.ret:
	ret
	
	
	
	align 16
_ffloorSSE4:
	roundss xmm0, xmm0, 9
	ret
	
	
	
	
	
	align 16
_ffmod:
	movss [rsp - 4], xmm1
	fld dword [rsp - 4]
	movss [rsp - 4], xmm0
	fld dword [rsp - 4]
	
.loop:
	fprem
	fnstsw ax
	sahf
	jp .loop
	
	fstp st1
	fstp dword [rsp - 4]
	movss xmm0, [rsp - 4]
	ret
	
	
	
	
	
	align 16
_fldexp:
	jmp _ldexpf
	
	
	
	
	
	align 16
_flog:
	jmp _logf
	
	
	
	
	
	align 16
_flog10:
	jmp _log10f
	
	
	
	
	
	align 16
_ffpclassify:
	xorps xmm1, xmm1
	mov eax, 2
	
	ucomiss xmm0, xmm1
	jne .continue
	jp .continue
	
.ret:
	ret
	
	align 16
.continue:
	ucomiss xmm0, xmm0
	jp .ret0
	
	andps xmm0, [rel fourNaNs]
	mov eax, 1
	ucomiss xmm0, [rel plusInf]
	jae .ret
	
	movss xmm1, [rel smallestFlt]
	xor eax, eax
	ucomiss xmm1, xmm0
	setbe al
	add eax, 3
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_fisfinite:
	andps xmm0, [rel fourNaNs]
	ucomiss xmm0, [rel plusInf]
	setne al
	ret
	
	
	
	
	
	align 16
_fpow:
	push rax
	movss [rsp + 4], xmm1
	call _logf
	mulss xmm0, [rsp + 4]
	pop rax
	jmp _expf
	
	
	
	
	
	align 16
_fisinf:
	andps xmm0, [fourNaNs]
	ucomiss xmm0, [plusInf]
	sete al
	ret
	
	
	
	
	
	align 16
_fisnormal:
	andps xmm0, [NaNAnd0s]
	movss xmm1, [maxFlt]
	ucomiss xmm1, xmm0
	setb al
	
	ucomiss xmm0, [smallestFlt]
	setb dl
	
	or eax, edx
	xor eax, 1
	ret
	
	
	
	
	
	align 16
_fsignbit:
	movmskps eax, xmm0
	and eax, 1
	ret
	
	
	
	
	
	align 16
_fisunordered:
	ucomiss xmm1, xmm0
	setp al
	ret
	
	
	
	
	
	align 16
_fcopysign:
	andps xmm1, [rel fourMinus0]
	andps xmm0, [rel fourNaNs]
	orps xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_fexp2:
	jmp _exp2f
	
	
	
	
	
	align 16
_fexpm1:
	jmp _expm1f
	
	
	
	
	
	align 16
_filogb:
	jmp _ilogbf
	
	
	
	
	
	align 16
_fllrint:
	cvtss2si rax, xmm0
	ret
	
	
	
	
	
	align 16
_fllround:
	movss xmm1, [almost0Dot5]
	movss xmm2, [minus0And0s]
	andps xmm2, xmm0
	orps xmm1, xmm2
	addss xmm1, xmm0
	cvttss2si rax, xmm1
	ret
	
	
	
	
	
	align 16
_flog1p:
	jmp _log1pf
	
	
	
	
	
	align 16
_flog2:
	jmp _log2f
	
	
	
	
	
	align 16
_flogb:
	jmp _logbf
	
	
	
	
	
	align 16
_fnearbyint:
	jmp _nearbyintf
	
	
	
	
	
	align 16
_fremainder:
	movss [rsp - 4], xmm1
	fld dword [rsp - 4]
	movss [rsp - 4], xmm1
	fld dword [rsp - 4]
	
.loop:
	fprem1
	fnstsw ax
	test ah, 4
	jne .loop
	
	fstp st1
	fstp dword [rsp - 4]
	movss xmm0, [rsp - 4]
	ret
	
	
	
	
	
	align 16
_fhypot:
	movss xmm3, [NaNAnd0s]
	movaps xmm4, xmm0
	andps xmm4, xmm3
	movaps xmm5, xmm1
	andps xmm5, xmm3
	andps xmm3, xmm2
	
	comiss xmm5, xmm4
	jbe .biggerEqual
	
	maxss xmm3, xmm5
	pxor xmm4, xmm4
	comiss xmm3, xmm4
	je .ret0
	
.notEqual:
	movss xmm4, [one]
	divss xmm4, xmm3
	
	mulss xmm0, xmm4
	mulss xmm1, xmm4
	mulss xmm2, xmm4
	mulss xmm0, xmm0
	mulss xmm1, xmm1
	addss xmm0, xmm1
	mulss xmm2, xmm2
	addss xmm0, xmm2
	sqrtss xmm0, xmm0
	mulss xmm0, xmm3
	ret
	
	align 16
.biggerEqual:
	maxss xmm3, xmm4
	pxor xmm4, xmm4
	comiss xmm3, xmm4
	jne .notEqual
	
.ret0:
	pxor xmm0, xmm0
	ret
	
	
	
	align 16
_fhypotAVX:
	vmovaps xmm5, [fourNaNs]
	vandps xmm4, xmm0, xmm5
	vandps xmm3, xmm1, xmm5
	vandps xmm1, xmm2, xmm5
	
	vmaxss xmm0, xmm1, xmm5
	vmaxss xmm2, xmm1, xmm4
	vcmpltss xmm5, xmm4, xmm3
	vblendvps xmm2, xmm2, xmm0, xmm5
	vxorps xmm0, xmm0
	vucomiss xmm2, xmm0
	je .ret
	
	vmovss xmm0, [one]
	vdivss xmm0, xmm2
	
	vmulss xmm4, xmm0
	vmulss xmm4, xmm4
	
	vmulss xmm3, xmm0
	vmulss xmm3, xmm3
	vaddss xmm3, xmm4, xmm3
	
	vmulss xmm0, xmm1, xmm0
	vmulss xmm0, xmm0
	vaddss xmm0, xmm3, xmm0
	
	vsqrtss xmm0, xmm0
	vmulss xmm0, xmm2
	
.ret:
	ret