global _ima_parse
global _ima_decode

segment .rodata align=16

	_ima_step_table dd 7, 8, 9, \
	10, 11, 12, 13, 14, 16, 17, 19, 21, 23, 25, 28, 31, 34, 37, 41, 45, 50, 55, 60, 66, 73, 80, 88, 97, \
	107, 118, 130, 143, 157, 173, 190, 209, 230, 253, 279, 307, 337, 371, 408, 449, 494, 544, 598, 658, 724, 796, 876, 963, \
	1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066, 2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358, 5894, 6484, 7132, 7845, 8630, 9493, \
	10442, 11487, 12635, 13899, 15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767
	
	align 16
	
	_ima_index_table dd -1, -1, -1, -1, 2, 4, 6, 8, -1, -1, -1, -1, 2, 4, 6, 8

segment .text align=16

_ima_parse:
	push ebx
	push edi
	push esi
	
	mov edx, [esp + 20]
	mov eax, -1
	
	cmp dword [edx], 0x66666163
	jne .return
	
	movzx ecx, word [edx + 4]
	mov eax, -2
	cmp ecx, 0x100
	jne .return
	
	mov ecx, [esp + 16]
	add edx, 8
	jmp .startLoop
	
.loop:
	lea edx, [edx + ebx + 12]
	
.startLoop:
	mov eax, [edx]
	mov ebx, [edx + 8]
	
	bswap eax
	bswap ebx
	
	cmp eax, 0x64657363
	je .desc
	
	cmp eax, 0x70616B74
	je .pakt
	
	cmp eax, 0x64617461
	jne .loop
	jmp .endLoop
	
.desc:
	lea esi, [edx + 12]
	jmp .loop
	
.pakt:
	lea edi, [edx + 12]
	lea edx, [edx + ebx + 12]
	jmp .startLoop
	
.endLoop:
	cmp dword [esi + 8], 0x34616D69
	mov eax, -3
	jne .return
	
	mov eax, [edx + 4]
	
	add edx, 16
	
	mov [ecx], eax
	mov [ecx + 4], ebx
	bswap eax
	mov [ecx + 8], eax
	
	mov eax, [edi + 8]
	mov edx, [edi + 12]
	
	bswap eax
	bswap edx
	
	mov [ecx + 20], edx
	mov [ecx + 24], eax
	
	mov eax, [esi + 24]
	bswap eax
	mov [ecx + 28], eax
	
	mov eax, [esi]
	mov edx, [esi + 4]
	
	bswap eax
	bswap edx
	
	mov [ecx + 16], eax
	xor eax, eax
	mov [ecx + 12], edx
	
.return:
	pop esi
	pop edi
	pop ebx
	ret
	
	
	
	
	
	align 16
_ima_decode:
	push ebp
	push edi
	push esi
	push ebx
	sub esp, 76
	movq xmm0, [esp + 100]
	
	psrlq xmm0, 6
	movd eax, xmm0
	imul eax, [esp + 116]
	imul eax, eax, 34
	add eax, [esp + 112]
	mov [esp + 32], eax
	
	mov eax, [esp + 116]
	add eax, eax
	mov [esp + 24], eax
	mov eax, [esp + 116]
	sal eax, 2
	mov [esp + 28], eax
	
	mov eax, [esp + 108]
	test eax, eax
	je .return
	
.framesLoop:
	cmp dword [esp + 108], 63
	jbe .remainSmaller
	
	mov ebp, [esp + 116]
	sub dword [esp + 108], 64
	test ebp, ebp
	je .channelCount0
	
	mov dword [esp + 44], 32
	mov dword [esp + 52], 0
	mov dword [esp + 60], 64
	
.loop2:
	mov eax, [esp + 96]
	mov ecx, [esp + 44]
	mov dword [esp + 36], 0
	mov [esp + 40], eax
	mov eax, [esp + 32]
	lea esi, [eax + ecx + 2]
	mov [esp + 48], eax
	mov [esp + 20], esi
	mov esi, [esp + 28]
	imul esi, ecx
	mov [esp + 56], esi
	
.decodeChannelsCount:
	add dword [esp + 32], 34
	mov eax, [esp + 32]
	mov ecx, [esp + 40]
	mov esi, [esp + 36]
	
	movzx eax, word [eax - 34]
	mov [esp + 16], ecx
	mov edx, eax
	mov [esp + 12], ax
	mov eax, [esp + 120]
	
	rol dx, 8
	mov ecx, edx
	and edx, 0x80
	and ecx, 0x7F
	
	movsx edx, dx
	
	cmp ecx, [eax + esi * 8]
	jne .stateIndexNotEqualToIndex
	
	mov eax, [eax + esi * 8 + 4]

	mov ebx, edx
	mov esi, eax
	sub esi, edx
	sub ebx, eax
	cmovs ebx, esi
	
	cmp ebx, 0x7F
	cmovle edx, eax
	
.stateIndexNotEqualToIndex:
	mov edi, [esp + 44]
	mov ebx, [_ima_step_table + ecx * 4]
	
	test edi, edi
	je .decodeCnt0
	
	mov eax, [esp + 32]
	sub eax, 32
	mov [esp + 12], eax
	
