global _sumArray
global _getMedian

segment .text align=16

_sumArray:
	mov r8, rsi
	xor eax, eax
	
	test r8, r8
	jbe .return
	
	cmp r8, 8
	jb .noSSE
	
	mov rsi, rdi
	and rsi, 0xF
	je .aligned
	
	test rsi, 3
	jne .noSSE
	
	neg rsi
	add rsi, 16
	shr rsi, 2
	lea rdx, [rsi + 8]
	cmp r8, rdx
	jb .noSSE
	
	mov rdx, r8
	xor ecx, ecx
	sub rdx, rsi
	and rdx, 7
	neg rdx
	add rdx, r8
	
	test rsi, rsi
	jbe .startSSE
	
.alignLoop:
	add eax, [rdi + rcx * 4]
	inc rcx
	cmp rcx, rsi
	jb .alignLoop
	jmp .startSSE
	
.aligned:
	mov rdx, r8
	and rdx, 7
	neg rdx
	add rdx, r8
	
.startSSE:
	movd xmm0, eax
	
.sseLoop:
	paddd xmm0, [rdi + rsi * 4]
	paddd xmm0, [rdi + rsi * 4 + 16]
	
	add rsi, 8
	cmp rsi, rdx
	jb .sseLoop
	
	movdqa xmm1, xmm0
	psrldq xmm1, 8
	paddd xmm0, xmm1
	movdqa xmm2, xmm0
	psrlq xmm2, 32
	paddd xmm0, xmm2
	movd eax, xmm0
	
.startEndLoop:
	cmp rdx, r8
	jae .return
	
.endLoop:
	add eax, [rdi + rdx * 4]
	inc rdx
	cmp rdx, r8
	jb .endLoop
	
.return:
	ret
	
.noSSE:
	xor edx, edx
	jmp .startEndLoop
	
	
	
	align 16
_sumArrayAVX2:
	mov r8, rsi
	xor eax, eax
	
	test r8, r8
	jbe .return
	
	cmp r8, 16
	jb .small
	
	cmp r8, 57
	jb .middle
	
	mov rsi, rdi
	and rsi, 0x1F
	je .aligned
	
	test rsi, 3
	jne .small
	
	neg rsi
	add rsi, 32
	shr rsi, 2
	lea rdx, [rsi + 16]
	
	cmp r8, rdx
	jb .small
	
	mov rdx, r8
	xor ecx, ecx
	sub rdx, rsi
	and rdx, 0xF
	neg rdx
	add rdx, r8
	
	test rsi, rsi
	je .startAVX
	
.alignLoop:
	add eax, [rdi + rcx * 4]
	inc rcx
	cmp rcx, rsi
	jb .alignLoop
	jmp .startAVX
	
	align 16
.aligned:
	mov rdx, r8
	and rdx, 0xF
	neg rdx
	add rdx, r8
	
.startAVX:
	vmovd xmm1, eax
	vpxor ymm0, ymm0
	vmovaps xmm1, xmm1
	
.avxLoop:
	vpaddd ymm1, [rdi + rsi * 4]
	vpaddd ymm0, [rdi + rsi * 4 + 32]
	
	add rsi, 16
	cmp rsi, rdx
	jb .avxLoop

	vpaddd ymm0, ymm1, ymm0
	vextractf128 xmm1, ymm0, 1
	vpaddd xmm2, xmm0, xmm1
	vpsrldq xmm3, xmm2, 8
	vpaddd xmm4, xmm2, xmm3
	vpsrlq xmm5, xmm4, 32
	vpaddd xmm6, xmm4, xmm5
	vmovd eax, xmm6
	
.checkEnd:
	cmp rdx, r8
	jae .return
	
.endLoop:
	add eax, [rdi + rdx * 4]
	inc rdx
	cmp rdx, r8
	jb .endLoop
	
.return:
	vzeroupper
	ret
	
	align 16
.small:
	xor edx, edx
	jmp .checkEnd
	
	align 16
.middle:
	mov rdx, r8
	xor esi, esi
	and rdx, -16
	jmp .startAVX
	
	
	
	
	
	align 16
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
	