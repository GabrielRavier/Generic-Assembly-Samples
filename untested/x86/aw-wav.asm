global _wav_write
global _wav_parse

segment .rodata align=16

	xmmDat1 dq 2147483648
	
	align 16
	
	xmmDat2 dq 4503599627370496
	
	align 16
	
	xmmDat3 dq 4841369599423283200

segment .text align=16

_wav_write:
	push ebx
	push edi
	push esi
	
	mov edi, [esp + 20]
	mov esi, [edi + 32]
	
	cmp esi, 1
	je .nbytes2
	
	mov eax, -1
	cmp esi, 3
	jne .return
	
	mov eax, 4
	jmp .noBytesSet
	
	align 16
.nbytes2:
	mov eax, 2
	
.noBytesSet:
	mov ecx, [esp + 16]
	movsd xmm2, [xmmDat1]
	movsd xmm4, [xmmDat2]
	
	mov dword [ecx], 0x46464952
	
	mov edx, [edi + 4]
	lea ebx, [edx + 36]
	
	mov [ecx + 4], ebx
	mov dword [ecx + 8], 0x45564157
	mov dword [ecx + 12], 0x20746D66
	mov dword [ecx + 16], 16
	mov [ecx + 20], si
	
	mov esi, [edi + 28]
	movss xmm0, [edi + 28]
	mov [ecx + 22], si
	
	orpd xmm0, xmm4
	movsd xmm1, [edi + 12]
	subsd xmm0, xmm4
	
	movapd xmm3, xmm1
	cvttsd2si ebx, xmm1
	subsd xmm3, xmm2
	cvttsd2si edi, xmm3
	
	xorps xmm3, xmm3
	cvtsi2sd xmm3, eax
	mulsd xmm3, xmm1
	
	xor edi, 0x80000000
	ucomisd xmm2, xmm1
	
	mulsd xmm3, xmm0
	cmovbe ebx, edi
	
	movapd xmm0, xmm3
	mov [ecx + 24], ebx
	
	cvttsd2si edi, xmm3
	subsd xmm0, xmm2
	cvttsd2si ebx, xmm0
	xor ebx, 0x80000000
	ucomisd xmm3, xmm2
	cmovb ebx, edi
	
	imul esi, eax
	shl eax, 3
	mov [ecx + 28], ebx
	mov [ecx + 32], si
	mov [ecx + 34], ax
	
	xor eax, eax
	mov dword [ecx + 36], 0x61746164
	mov [ecx + 40], edx
	
.return:
	pop esi
	pop edi
	pop edx
	ret
	
	
	
	
	
	align 16
_wav_parse:
	push ebx
	push edi
	push esi
	mov edx, [esp + 20]
	mov ecx, -1
	
	cmp dword [edx], 0x46464952
	jne .return
	
	cmp dword [edx + 8], 0x45564157
	mov ecx, -2
	jne .return
	
	mov esi, [esp + 16]
	add edx, 12
	jmp .startLoop

	align 16
.loop:
	lea edx, [edx + eax * 8]
	
.startLoop:
	mov ecx, [edx]
	mov eax, [edx + 4]
	bswap ecx
	
	cmp ecx, 0x666D7420
	je .fmt
	
	cmp ecx, 0x64617461
	jne .loop
	jmp .foundData
	
	align 16
.fmt:
	lea edi, [edx + 8]
	jmp .loop
	
	align 16
.foundData:
	add edx, 8
	movsd xmm0, [xmmDat3]
	
	mov [esi], edx
	mov [esi + 4], eax
	mov dword [esi + 8], 0
	
	xor edx, edx
	
	movss xmm1, [edi + 4]
	orpd xmm1, xmm0
	subsd xmm1, xmm0
	movsd [esi + 12], xmm1
	
	movzx ebx, word [edi]
	mov [esi + 32], ecx
	
	xor ecx, ecx
	movzx ebx, word [edi + 2]
	mov [esi + 28], ebx
	
	div ebx
	movzx edi, word [edi + 14]
	xor edx, edx
	shr edi, 3
	div edi
	mov dword [esi + 24], 0
	mov [esi + 20], eax
	
.return:
	mov eax, ecx
	pop esi
	pop edi
	pop ebx
	ret