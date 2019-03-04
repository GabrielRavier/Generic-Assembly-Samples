global _calcPi

segment .rodata align=16

	oneDot75 dd 0, 1.75
	
	align 16
	oneDot875 dd 0, 1.875
	
	align 16
	twoDot25 dd 0, 2.25
	
	align 16
	four1Dot75 dd 0, 1.75, 0, 1.75, 0, 1.75, 0, 1.75
	
	align 16
	four2Dot25 dd 0, 2.25, 0, 2.25, 0, 2.25, 0, 2.25
	
	align 16
	four1Dot875 dd 0, 1.875, 0, 1.875, 0, 1.875, 0, 1.875
	
	align 16
	four040 dd 4, 0, 4, 0
	
	align 16
	zero010 dd 0, 0, 1, 0
	
	align 16
	two030 dd 2, 0, 3, 0

segment .text align=16

_calcPi:
	pxor xmm0, xmm0
	cvtsi2sd xmm0, rdi
	movsd xmm3, [rel oneDot875]
	movapd xmm2, xmm3
	divsd xmm2, xmm0
	
	pxor xmm0, xmm0
	test rdi, rdi
	jle .ret
	
	xor eax, eax
	movsd xmm5, [rel oneDot75]
	movsd xmm4, [rel twoDot25]
	
.loop:
	pxor xmm1, xmm1
	cvtsi2sd xmm1, rax
	addsd xmm1, xmm5
	mulsd xmm1, xmm1
	
	mulsd xmm1, xmm1
	addsd xmm1, xmm3
	movapd xmm6, xmm4
	divsd xmm6, xmm1
	addsd xmm0, xmm6
	
	inc rax
	cmp rdi, rax
	jne .loop
	
	mulsd xmm0, xmm2
	ret
	
	align 16
.ret:
	ret
	
	
	
%define two300 14
	align 16
_calcPiAVX:
	vxorpd xmm0, xmm0
	vcvtsi2sd xmm0, rdi
	vmovsd xmm10, [rel oneDot875]
	vxorpd xmm2, xmm2
	vdivsd xmm9, xmm10, xmm0
	
	test rdi, rdi
	jle .return
	
	cmp rdi, 4
	jl .small
	
	vunpcklpd xmm0, xmm9, xmm9
	mov rax, rdi
	vmovdqu xmm7, [rel four040]
	and rax, -4
	vmovdqu xmm8, [rel zero010]
	xor edx, edx
	vmovdqu xmm5, [rel two030]
	vxorpd ymm6, ymm6
	vmovupd ymm2, [rel four1Dot75]
	vmovupd ymm4, [rel four2Dot25]
	vmovupd ymm1, [rel four1Dot875]
	vinsertf128 ymm3, ymm0, xmm0, 1
	
.avxLoop:
	vpshufd xmm12, xmm8, two300
	vxorpd xmm11, xmm11
	vpshufd xmm15, xmm5, two300
	vxorpd xmm13, xmm13
	vmovq rcx, xmm8
	vxorpd xmm14, xmm14
	vmovq rsi, xmm12
	vmovq r8, xmm5
	vmovq r9, xmm15
	
	vpaddq xmm8, xmm7
	vpaddq xmm5, xmm7
	
	vcvtsi2sd xmm11, rcx
	vcvtsi2sd xmm13, rsi
	vcvtsi2sd xmm14, r8
	vcvtsi2sd xmm15, r9
	vunpcklpd xmm0, xmm11, xmm13
	add rdx, 4
	
	vunpcklpd xmm11, xmm14, xmm15
	vinsertf128 ymm12, ymm0, xmm11, 1
	vaddpd ymm13, ymm2, ymm12
	vmulpd ymm0, ymm3, ymm13
	
	vmulpd ymm11, ymm0, ymm0
	vaddpd ymm12, ymm1, ymm11
	vdivpd ymm13, ymm4, ymm12
	vaddpd ymm6, ymm13
	
	cmp rdx, rax
	jb .avxLoop
	
	vextractf128 xmm0, ymm6, 1
	vaddpd xmm1, xmm6, xmm0
	vunpckhpd xmm2, xmm1, xmm1
	vaddsd xmm2, xmm1, xmm2
	
.remaining:
	cmp rax, rdx
	jae .return
	
	vmovsd xmm1, [oneDot75]
	vmovsd xmm0, [twoDot25]
	
.loop:
	vxorpd xmm3, xmm3
	vcvtsi2sd xmm3, rax
	inc rax
	vaddsd xmm4, xmm1, xmm3
	vmulsd xmm5, xmm9, xmm4
	
	vmulsd xmm6, xmm5, xmm5
	vaddsd xmm7, xmm10, xmm6
	vdivsd xmm8, xmm0, xmm7
	vaddsd xmm2, xmm8
	
	cmp rax, rdi
	jb .loop
	
.return:
	vmulsd xmm0, xmm9, xmm2
	vzeroupper
	ret
	
.small:
	xor eax ,eax
	jmp .remaining