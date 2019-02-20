%include "macros.inc"

global _calcPi

segment .rodata align=16

	align 16
	dot5 dd 0.5
	
	align 16
	one dd 1.0
	
	align 16
	four dd 4.0
	
	align 16
	p2222 dd 2, 2, 2, 2
	
	align 16
	p0100 dd 0, 1, 0, 0
	
	align 16
	pHighFlts1Dot75 dd 0, 1.75, 0, 1.75, 0, 1.75, 0, 1.75
	
	align 16
	pHighFlts2Dot25 dd 0, 2.25, 0, 2.25, 0, 2.25, 0, 2.25
	
	align 16
	pHighFlts1Dot875 dd 0, 1.875, 0, 1.875, 0, 1.875, 0, 1.875
	
	align 16
	p4444 dd 4, 4, 4, 4
	
	align 16
	p0123 dd 0, 1, 2, 3

segment .text align=16

	align 16
_calcPi:
	sub esp, 12
	mov edx, [esp + 16]
	
	fld1
	mov [esp + 4], edx
	fidiv dword [esp + 4]
	
	fldz
	test edx, edx
	jle .popAndRet
	
	xor eax, eax
	
.loop:
	fld dword [dot5]
	mov [esp + 4], eax
	fiadd dword [esp + 4]
	fmul st0, st2
	
	fmul st0, st0
	fadd dword [one]
	fdivr dword [four]
	faddp st1, st0
	
	inc eax
	cmp edx, eax
	jne .loop
	
	fmulp st1, st0
	jmp .return
	
	align 16
.popAndRet:
	fstp st1
	
.return:
	add esp, 12
	ret
	
	
	
	align 16
_calcPiSSE2:
	push ebx
	sub esp, 56
	
	pxor xmm2, xmm2
	
	mov eax, [esp + 64]
	test eax, eax
	
	cvtsi2sd xmm2, eax
	movsd xmm1, [pHighFlts1Dot875]
	movaps xmm0, xmm1
	divsd xmm0, xmm2
	
	jle .ret0
	
	cmp eax, 8
	jl .small
	
	mov edx, eax
	movaps xmm3, xmm0
	pxor xmm5, xmm5
	and edx, -8
	
	movdqa xmm6, [p2222]
	movaps xmm7, xmm5
	movdqa xmm4, [p0100]
	xor ecx, ecx
	
	unpcklpd xmm3, xmm3
	movaps xmm2, [pHighFlts1Dot75]
	movsd [esp], xmm0
	
.bigLoop:
	cvtdq2pd xmm0, xmm4
	addpd xmm0, xmm2
	mulpd xmm0, xmm3
	
	mulpd xmm0, xmm0
	movaps [esp + 16], xmm7
	paddd xmm4, xmm6
	movaps xmm7, [pHighFlts1Dot875]
	
	addpd xmm0, xmm7
	movaps xmm1, [pHighFlts2Dot25]
	
	divpd xmm1, xmm0
	addpd xmm5, xmm1
	movaps [esp + 32], xmm5
	add ecx, 8
	
	cvtdq2pd xmm5, xmm4
	addpd xmm5, xmm2
	mulpd xmm5, xmm3
	
	mulpd xmm5, xmm5
	addpd xmm5, xmm7
	movaps xmm0, [pHighFlts2Dot25]
	paddd xmm4, xmm6
	divpd xmm0, xmm5
	
	cvtdq2pd xmm5, xmm4
	addpd xmm5, xmm2
	mulpd xmm5, xmm3
	
	cmp ecx, edx
	mulpd xmm5, xmm5
	addpd xmm5, xmm7
	movaps xmm1, [esp + 16]
	paddd xmm4, xmm6
	addpd xmm1, xmm0
	movaps xmm0, [pHighFlts2Dot25]
	divpd xmm0, xmm5
	movaps [esp + 16], xmm1
	
	cvtdq2pd xmm1, xmm4
	addpd xmm1, xmm2
	mulpd xmm1, xmm3
	
	mulpd xmm1, xmm1
	addpd xmm1, xmm7
	movaps xmm5, [esp + 32]
	paddd xmm4, xmm6
	addpd xmm5, xmm0
	movaps xmm0, [pHighFlts2Dot25]
	divpd xmm0, xmm1
	movaps xmm7, [esp + 16]
	addpd xmm7, xmm0
	jb .bigLoop
	
	addpd xmm5, xmm7
	movaps xmm2, xmm5
	unpckhpd xmm2, xmm5
	movsd xmm0, [esp]
	addsd xmm5, xmm2
	movsd xmm1, [pHighFlts1Dot875]
	
.checkEnd:
	lea ecx, [edx + 1]
	cmp ecx, eax
	ja .returnSumByStep
	
	sub eax, edx
	cmp eax, 2
	jl .doSmall
	
	movd xmm2, ecx
	movd xmm4, edx
	punpckldq xmm4, xmm2
	
	mov ecx, eax
	pxor xmm6, xmm6
	pxor xmm2, xmm2
	punpcklqdq xmm4, xmm6
	movaps xmm6, xmm0
	
	movdqa xmm3, [p2222]
	movsd xmm2, xmm5
	unpcklpd xmm6, xmm6
	xor ebx, ebx
	movaps xmm7, [pHighFlts1Dot75]
	
	and ecx, -2
	movaps xmm5, [pHighFlts2Dot25]
	movsd [esp], xmm0
	
