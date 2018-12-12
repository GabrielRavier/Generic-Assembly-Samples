global _ternlogd_scalar
global _ternlogq_scalar
global _pmadd52luq_scalar

segment .rodata align=16

	eigth1Fs dd 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F
	
	align 16
	eigth1s dd 1, 1, 1, 1, 1, 1, 1, 1
	
	align 16
	four0x08080808 dd 0x08080808, 0x08080808, 0x08080808, 0x08080808
	
	align 16
	zeroTo15 dd 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
	
	align 16
	sixteenTo31 dd 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
	
	align 16
	one dd 1
	
	align 16
	two dd 2

segment .text align=16

_ternlogd_scalar:
	mov r10d, ecx
	xor r9d, r9d
	xor eax, eax
	
.loop:
	mov r8d, edi
	mov ecx, r9d
	shr r8d, cl
	
	add r8d, r8d
	mov r11d, r8d
	and r11d, 2
	
	mov r8d, esi
	shr r8d, cl
	and r8d, 1
	or r8d, r11d
	
	add r8d, r8d
	
	mov r11d, edx
	shr r11d, cl
	mov ecx, r11d
	and ecx, 1
	or ecx, r8d
	
	mov r8d, r10d
	shr r8d, cl
	and r8d, 1
	mov ecx, r9d
	sal r8d, cl
	or eax, r8d
	inc r9d
	
	cmp r9d, 32
	jne .loop
	
	ret
	
	
	
	align 16
_ternlogd_scalarAVX2:
	mov rax, 0x0706050403020100
	
	vmovd xmm6, ecx
	vmovd xmm3, edi
	vmovd xmm2, esi
	vmovd xmm0, edx
	
	vmovdqu xmm8, [rel four0x08080808]
	vpxor ymm9, ymm9
	vmovq xmm7, rax
	
	vmovdqu ymm4, [rel eigth1Fs]
	vpbroadcastd ymm6, xmm6
	xor al, al
	vpbroadcastd ymm5, xmm3
	
	vmovdqu ymm3, [rel eigth1s]
	vpbroadcastd ymm2, xmm2
	vpbroadcastd ymm1, xmm0
	
.loop:
	vpmovzxbd ymm10, xmm7
	add al, 8
	vpand ymm0, ymm10, ymm4
	vpaddb xmm7, xmm8
	
	vpsrlvd ymm11, ymm5, ymm0
	vpsrlvd ymm13, ymm2, ymm0
	vpand ymm12, ymm11, ymm3
	vpand ymm15, ymm13, ymm3
	vpsrlvd ymm11, ymm1, ymm0
	
	vpslld ymm14, ymm12, 1
	
	vpand ymm13, ymm11, ymm3
	vpor ymm10, ymm14, ymm15
	
	vpslld ymm12, ymm10, 1
	
	vpor ymm14, ymm12, ymm13
	vpand ymm15, ymm14, ymm4
	vpsrlvd ymm10, ymm6, ymm15
	vpand ymm11, ymm10, ymm3
	vpsllvd ymm0, ymm11, ymm0
	vpor ymm9, ymm0
	
	cmp al, 32
	jb .loop
	
	vextracti128 xmm0, ymm9, 1
	vpor xmm1, xmm9, xmm0
	vpshufd xmm2, xmm1, 14
	vpor xmm3, xmm1, xmm2
	vpshufd xmm4, xmm3, 57
	vpor xmm5, xmm3, xmm4
	vmovd eax, xmm5

	vzeroupper
	ret
	
	
	
%define two301 78
%define one123 229

	align 16
_ternlogd_scalarAVX512:
	vpbroadcastd zmm0, edi
	vpbroadcastd zmm1, esi
	vpbroadcastd zmm2, edx
	vpbroadcastd zmm3, ecx
	
	vmovdqa64 zmm4, [zeroTo15]
	vpsrlvd zmm5, zmm0, zmm4
	
	vpaddd zmm5, zmm5
	vpbroadcastd zmm6, [one]
	vpbroadcastd zmm7, [two]
	vpandd zmm5, zmm7
	
	vpsrlvd zmm8, zmm1, zmm4
	vpandd zmm8, zmm6
	vpord zmm5, zmm8
	
	vpaddd zmm5, zmm5
	
	vpsrlvd zmm8, zmm2, zmm4
	vpandd zmm8, zmm6
	vpord zmm5, zmm8
	
	vpsrlvd zmm5, zmm3, zmm5
	vpandd zmm5, zmm6
	
	vmovdqa64 zmm8, [sixteenTo31]
	vpsllvd zmm4, zmm5, zmm4
	vpsrlvd zmm0, zmm8
	
	vpaddd zmm0, zmm0
	vpandd zmm0, zmm7
	
	vpsrlvd zmm1, zmm8
	vpandd zmm1, zmm6
	vpord zmm0, zmm1
	
	vpsrlvd zmm1, zmm2, zmm8
	vpandd zmm1, zmm6
	vpord zmm0, zmm1
	
	vpsrlvd zmm0, zmm3, zmm0
	vpandd zmm0, zmm6
	vpsllvd zmm0, zmm8
	vpord zmm0, zmm4
	vextracti64x4 ymm1, zmm0, 1
	vpord zmm0, zmm0, zmm1
	vextracti128 xmm1, ymm0, 1
	vpord zmm0, zmm1
	vpshufd xmm1, xmm0, two301
	vpord zmm0, zmm1
	vpshufd xmm1, xmm0, one123
	vpor xmm0, xmm1
	vmovd eax, xmm0
	
	vzeroupper
	ret
	
	
	
	
	
	align 16
_ternlogq_scalar:
	mov r8d, ecx
	xor r9d, r9d
	xor eax, eax
	
.loop:
	mov r10, rdi
	mov ecx, r9d
	mov r11, rsi
	
	shr r10, cl
	shr r11, cl
	
	and r10d, 1
	and r11d, 1
	lea r10d, [r11 + r10 * 2]
	
	mov r11, rdx
	shr r11, cl
	and r11d, 1
	lea ecx, [r11 + r10 * 2]
	
	mov r10d, r8d
	shr r10d, cl
	mov ecx, r9d
	
	inc r9
	
	and r10d, 1
	shl r10, cl
	or rax, r10
	
	cmp r9, 64
	jne .loop
	
	ret
	
	
	
	
	
	align 16
_pmadd52luq_scalar:
	imul rsi, rdx
	mov rax, 0xFFFFFFFFFFFFF
	and rax, rsi
	add rax, rdi
	ret