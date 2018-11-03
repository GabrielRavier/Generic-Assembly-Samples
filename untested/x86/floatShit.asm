global _fmin	; float fmin(float a1, float a2)
global _fmax	; float fmax(float a1, float a2)
global _ftrunc	; float ftrunc(float a1)
global _fround	; float fround(float a1)
global _fabs	; float fabs(float a1)
global _fadd	; float fadd(float x, float y)
global _fchs	; float fchs(float x)
global _fdiv	; float fdiv(float x, float y)
global _fatan	; float fatan(float x, float y)
global _fpatan	; float fpatan(float x, float y)

segment .rodata
	
	align 4
	maxInt dd 0x80000000
	align 4
	num1 dd 0x4b000000
	align 4
	num2 dd 0x3f800000
	align 4
	minusZeroPoint5 dd -0.5
	align 4
	zeroPoint5 dd 0.5
	

segment .text align=16

_fmini386:
	fld dword [esp + 4]
	fld dword [esp + 8]
	
	fcom
	fnstsw ax
	sahf
	ja .noU
	
	fst st1
	
.noU:
	fstp st0
	ret
	
	
	
_fmini686:
	fld dword [esp + 4]
	fld dword [esp + 8]
	
	fcom
	fnstsw ax
	sahf
	fcmovnbe st0, st1
	
	fstp st1
	ret
	
	
	
_fminSSE:
	sub esp, 12
	
	movss xmm0, dword [esp + 16]
	
	minss xmm0, dword [esp + 20]
	movss dword [esp], xmm0
	fld dword [esp]
	
	add esp, 12
	ret
	
	
	
_fminAVX:
	sub esp, 12
	
	vmovss xmm0, dword [esp + 16]
	
	vminss xmm0, xmm0, dword [esp + 20]
	vmovss dword [esp], xmm0
	fld dword [esp]
	
	add esp, 12
	ret
	
	
	
	
	
_fmaxi386:
	fld dword [esp + 4]
	fld dword [esp + 8]
	
	fcom
	fnstsw ax
	sahf
	jp .yup
	jb .nope
	
.yup:
	fst st1
	
.nope:
	fstp st0
	ret
	
	
	
_fmaxi686:
	fld dword [esp + 4]
	fld dword [esp + 8]
	
	fxch st1
	fcom
	fnstsw ax
	sahf
	fcmovbe st0, st1
	
	fstp st1
	ret
	
	
	
_fmaxSSE:
	sub esp, 12
	
	movss xmm0, dword [esp + 16]
	
	maxss xmm0, dword [esp + 20]
	movss dword [esp], xmm0
	
	fld dword [esp]
	add esp, 12
	ret
	
	
	
_fmaxAVX:
	sub esp, 12
	
	vmovss xmm0, dword [esp + 16]
	
	vmaxss xmm0, xmm0, dword [esp + 20]
	vmovss dword [esp], xmm0
	
	fld dword [esp]
	add esp, 12
	ret
	
	
	
	
	
_ftrunci386:
	sub esp, 12
	
	fldz
	
	fld dword [esp + 16]
	
	fxch st1
	fcomp
	fnstsw ax
	sahf
	jbe .above0
	
	fld st0
	frndint
	fcom st1
	fnstsw ax
	sahf
	fstp st1
	jnb .noAdd
	
	fld1
	faddp st1, st0
	
.noAdd:
	jmp .return
	
.above0:
	fld st0
	frndint
	fcom st1
	fnstsw ax
	sahf
	fstp st1
	jna .return
	
	fld1
	fsubp st1, st0
	
.return:
	add esp, 12
	ret
	
	
	
_ftruncSSE:
	sub esp, 12
	
	movss xmm1, dword [esp + 16]
	
	xorps xmm0, xmm0
	comiss xmm0, xmm1
	jbe .above0
	
	movss xmm3, dword [maxInt]
	movaps xmm0, xmm1
	andps xmm3, xmm1
	
	movss xmm2, dword [num1]
	xorps xmm0, xmm3
	cmpltss xmm0, xmm2
	andps xmm2, xmm0
	movaps xmm0, xmm1
	orps xmm2, xmm3
	addss xmm0, xmm2
	subss xmm0, xmm2
	movaps xmm4, xmm0
	subss xmm4, xmm1
	
	movss xmm1, dword [num2]
	cmpltss xmm4, xmm3
	andps xmm4, xmm1
	addss xmm0, xmm4
	jmp .return
	
.above0:
	movss xmm3, dword [maxInt]
	movaps xmm0, xmm1
	andps xmm3, xmm1
	
	movss xmm2, dword [num1]
	xorps xmm0, xmm3
	cmpltss xmm0, xmm2
	andps xmm2, xmm0
	movaps xmm0, xmm1
	orps xmm2, xmm3
	addss xmm0, xmm2
	subss xmm0, xmm2
	movaps xmm4, xmm0
	subss xmm4, xmm1
	
	movss xmm1, dword [num2]
	cmpnless xmm4, xmm3
	andps xmm4, xmm1
	subss xmm0, xmm4
	
.return:
	movss dword [esp], xmm0
	fld dword [esp]
	add esp, 12
	ret
	
	
	
_ftruncSSE4:
	sub esp, 12
	
	movss xmm1, dword [esp + 16]
	
	xorps xmm0, xmm0
	comiss xmm0, xmm1
	jbe .above0
	
	roundss xmm0, xmm1, 2
	jmp .return
	
