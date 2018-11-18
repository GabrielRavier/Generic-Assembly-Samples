global _fmin
global _fmax
global _ftrunc
global _fround
global _fabs
global _fadd
global _fchs
global _fdiv
global _fatan
global _fpatan
global _fclamp
global _fsign
global _fintersect
global _ftoi
global _facos
global _fasin
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
global _fisnan
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

segment .rodata
	
	align 16
	maxInt dd 0x80000000
	
	align 16
	num1 dd 8388608.0
	
	align 16
	one dd 1.0
	
	align 16
	minusZeroPoint5 dd -0.5
	
	align 16
	zeroPoint5 dd 0.5
	
	align 16
	onePoint5 dd 1.5
	
	align 16
	fourMinus0 dd -0.0, -0.0, -0.0, -0.0
	minus0 equ fourMinus0
	
	align 16
	plusInf dd 0x7F800000
	
	align 16
	plusInfMin1 dd 0x7F7FFFFF
	
	align 16
	fltMin dd 0x800000
	
	align 16
	fourNaNs dd 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF
	NaN equ fourNaNs

segment .text align=16

_fmin:
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
	
	
	
	align 16
_fmini686:
	fld dword [esp + 4]
	fld dword [esp + 8]
	
	fcom
	fnstsw ax
	sahf
	fcmovnbe st0, st1
	
	fstp st1
	ret
	
	
	
	align 16
_fminSSE:
	sub esp, 12
	
	movss xmm0, dword [esp + 16]
	
	minss xmm0, dword [esp + 20]
	movss dword [esp], xmm0
	fld dword [esp]
	
	add esp, 12
	ret
	
	
	
	align 16
_fminAVX:
	sub esp, 12
	
	vmovss xmm0, dword [esp + 16]
	
	vminss xmm0, xmm0, dword [esp + 20]
	vmovss dword [esp], xmm0
	fld dword [esp]
	
	add esp, 12
	ret
	
	
	
	
	
	align 16
_fmax:
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
	
	
	
	align 16
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
	
	
	
	align 16
_fmaxSSE:
	sub esp, 12
	
	movss xmm0, dword [esp + 16]
	
	maxss xmm0, dword [esp + 20]
	movss dword [esp], xmm0
	
	fld dword [esp]
	add esp, 12
	ret
	
	
	
	align 16
_fmaxAVX:
	sub esp, 12
	
	vmovss xmm0, dword [esp + 16]
	
	vmaxss xmm0, xmm0, dword [esp + 20]
	vmovss dword [esp], xmm0
	
	fld dword [esp]
	add esp, 12
	ret
	
	
	
	
	
	align 16
_ftrunc:
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
	
	
	
	align 16
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
	
	movss xmm1, dword [one]
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
	
	movss xmm1, dword [one]
	cmpnless xmm4, xmm3
	andps xmm4, xmm1
	subss xmm0, xmm4
	
.return:
	movss dword [esp], xmm0
	fld dword [esp]
	add esp, 12
	ret
	
	
	
	align 16
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
	
	

	align 16
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

	
	
	
	
	align 16
_fround:
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
	
	
	
	align 16
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
	
	
	
	align 16
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
	
	
	
	align 16
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
	
segment .rodata align=16

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
	
	
	
	align 16