.sampleDecodeLoop:
	mov eax, [esp + 12]
	movzx edi, byte [eax]
	
	mov ebp, edi
	mov eax, edi
	and ebp, 0xF
	movzx esi, al
	mov eax, ebx
	add ecx, [_ima_index_table + ebp * 4]
	mov ebp, 88
	
	cmp ecx, 88
	cmovg ecx, ebp
	
	mov ebp, 0
	test ecx, ecx
	cmovs ecx, ebp
	
	sar eax, 3
	test edi, 4
	lea ebp, [eax + ebx]
	cmovne eax, ebp
	
	mov ebp, ebx
	sar ebp, 1
	add ebp, eax
	test edi, 2
	cmovne eax, ebp
	
	sar ebx, 2
	mov ebp, [esp + 16]
	add ebx, eax
	test edi, 1
	cmovne eax, ebx
	
	mov ebx, edx
	sub ebx, eax
	add eax, edx
	and edi, 8
	mov edi, [_ima_step_table + ecx * 4]
	cmovne eax, ebx
	
	mov ebx, 0x7FFF
	mov edx, 88
	cmp eax, 0x7FFF
	cmovg eax, ebx
	
	mov ebx, -0x7FFF
	cmp eax, -0x7FFF
	cmovl eax, ebx
	
	sar esi, 4
	add ecx, [_ima_step_table + esi * 4]
	cmp ecx, 88
	mov [ebp], ax
	cmovg ecx, edx
	
	mov edx, 0
	test ecx, ecx
	cmovs ecx, edx
	
	mov edx, edi
	sar edx, 3
	test esi, 4
	mov ebx, edx
	lea edx, [edx + edi]
	cmovne ebx, edx
	
	mov edx, edi
	sar edx, 1
	add edx, ebx
	test esi, 2
	cmovne ebx, edx
	
	sar edi, 2
	mov edx, 0x7FFF
	add edi, ebx
	test esi, 1
	cmovne ebx, edi
	
	mov edi, eax
	sub edi, ebx
	add eax, ebx
	and esi, 8
	mov esi, -0x7FFF
	cmovne eax, edi
	
	mov ebx, [_ima_step_table + ecx * 4]
	
	cmp eax, 0x7FFF
	cmovle edx, eax
	
	cmp edx, -0x7FFF
	cmovl edx, esi
	
	mov esi, [esp + 24]
	inc dword [esp + 12]
	mov eax, [esp + 12]
	mov [ebp + esi], dx
	mov esi, [esp + 28]
	add ebp, esi
	mov [esp + 16], ebp
	
	cmp [esp + 20], eax
	jne .sampleDecodeLoop
	
	mov esi, [esp + 52]
	mov eax, [esp + 40]
	add eax, [esp + 56]
	mov [esp + 16], eax
	
	mov eax, [esp + 44]
	
	test esi, esi
	jne .decodeCountNotAligned
	
.finishDecodeBlock:
	mov eax, [esp + 36]
	mov esi, [esp + 120]
	add dword [esp + 40], 2
	mov [esi + eax * 8], ecx
	
	mov ecx, [esp + 32]
	mov [esi + eax * 8 + 4], edx
	
	inc eax
	mov [esp + 36], eax
	add dword [esp + 20], 34
	mov [esp + 48], ecx
	cmp [esp + 116], eax
	ja .decodeChannelsCount
	
.checkEnd:
	mov edx, [esp + 108]
	mov eax, [esp + 60]
	imul eax, [esp + 24]
	add [esp + 96], eax
	
	test edx, edx
	jne .framesLoop
	
.return:
	add esp, 76
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
.decodeCnt0:
	mov esi, [esp + 52]
	xor eax, eax
	test esi, esi
	je .finishDecodeBlock
	
.decodeCountNotAligned:
	mov esi, [esp + 48]
	movzx edi, byte [esi + eax + 2]
	mov esi, ebx
	mov eax, edi
	and eax, 15
	add ecx, [_ima_index_table + eax * 4]
	mov eax, 88
	cmp ecx, 88
	cmovg ecx, eax
	
	mov eax, 0
	test ecx, ecx
	cmovs ecx, eax
	
	sar esi, 3
	test edi, 4
	lea eax, [esi + ebx]
	cmovne esi, eax
	
	mov eax, ebx
	sar eax, 1
	add eax, esi
	test edi, 2
	cmovne esi, eax
	
	sar ebx, 2
	test edi, 1
	lea eax, [esi + ebx]
	cmovne esi, eax
	
	mov eax, edx
	sub eax, esi
	add edx, esi
	and edi, 8
	cmove eax, edx
	
	mov edx, 0x7FFF
	cmp eax, 0x7FFF
	cmovle edx, eax
	
	mov eax, -0x7FFF
	cmp edx, -0x7FFF
	cmovl edx, eax
	
	mov eax, [esp + 16]
	mov [eax], dx
	jmp .finishDecodeBlock
	
.remainSmaller:
	mov eax, [esp + 116]
	test eax, eax
	je .return
	
	mov eax, [esp + 108]
	and eax, 1
	mov [esp + 52], eax
	mov eax, [esp + 108]
	shr eax, 1
	mov [esp + 44], eax
	mov eax, [esp + 108]
	mov dword [esp + 108], 0
	mov [esp + 60], eax
	jmp .loop2
	
.channelCount0:
	mov dword [esp + 60], 64
	jmp .checkEnd
	