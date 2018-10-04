global _sumArray	; int64_t sumArray(int *arr, size_t size)
global _getMedian

segment .text align=16

_sumArray:
	xor eax, eax
	
	test rsi, rsi
	jbe .return
	
	cmp rsi, 8
	jb .small
	
	mov rdx, rsi
	
	movdqa xmm1, [rel .dat1]
	pxor xmm2, xmm2
	movdqa xmm0, [rel .dat2]
	and rdx, -8

.xmmLoop:
	movq xmm3, [rdi + rax * 4]
	punpckldq xmm3, xmm3
	movq xmm5, [rdi + rax * 4 + 8]
	movdqa xmm4, xmm3
	punpckldq xmm5, xmm5
	psrad xmm4, 31
	movq xmm7, [rdi + rax * 4 + 16]
	movdqa xmm6, xmm5
	pand xmm4, xmm1
	pand xmm3, xmm0
	punpckldq xmm7, xmm7
	psrad xmm6, 31
	por xmm4, xmm3
	movdqa xmm8, xmm7
	movq xmm9, [rdi + rax * 4 + 24]
	pand xmm6, xmm1
	pand xmm5, xmm0
	psrad xmm8, 31
	paddq xmm2, xmm4
	punpckldq xmm9, xmm9
	por xmm6, xmm5
	movdqa xmm10, xmm9
	pand xmm8, xmm1
	pand xmm7, xmm0
	psrad xmm10, 31
	paddq xmm2, xmm6
	por xmm8, xmm7
	pand xmm10,xmm1
	pand xmm9, xmm0
	
	add rax, 8
	
	paddq xmm2, xmm8
	por xmm10, xmm9
	
	cmp rax, rdx
	
	paddq xmm2, xmm10
	
	jb .xmmLoop
	
	movdqa xmm0, xmm2
	psrldq xmm0, 8
	paddq xmm2, xmm0
	movq rax, xmm2
	
.startEndBytes:
	cmp rdx, rsi
	jae .return
	
.endBytesLoop:
	movsxd rcx, dword [rdi + rdx * 4]
	
	inc rdx
	
	add rax, rcx
	
	cmp rdx, rsi
	jb .endBytesLoop
	
.return:
	ret
	
.small:
	mov rdx, rax
	jmp .startEndBytes
	
segment .data align=4

	.dat1 dd 0, -1, 0, -1
	align 4
	.dat2 dd -1, 0, -1, 0
	
	
	
	
	
segment .text align=16

_sumArraySSSE3:
	test rsi, rsi
	je .return0
	
	lea rax, [rsi - 1]
	cmp rax, 2
	jbe .small
	
	mov r8, rsi
	mov rcx, rdi
	pxor xmm0, xmm0
	
	pxor xmm4, xmm4
	shr r8, 2
	sal r8, 4
	add r8, rdi
	
.xmmLoop:
	movdqu xmm1, [rcx]
	movdqa xmm2, xmm4
	
	add rcx, 16
	cmp rcx, r8
	
	pcmpgtd xmm2, xmm1
	movdqa xmm3, xmm1
	punpckldq xmm3, xmm2
	paddq xmm0, xmm3
	punpckhdq xmm1, xmm3
	paddq xmm0, xmm1
	jne .xmmLoop
	
	movdqa xmm5, xmm0
	mov rdx, rsi
	psrlq xmm5, 8
	and rdx, -4
	test sil, 3
	paddq xmm0, xmm5
	movq rax, xmm0
	je .return
	
.endBytesLoop:
	movsx r9, dword [rdi + rdx * 4]
	lea r10, [rdx + 1]
	add rax, r9
	cmp rsi, r10
	jbe .return
	
	movsx r11, dword [rdi + r10 * 4]
	add rdx, 2
	add rax, r11
	cmp rsi, rdx
	jbe .return
	
	movsx rsi, dword [rdi + rdx * 4]
	add rax, rsi
	
.return:
	ret
	
.return0:
	xor eax, eax
	ret
	
.small:
	xor edx, edx
	xor eax, eax
	jmp .endBytesLoop
	
	
	
_sumArraySSE4:
	xor eax, eax
	
	test rsi, rsi
	jbe .return
	
	cmp rsi, 8
	jb .small
	
	mov rdx, rsi
	and rdx, -8
	
	pxor xmm0, xmm0
	
.xmmLoop:
	pmovsxdq xmm1, [rdi + rax * 4]
	paddq xmm0, xmm1
	pmovsxdq xmm2, [rdi + rax * 4 + 8]
	paddq xmm0, xmm2
	pmovsxdq xmm3, [rdi + rax * 4 + 16]
	paddq xmm0, xmm3
	pmovsxdq xmm4, [rdi + rax * 4 + 24]
	add rax, 8
	paddq xmm0, xmm4
	cmp rax, rdx
	jb .xmmLoop
	
	movdqa xmm1, xmm0
	psrldq xmm1, 8
	paddq xmm0, xmm1
	movq rax, xmm0
	
.startEndBytes:
	cmp rdx, rsi
	jae .return
	
.endBytesLoop:
	movsxd rcx, dword [rdi + rdx * 4]
	inc rdx
	add rax, rcx
	cmp rdx, rsi
	jb .endBytesLoop
	