.above0:
	roundss xmm0, xmm1, 1
	
.return:
	movss dword [esp], xmm0
	fld dword [esp]
	add esp, 12
	ret
	
	

_ftruncAVX:
	sub esp, 12
	
	vmovss xmm1, dword [esp + 16]
	
	vxorps xmm0, xmm0
	vcomiss xmm0, xmm1
	jbe .above0
	
	vroundss xmm0, xmm1, 2
	jmp .return
	
.above0:
	vroundss xmm0, xmm1, 1
	
.return:
	vmovss dword [esp], xmm0
	fld dword [esp]
	add esp, 12
	ret

	
	
	
	
_froundi386:
	fld dword [esp + 4]
	
	fld dword [minusZeroPoint5]
	fcomp
	fnstsw ax
	sahf
	jae .return
	
	fcom dword [zeroPoint5]
	fnstsw ax
	sahf
	jae .return
	
	fstp st0
	
	fldz
	
.return:
	ret
	
	
	
_froundSSE:
	sub esp, 12
	
	movss xmm1, dword [esp + 16]
	
	movss xmm0, dword [minusZeroPoint5]
	comiss xmm0, xmm1
	jae .return
	
	comiss xmm1, dword [zeroPoint5]
	jae .return
	
	xorps xmm1, xmm1
	
.return:
	movss dword [esp], xmm1
	fld dword [esp]
	add esp, 12
	ret
	
	
	
_froundAVX:
	sub esp, 12
	
	vmovss xmm1, dword [esp + 16]
	
	vmovss xmm0, dword [minusZeroPoint5]
	vcomiss xmm0, xmm1
	jae .return
	
	vcomiss xmm1, dword [zeroPoint5]
	jae .return
	
	vxorps xmm1, xmm1, xmm1
	
.return:
	vmovss dword [esp], xmm1
	fld dword [esp]
	add esp, 12
	ret
	
	
	
	
	
_fabs:
	fld dword [esp + 4]
	fabs
	ret
	
	
	
_fabsSSE:
	sub esp, 12
	xorps xmm0, xmm0
	cvttss2si eax, [esp + 16]
	cdq
	xor eax, edx
	sub eax, edx
	cvtsi2ss xmm0, eax
	movss dword [esp], xmm0
	fld dword [esp]
	add esp, 12
	ret
	
segment .rodata align=4

	xmmDat dq 0x7FFFFFFF, 0
	
segment .text align=16
	
_fabsSSE2:
	sub esp, 4
	movss xmm0, [esp + 8]
	andps xmm0, [xmmDat]
	movss dword [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
_fabsAVX:
	sub esp, 4
	
	vmovss xmm0, dword [esp + 8]
	vandps xmm0, xmm0, [xmmDat]
	vmovss dword [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
	
	
_fadd:
	fld dword [esp + 4]
	fadd dword [esp + 8]
	ret
	
	
	
_faddSSE:
	sub esp, 12
	
	movss xmm0, [esp + 16]
	addss xmm0, [esp + 20]
	movss [esp], xmm0
	
	fld dword [esp]
	add esp, 12
	ret
	
	
	
_faddAVX:
	sub esp, 4
	
	vmovss xmm0, [esp + 12]
	vaddss xmm0, xmm0, [esp + 8]
	
	vmovss [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
	
	
_fchs:
	fld dword [esp + 4]
	fchs
	ret
	
	
	
segment .rodata align=4

	xmmDat2 dd -0.0, -0.0, -0.0, -0.0
	
segment .text align=16

_fchsSSE:
	push eax
	
	movss xmm0, [esp + 4]
	xorps xmm0, [xmmDat2]
	
	movss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
_fchsAVX:
	sub esp, 4
	
	vmovss xmm0, [esp + 4]
	vxorps xmm0, xmm0, [xmmDat2]
	
	vmovss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
	
	
_fdiv:
	fld dword [esp + 48]
	
	ftst
	fnstsw ax
	test ah, 0x40
	jne .ret0
	
	fdivr dword [esp + 4]
	ret
	
.ret0:
	fstp st0
	fldz
	ret
	
	
	
_fdivMMX:
	fld dword [esp + 8]
	fldz
	fcomip st0, st1
	je .ret0
	
	fld dword [esp + 4]
	fdivrp st1, st0
	ret
	
.ret0:
	fstp st0
	fldz
	ret
	
	
	
_fdivSSE:
	push eax
	movss xmm1, [esp + 4 + 8]
	xorps xmm0, xmm0
	ucomiss xmm0, xmm1
	je .return
	
	movss xmm0, [esp + 4 + 4]
	divss xmm0, xmm1
	
.return:
	movss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
_fdivAVX:
	sub esp, 4
	vxorps xmm0, xmm0, xmm0
	vmovss xmm1, [esp + 4 + 8]
	vcomiss xmm1, xmm0
	je .return
	
	vmovss xmm0, [esp + 4 + 4]
	vdivss xmm0, xmm0, xmm1
	
.return:
	vmovss [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
	
	
_fatan:
	fld dword [esp + 4]
	fld1
	fpatan
	ret
	
	
	
	
	
_fpatan:
	fld dword [esp + 4]
	
	ftst
	fnstsw ax
	test ah, 0x40
	jne .ret0
	
	fdivr dword [esp + 8]
	fld1
	fpatan
	ret
	
.ret0:
	fstp st0
	fldz
	ret