.smallLoop:
	cvtdq2pd xmm0, xmm4
	addpd xmm0, xmm7
	mulpd xmm0, xmm6
	
	mulpd xmm0, xmm0
	addpd xmm0, [pHighFlts1Dot875]
	movaps xmm1, xmm5
	add ebx, 2
	
	divpd xmm1, xmm0
	addpd xmm2, xmm1
	paddd xmm4, xmm3
	cmp ebx, ecx
	jb .smallLoop
	
	movaps xmm3, xmm2
	unpckhpd xmm3, xmm2
	movsd xmm0, [esp]
	addsd xmm2, xmm3
	movsd xmm1, [pHighFlts1Dot875]
	movaps xmm5, xmm2
	
.startOneLoop:
	add edx, ecx
	cmp ecx, eax
	jae .returnSumByStep
	
	movsd xmm2, [pHighFlts1Dot75]
	
.oneLoop:
	pxor xmm3, xmm3
	inc ecx
	cvtsi2sd xmm1, edx
	
	movsd xmm4, [pHighFlts2Dot25]
	inc edx
	cmp ecx, eax
	
	addsd xmm3, xmm2
	mulsd xmm3, xmm0
	
	mulsd xmm3, xmm3
	addsd xmm3, xmm1
	divsd xmm4, xmm3
	addsd xmm5, xmm4
	jb .oneLoop
	jmp .returnSumByStep
	
.ret0:
	pxor xmm5, xmm5
	
.returnSumByStep:
	mulsd xmm0, xmm5
	movsd [esp], xmm0
	fld qword [esp]
	add esp, 56
	pop ebx
	ret
	
.doSmall:
	xor ecx, ecx
	jmp .startOneLoop
	
.small:
	xor edx, edx
	pxor xmm5, xmm5
	jmp .checkEnd
	
	
	
	align 16
_calcPiAVX:
	sub esp, 12
	vxorpd xmm0, xmm0
	mov ecx, [esp + 16]
	vcvtsi2sd xmm0, ecx
	vmovsd xmm1, [pHighFlts1Dot875]
	vdivsd xmm0, xmm1, xmm0
	
	test ecx, ecx
	jle .ret0
	
	cmp ecx, 4
	jl .small
	
	vunpcklpd xmm2, xmm0, xmm0
	
	mov eax, ecx
	vmovsd [esp], xmm0
	and eax, -4
	vmovdqu xmm6, [p0123]
	xor edx, edx
	
	vxorpd ymm3, ymm3, ymm3
	vmovupd ymm5, [pHighFlts1Dot75]
	vmovdqu xmm0, [p4444]
	vmovupd ymm4, [pHighFlts2Dot25]
	vinsertf128 ymm7, ymm2, xmm2, 1
	vmovupd ymm2, [pHighFlts1Dot875]
	
.bigLoop:
	vcvtdq2pd ymm1, xmm6
	vpaddd xmm6, xmm6, xmm0
	vaddpd ymm1, ymm5, ymm1
	vmulpd ymm1, ymm7, ymm1
	
	add edx, 4
	
	vmulpd ymm1, ymm1
	vaddpd ymm1, ymm2, ymm1
	vdivpd ymm1, ymm4, ymm1
	vaddpd ymm5, ymm3, ymm1
	
	cmp edx, eax
	jb .bigLoop
	
	vextractf128 xmm2, ymm3, 1
	vmovsd xmm0, [esp]
	vmovsd xmm1, [pHighFlts2Dot25]
	vaddpd xmm4, xmm3, xmm2
	vunpckhpd xmm5, xmm4
	vaddsd xmm2, xmm4, xmm5
	
.checkEnd:
	cmp eax, ecx
	jae .returnSumByStep
	
	vmovsd xmm3, [pHighFlts1Dot75]
	vmovsd xmm4, [pHighFlts2Dot25]
	
.smallLoop:
	vxorpd xmm5, xmm5
	vcvtsi2sd xmm5, eax
	inc eax
	
	vaddsd xmm6, xmm3, xmm5
	vmulsd xmm7, xmm0, xmm6
	
	vmulsd xmm5, xmm7, xmm7
	vaddsd xmm6, xmm1, xmm5
	vdivsd xmm7, xmm4, xmm6
	vaddsd xmm2, xmm2, xmm7
	
	cmp eax, ecx
	jb .smallLoop
	jmp .returnSumByStep
	
.ret0:
	vxorpd xmm2, xmm2
	
.returnSumByStep:
	vmulsd xmm0, xmm2
	vmovsd [esp], xmm0
	fld qword [esp]
	vzeroupper
	add esp, 12
	ret
	
.small:
	xor eax, eax
	vxorpd xmm2, xmm2
	jmp .checkEnd