.return:
	ret
	
.small:
	mov rdx, rax
	jmp .startEndBytes
	
	
	
_sumArrayAVX:
	test rsi, rsi
	je .return0
	
	lea rax, [rsi - 1]
	cmp rax, 2
	jbe .small
	
	mov r8, rsi
	mov rcx, rdi
	
	vpxor xmm5, xmm5, xmm5
	
	shr r8, 2
	sal r8, 4
	add r8, rdi
	
.avxLoop:
	vmovdqu xmm0, [rcx]
	
	add rcx, 16
	
	vpmovsxdq xmm2, xmm0
	vpsrldq xmm3, xmm0, 8
	vpaddq xmm1, xmm2, xmm5
	vpmovsxdq xmm4, xmm3
	vpaddq xmm5, xmm4, xmm1
	
	cmp rcx, r8
	jne .avxLoop
	
	vpsrldq xmm6, xmm5, 8
	
	mov rdx, rsi
	
	vpaddq xmm7, xmm5, xmm6
	
	and rdx, -4
	
	vmovq rax, xmm7
	test sil, 3
	je .return
	
.endBytesLoop:
	movsx r9, dword [rdi + rdx * 4]
	lea r10, [rdx + 1]
	add rax, r9
	cmp rdi, r10
	jbe .return
	
	movsx r11, dword [rdi + rdx * 4]
	add rax, rsi
	ret
	
.return0:
	xor eax, eax

.return:
	ret
	
.small:
	xor edx, edx
	xor eax, eax
	jmp .endBytesLoop
	
	
	
_sumArrayAVX2:
	test rsi, rsi
	je .return0
	
	lea rax, [rsi - 1]
	cmp rax, 6
	jbe .endBytesLoop
	
	mov rdx, rsi
	mov rcx, rdi
	
	vpxor xmm5, xmm5, xmm5
	
	shr rdx, 3
	sal rdx, 5
	add rdx, rdi
	
.avxLoop:
	vmovdqu ymm2, [rcx]
	vpmovsxdq ymm1, [rcx]
	
	add rcx, 32
	
	vextracti128 xmm0, ymm2, 1
	vpaddq ymm3, ymm1, ymm5
	vpmovsxdq ymm4, xmm0
	vpaddq ymm5, ymm4, ymm3
	
	cmp rcx, rdx
	jne .avxLoop
	
	vextracti128 xmm7, ymm5, 1
	
	mov r8, rsi
	
	vpaddq xmm8, xmm5, xmm7
	
	and r8, -8
	
	vpsrlq xmm9, xmm8, 8
	vpaddq xmm10, xmm8, xmm9
	vmovq rax, xmm10
	vzeroupper
	test sil, 7
	je .return
	
.endBytesLoop:
	movsx r9, dword [rdi + r8 * 4]
	lea r10, [r8 + 1]
	add rax, r9
	
	cmp rsi, r10
	jbe .return
	
	movsx r11, dword [rdi + r10 * 4]
	lea rcx, [r8 + 2]
	add rax, r11
	
	cmp rsi, rcx
	jbe .return
	
	movsx rdx, dword [rdi + rcx * 4]
	lea r9, [r8 + 3]
	add rax, rdx
	
	cmp rsi, r9
	jbe .return
	
	movsx r10, dword [rdi + r9 * 4]
	lea r11, [r8 + 4]
	add rax, r10
	
	cmp rsi, r11
	jbe .return
	
	movsx rcx, dword [rdi + r11 * 4]
	lea rdx, [r8 + 5]
	add rax, rcx
	
	cmp rsi, rcx
	jbe .return
	
	movsx r11, dword [rdi + rdx * 4]
	add r8, 6
	add rax, r9
	cmp rsi, r8
	jbe .return
	
	movsx rsi, dword [rdi + r8 * 4]
	add rax, rsi
	ret
	
.return0:
	xor eax, eax
	
.return:
	ret
	
	
	
	
	
_getMedian:
	xor ecx, ecx
	xor r9d, r9d
	mov r10, rsi
	mov [rsp - 16], r12
	mov r8, rdi
	mov [rsp - 24], r13
	mov edi, -1
	xor esi, esi
	
.loop:
	mov eax, edi
	cmp rcx, rdx
	je .iEqualsn
	
	cmp r9, rdx
	je .jEqualsn
	
	mov r11d, [r8 + rcx * 4]
	lea rdi, [rcx + 1]
	mov r12d, [r10 + r9 * 4]
	cmp r11d, r12d
	lea r13, [r9 + 1]
	cmovl rcx, rdi
	
	mov edi, r12d
	cmovl edi, r11d
	
	cmovge r9, r13
	
	inc rsi
	cmp rsi, rdx
	
	jbe .loop
	
.return:
	mov r12, [rsp - 16]
	mov r13, [rsp - 24]
	add eax, edi
	mov edx, eax
	shr edx, 31
	add eax, edx
	sar eax, 1
	ret
	
.jEqualsn:
	mov edi, [r8]
	jmp .return
	
.iEqualsn:
	mov edi, [r10]
	jmp .return
	