_fabsAVX:
	sub esp, 4
	
	vmovss xmm0, dword [esp + 8]
	vandps xmm0, xmm0, [xmmDat]
	vmovss dword [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
	
	
	align 16
_fadd:
	fld dword [esp + 4]
	fadd dword [esp + 8]
	ret
	
	
	
	align 16
_faddSSE:
	sub esp, 12
	
	movss xmm0, [esp + 16]
	addss xmm0, [esp + 20]
	movss [esp], xmm0
	
	fld dword [esp]
	add esp, 12
	ret
	
	
	
	align 16
_faddAVX:
	sub esp, 4
	
	vmovss xmm0, [esp + 12]
	vaddss xmm0, xmm0, [esp + 8]
	
	vmovss [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
	
	
	align 16
_fchs:
	fld dword [esp + 4]
	fchs
	ret
	
	
	
segment .rodata align=16

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
	
	
	
	align 16
_fchsAVX:
	sub esp, 4
	
	vmovss xmm0, [esp + 4]
	vxorps xmm0, xmm0, [xmmDat2]
	
	vmovss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
	
	
	align 16
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
	
	
	
	align 16
_fdivMMX:
	fld dword [esp + 8]
	fldz
	fcomip st0, st1
	je .ret0
	
	fld dword [esp + 4]
	fdivrp st1, st0
	ret
	
	align 16
.ret0:
	fstp st0
	fldz
	ret
	
	
	
	align 16
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
	
	
	
	align 16
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
	
	
	
	
	
	align 16
_fatan:
	fld dword [esp + 4]
	fld1
	fpatan
	ret
	
	
	
	
	
	align 16
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
	
	align 16
.ret0:
	fstp st0
	fldz
	ret
	
	
	
	
	
	align 16
_fclamp:
	fld dword [esp + 4]
	fld dword [esp + 8]
	fld dword [esp + 12]
	fcom st2
	fnstsw ax
	sahf
	ja .above
	
	fst st2
	
.above:
	fstp st0
	fcom
	fnstsw ax
	sahf
	fxch st1
	ja .above2
	
	fst st1
	
.above2:
	fstp st0
	ret
	
	
	
	align 16
_fclampi686:
	fld dword [esp + 8]
	fld dword [esp + 12]
	fld dword [esp + 4]
	
	fucomi st1
	fxch st1
	fcmovbe st0, st1
	fstp st1
	
	fucomi st1
	fcmovb st0, st1
	fstp st1
	ret
	
	
	
	align 16
_fclampSSE:
	push eax
	movss xmm0, [esp + 8]
	minss xmm0, [esp + 16]
	maxss xmm0, [esp + 12]
	movss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
	align 16
_fclampAVX:
	push eax
	vmovss xmm0, [esp + 8]
	vminss xmm0, xmm0, [esp + 16]
	vmaxss xmm0, xmm0, [esp + 12]
	vmovss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
	
	
	align 16
_fsign:
	fld dword [esp + 4]
	fldz
	fucompp
	fnstsw ax
	sahf
	fld1
	fld st0
	fchs
	ja .above
	
	fstp st0
	fldz
	fxch st1
	
.above:
	fstp st1
	ret
	
	
	
	align 16
_fsigni686:
	fld dword [esp + 4]
	fldz
	fucomp st1
	fstp st1
	fld1
	fld st0
	fchs
	fxch st1
	fcmovnbe st0, st1
	fstp st1
	ret
	
	
	
segment .rodata 
	
	align 16

	fltChoice dd 1.0, -1.0
	
segment .text align=16

_fsignSSE:
	xorps xmm0, xmm0
	xor eax, eax
	ucomiss xmm0, [esp + 4]
	seta al
	
	fld dword [fltChoice + eax * 4]
	ret
	
	
	
	
	
	align 16
_fsignAVX:
	vxorps xmm0, xmm0, xmm0
	xor eax, eax
	vucomiss xmm0, [esp + 4]
	seta al
	fld dword [fltChoice + eax * 4]
	ret
	
	
	
	
	
	align 16
_fintersect:
	fld dword [esp + 4]
	fsub dword [esp + 8]
	fdivr dword [esp + 4]
	ret
	
	
	
	align 16
_fintersectSSE:
	push eax
	movss xmm0, [esp + 8]
	movaps xmm1, xmm0
	subss xmm1, [esp + 12]
	divss xmm0, xmm1
	movss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
	align 16
_fintersectAVX:
	push eax
	vmovss xmm0, [esp + 8]
	vsubss xmm1, xmm0, [esp + 12]
	vdivss xmm0, xmm0, xmm1
	vmovss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
	
	
	align 16
_ftoi:
	sub esp, 8

	fnstcw [esp + 6]
	fld dword [esp + 12]
	movzx eax, word [esp + 6]
	or ah, 12
	mov [esp + 4], ax
	fldcw [esp + 4]
	fistp dword [esp]
	fldcw [esp + 6]
	mov eax, [esp]
	add esp, 8
	ret
	
	
	
	align 16
_ftoiSSE:
	cvttss2si eax, [esp + 4]
	ret
	
	
	
	
	
	align 16
_facos:
	fld dword [esp + 4]
	fld st0
	
	fmul st0, st1
	fsubr dword [one]
	fsqrt
	fxch st1
	fpatan
	ret
	
	
	
	
	
	align 16
_fasin:
	fld dword [esp + 4]
	fld st0
	
	fmul st0, st1
	fsubr dword [one]
	fsqrt
	fpatan
	ret
	
	

	
	
	align 16
_fceil:
	push eax
	fnstcw [esp + 2]
	mov ax, [esp + 2]
	and ah, -13
	or ah, 8
	mov [esp], ax
	fld dword [esp + 8]
	fldcw [esp]
	frndint
	fldcw [esp + 2]
	pop edx
	ret
	
	
	
	align 16
_fceilSSE4:
	sub esp, 4
	roundss xmm0, [esp + 8], 10
	movss [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
	
	
segment .rodata align=16

	expData dd 0x5C17F0BC, 0xB8AA3B29, 0x3FFF
	
segment .text align=16

_fexp:
	fld tword [expData]
	fmul dword [esp + 4]
	fld st0
	frndint
	fsub st1, st0
	fxch st1
	f2xm1
	fadd dword [one]
	fscale
	fstp st1
	ret
	
	
	
	align 16
_fexpi686:
	fldl2e
	fmul dword [esp + 4]
	fld st0
	frndint
	fsub st1, st0
	fxch st1
	f2xm1
	fadd dword [one]
	fscale
	fstp st1
	ret
	
	
	
	
	
	align 16
_ffloor:
	push eax
	fnstsw [esp + 2]
	mov ax, [esp + 2]
	and ah, -13
	or ah, 4
	mov [esp], ax
	fld dword [esp + 8]
	fldcw [esp]
	frndint
	fldcw [esp + 2]
	pop edx
	ret
	
	
	
	align 16
_ffloorSSE:
	sub esp, 12
	movss xmm2, [esp + 16]
	movss xmm3, [minus0]
	xorps xmm0, xmm3
	movss xmm4, [num1]
	cmpltss xmm0, xmm1
	andps xmm1, xmm0
	orps xmm1, xmm3
	addss xmm6, xmm1
	subss xmm6, xmm1
	movaps xmm5, xmm6
	subss xmm5, xmm2
	cmpnless xmm5, xmm3
	andps xmm5, xmm4
	subss xmm6, xmm5
	movss [esp], xmm6
	fld dword [esp]
	add esp, 12
	ret
	
	
	
	align 16
_ffloorSSE4:
	sub esp, 4
	roundss xmm0, [esp + 8], 9
	movss [esp], xmm0
	fld dword [esp]
	add esp, 4
	ret
	
	
	
	
	
	align 16
_ffmod:
	fld dword [esp + 8]
	fld dword [esp + 4]
	
.loop:
	fprem
	fnstsw ax
	test ah, 4
	jne .loop
	
	fstp st1
	ret
	
	
	
	
	
	align 16
_fldexp:
	fld dword [esp + 4]
	fild dword [esp + 8]
	fxch st1
	fscale
	fstp st1
	ret
	
	
	
	
	
	align 16
_flog:
	fldln2
	fld dword [esp + 4]
	fyl2x
	ret
	
	
	
	
	
	align 16
_flog10:
	fldlg2
	fld dword [esp + 4]
	fyl2x
	ret
	
	
	
	
	
	align 16
_ffpclassify:
	fld dword [esp + 4]
	fldz
	fucomp st1
	fnstsw ax
	mov ecx, 2
	sahf
	je .popAndRetEcx
	
	fabs
	fld dword [plusInf]
	fxch st1
	fucom st1
	fstp st1
	mov ecx, 1
	sahf
	jne .continue
	
.popAndRetEcx:
	fstp st0
	mov eax, ecx
	ret
	
.continue:
	fld dword [fltMin]
	fxch st1
	fucompp
	fnstsw ax
	xor eax, ecx
	sahf
	setae cl
	add ecx, 3
	fldz
	fstp st0
	mov eax, ecx
	ret
	
	
	
	align 16
_ffpclassifyi686:
	fld dword [esp + 4]
	mov eax, 2
	fldz
	fucomp st3
	je .popAndRet
	
	fabs
	mov eax, 1
	fld dword [plusInf]
	fxch st1
	fucomi st1
	fstp st1
	jmp .continue
	
.popAndRet:
	fstp st0
	ret
	
.continue:
	fld dword [plusInf]
	xor eax, eax
	fxch st1
	fucomp st1
	fstp st0
	setae al
	add eax, 3
	fldz
	fstp st0
	ret
	
	
	
_ffpclassifySSE2:
	movss xmm0, [esp + 4]
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
	
	andps xmm0, [fourNaNs]
	mov eax, 1
	ucomiss xmm0, [plusInf]
	jae .ret
	
	movss xmm1, [fltMin]
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
	fld dword [esp + 4]
	fabs
	fld dword [plusInf]
	fucompp
	fnstsw ax
	test ah, 1
	sete al
	ret
	
	
	
	align 16
_fisfinitei686:
	fld dword [esp + 4]
	fabs
	fld dword [plusInf]
	fucomip st0, st1
	fstp st0
	setnb al
	ret
	
	
	
	align 16
_fisfiniteSSE:
	movss xmm0, [esp + 4]
	andps xmm0, [fourNaNs]
	ucomiss xmm0, [plusInf]
	setne al
	ret
	
	
	
	
	
	align 16
_fpow:
	fldln2
	fld dword [esp + 4]
	fyl2x
	
	fmul dword [esp + 8]
	
	fldl2e
	fmulp st1, st0
	fld st0
	frndint
	fsub st1, st0
	fxch st1
	f2xm1
	fadd dword [one]
	fscale
	fstp st1
	ret
	
	
	
	
	
	align 16
_fisinf:
	push eax
	fld dword [esp + 8]
	fstp dword [esp]
	fld dword [esp]
	fxam
	fnstsw ax
	fstp st0
	and ah, 0x45
	cmp ah, 5
	sete al
	pop edx
	ret
	
	
	
	align 16
_fisinfSSE:
	movss xmm0, [esp + 4]
	andps xmm0, [fourNaNs]
	ucomiss xmm0, [plusInf]
	sete al
	ret
	
	
	
	
	
	align 16
_fisnan:
	fld dword [esp + 4]
	fucomp st0
	fnstsw ax
	test ah, 4
	setne al
	ret
	
	
	
	align 16
_fisnani686:
	fld dword [esp + 4]
	fucomip st0, st0
	setp al
	ret
	
	
	
	align 16
_fisnanSSE:
	movss xmm0, [esp + 4]
	ucomiss xmm0, xmm0
	setp al
	ret
	
	
	
	
	
	align 16
_fisnormal:
	fld dword [esp + 4]
	fabs
	fld dword [plusInfMin1]
	fucomp st1
	fnstsw ax
	test ah, 1
	setne dl
	
	fld dword [fltMin]
	fxch st1
	fucompp
	fnstsw ax
	test ax, 1
	setne al
	
	or al, dl
	xor al, 1
	ret
	
	
	
	align 16
_fisnormali686:
	fld dword [esp + 4]
	fabs
	
	fld dword [plusInfMin1]
	fucomip st0, st1
	
	fld dword [fltMin]
	fxch st1
	setb al
	
	fucomip st0, st1
	fstp st0
	setb dl
	
	or al, dl
	xor al, 1
	ret
	
	
	
	align 16
_fisnormalSSE:
	movss xmm0, [esp + 4]
	ucomiss xmm0, xmm0
	setnp cl
	
	andps xmm0, [fourNaNs]
	ucomiss xmm0, [plusInf]
	setb dl
	
	movss xmm1, [fltMin]
	ucomiss xmm1, xmm0
	setbe al
	
	and al, dl
	and al, cl
	ret
	
	
	
	
	
	align 16
_fsignbit:
	mov eax, [esp + 4]
	shr eax, 31
	ret
	
	
	
	align 16
_fisunordered:
	fld dword [esp + 4]
	fld dword [esp + 8]
	fucompp
	fnstsw ax
	
	test ah, 4
	setne al
	ret
	
	
	
	align 16
_fisunorderedi686:
	fld dword [esp + 4]
	fld dword [esp + 8]
	fucomip st0, st1
	fstp st0
	setp al
	ret
	
	
	
	align 16
_fisunorderedSSE:
	movss xmm0, [esp + 4]
	ucomiss xmm0, [esp + 8]
	setp al
	ret
	
	
	
	
	
	align 16
_fcopysign:
	fld dword [esp + 4]
	fxam
	fnstsw ax
	fstp st0
	fld dword [esp + 8]
	fabs
	
	test ah, 2
	je .noInverse
	
	fchs
	
.noInverse:
	ret
	
	
	
	align 16
_fcopysignSSE:
	push eax
	movss xmm0, [esp + 8]
	movss xmm1, [esp + 12]
	
	andps xmm1, [fourMinus0]
	andps xmm0, [fourNaNs]
	
	orps xmm0, xmm1
	
	movss [esp], xmm0
	fld dword [esp]
	pop eax
	ret
	
	
	
	
	
	align 16
_fexp2:
	fld dword [esp + 4]
	fld st0
	frndint
	fsub st1, st0
	fxch st1
	f2xm1
	fadd dword [one]
	fscale
	fstp st1
	ret
	
	
	
	
	
	align 16
_fexpm1:
	fldl2e
	fmul dword [esp + 4]
	
	fld st0
	frndint
	fsub st1, st0
	
	fld1
	fxch st2
	f2xm1
	fscale
	fxch st2
	fscale
	fstp st1
	
	fsub dword [one]
	faddp st1, st0
	ret
	
	
	
	
	
	align 16
_filogb:
	sub esp, 8
	fnstcw [esp + 6]
	fld dword [esp + 12]
	fxtract
	fstp st0
	
	movzx eax, word [esp + 6]
	or ax, 0xC00
	mov [esp + 4], ax
	
	fldcw [esp + 4]
	fistp dword [esp]
	fldcw [esp + 6]
	
	mov eax, [esp]
	add esp, 8
	ret
	
	
	
	
	
	align 16
_fllrint:
	sub esp, 12
	
	fld dword [esp + 16]
	fistp qword [esp]
	
	mov eax, [esp]
	mov edx, [esp + 4]
	add esp, 12
	ret
	
	
	
	
	
	align 16
_fllround:
	sub esp, 20
	fld dword [esp + 24]
	fxam
	fnstsw ax
	
	mov ecx, eax
	fabs
	fadd dword [zeroPoint5]

	fnstcw [esp + 14]
	mov dx, [esp + 14]
	and dh, -0xD
	or dh, 4
	mov [esp + 12], dx
	
	fldcw [esp + 12]
	fistp qword [esp]
	fldcw [esp + 14]
	
	mov eax, [esp]
	mov edx, [esp + 4]
	and ch, 2
	je .return
	
	neg eax
	adc edx, 0
	neg edx
	
.return:
	add esp, 20
	ret
	
	
	
	
	
segment .rodata align=16

	log1pDat1 dd 0xC4336F8, 0x95F61998, 0x3FFD
	
	align 16
	log1pDat2 dd 0xD1CF79AC, 0xB17217F7, 0x3FFE
	
segment .text align=16

_flog1p:
	fld dword [esp + 4]
	fld st0
	fabs
	
	fld tword [log1pDat1]
	fxch st1
	fcompp
	fnstsw ax
	test ah, 5
	je .norm
	
	fld tword [log1pDat2]
	fxch st1
	fyl2xp1
	ret
	
	align 16
.norm:
	fld1
	faddp st1, st0
	fld tword [log1pDat2]
	fxch st1
	fyl2x
	ret
	
	
	
	align 16
_flog1p:
	fld dword [esp + 4]
	fabs
	fld tword [log1pDat1]
	fxch st1
	fcomip st0, st1
	fstp st0
	jnb .norm
	
	fldln2
	fld dword [esp + 4]
	fyl2xp1
	ret
	
	align 16
.norm:
	fld1
	fadd dword [esp + 4]
	fldln2
	fxch st1
	fyl2x
	ret
	
	
	
	
	
	align 16
_flog2:
	fld1
	fld dword [esp + 4]
	fyl2x
	ret
	
	
	
	
	
	align 16
_flogb:
	fld dword [esp + 4]
	fxtract
	fstp st0
	ret
	
	
	
	
	
	align 16
_fnearbyint:
	sub esp, 4
	fnstcw [esp + 2]
	fld dword [esp + 8]
	movzx eax, word [esp + 2]
	or ax, 0x20
	mov [esp], ax
	fldcw [esp]
	frndint
	fclex
	fldcw [esp + 2]
	pop eax
	ret
	
	
	
	
	
	align 16
_fremainder:
	fld dword [esp + 8]
	fld dword [esp + 4]
	
.loop:
	fprem1
	fnstsw ax
	sahf
	jp .loop
	
	fstp st1
	ret
	
	
	
	
	
	align 16
_fhypot:
	fld dword [esp + 4]
	fld dword [esp + 8]
	fld dword [esp + 12]
	
	fld st2
	fabs
	
	fld st2
	fabs
	
	fld st2
	fabs
	
	fxch st2
	fcom st1
	fnstsw ax
	test ah, 1
	je .yup
	
	fstp st0
	fld st0
	fcomp st2
	fnstsw ax
	test ah, 5
	jne .nope
	
	fstp st1
	jmp .continue
	
.yup2:
	fstp st1
	
.continue:
	ftst
	fnstsw ax
	test ah, 64
	jne .nope2
	
	fld1
	fdiv st0, st1
	fmul st4, st0
	fmul st3, st0
	fmulp st2, st0
	fxch st3
	fmul st0, st0
	fxch st2
	fmul st0, st0
	faddp st2, st0
	fmul st0, st0
	faddp st1, st0
	fsqrt
	fmulp st1, st0
	ret
	
.yup:
	fstp st1
	fcom st1
	fnstsw ax
	test ah, 5
	je .yup2
	
	fstp st0
	jmp .continue
	
.nope:
	fstp st0
	jmp .continue
	
.nope2:
	fstp st0
	fstp st0
	fstp st0
	fstp st0
	fldz
	ret
	
	
	
	align 16
_fhypoti686:
	fld dword [esp + 4]
	fabs
	
	fld dword [esp + 8]
	fabs
	
	fld dword [esp + 12]
	fabs
	
	fxch st1
	fcomi st0, st2
	jbe .biggerEqual
	
	fstp st2
	fxch st1
	fcomi st0, st1
	fcmovb st0, st1
	fstp st1
	fldz
	fcomip st0, st1
	je .equal
	
.L13:
	fld1
	fdiv st0, st1
	fld dword [esp + 4]