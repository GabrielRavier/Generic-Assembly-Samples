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
	cmp dword [rsi], 0x66666163
	lea rdx, [rsi + 8]
	jne .returnMinus1
	
	cmp word [rsi + 4], 0x100
	je .startLoop
	jmp .returnMinus2
	
.loop:
	cmp eax, 0x70616B74
	je .pakt
	
	cmp eax, 0x64617461
	je .blocks
	
.continue:
	lea rdx, [rdx + 12 + rcx]
	
.startLoop:
	mov eax, [rdx]
	mov rcx, [rdx + 4]
	bswap eax
	bswap rcx
	
	cmp eax, 0x64657363
	jne .loop
	
	lea r8, [rdx + 12]
	jmp .continue
	
.pakt:
	lea r9, [rdx + 12]
	jmp .continue
	
.blocks:
	add rdx, 16
	cmp dword [r8 + 8], 0x34616D69
	jne .returnMinus3
	
	mov [rdi + 8], rcx
	mov rax, [r9 + 8]
	
	mov [rdi], rdx
	
	bswap rax
	mov [rdi + 24], rax
	
	mov eax, [r8 + 24]
	bswap eax
	mov [rdi + 32], eax
	
	mov rax, [r8]
	bswap rax
	
	mov [rdi + 16], rax
	
	xor eax, eax
	ret
	
.returnMinus1:
	mov eax, -1
	ret
	
.returnMinus2:
	mov eax, -2
	ret
	
.returnMinus3:
	mov eax, -3
	ret
	
	
	
	
	
	align 16
_ima_decode:
	sub rsp, 136
	mov r11d, r8d
	
	
	shr rsi, 6
	mov rax, rsi
	shl rax, 5
	lea r10, [rax + rsi * 2]
	imul r10, r11
	add rcx, r10
	test edx, edx
	je .return
	
	mov [rsp + 120], r11
	mov [rsp], r12
	mov [rsp + 8], r13
	mov [rsp + 16], r14
	mov [rsp + 24], r15
	mov [rsp + 32], rbx
	mov [rsp + 40], rbp
	
.countLoop:
	mov r12d, 64
	cmp edx, 64
	cmovbe r12d, edx
	
	xor r11d, r11d
	
	test r8d, r8d
	jbe .channelCount0
	
	mov ebp, r12d
	mov ebx, r12d
	shr ebp, 1
	xor r10d, r10d
	mov eax, ebp
	mov [64+rsp], rax 
	and ebx, 1
	mov [56+rsp], r12d
	xor esi, esi
	mov [48+rsp], edx 
	mov [128+rsp], r8d
	
.channelLoop:
	movzx eax, word [rcx]
	mov r14, rcx
	bswap eax
	add rcx, 34
	shr eax, 16 
	lea r13, [rdi+r11*2]
	mov r12d, eax
	movsx r8, ax 
	and r12d, 127
	and r8d, -128
	cmp r12d, [r9+r11*8]
	jne .indexesEqual
	mov eax, r8d
	mov r15d, [4+r9+r11*8]
	sub eax, r15d
	cdq
	
	xor eax, edx
	sub eax, edx
	cmp eax, 127
	cmovle r8d, r15d
	
.indexesEqual:
	xor eax, eax
	mov edx, [_ima_step_table+r12*4]
	test ebp, ebp
	je .decodeCount0
	
	mov [72+rsp], r9
	mov r15d, esi
	mov [112+rsp], r10d
	mov [104+rsp], ebx
	mov ebx, 32767
	mov [96+rsp], r11 
	mov [88+rsp], rcx 
	mov [80+rsp], rdi 
	mov edi, 88
	mov r9, [120+rsp]
	
.decodeLoop:
	movzx ecx, byte [2+rax+r14]
	mov r10d, ecx
	and r10d, 15 
	inc r15d
	add r12d, [_ima_index_table+r10*4]
	cmp r12d, 88
	cmovge r12d, edi
	
	mov eax, r12d
	sar eax, 31
	not eax 
	and eax, r12d
	mov r12d, edx
	sar r12d, 3
	test r10d, 4
	movsxd rax, eax 
	lea r11d, [rdx+r12]
	cmovne r12d, r11d
	
	mov r11d, edx
	sar r11d, 1 
	test r10d, 2
	cmove r11d, esi 
	
	sar edx, 2 
	add r12d, r11d
	add edx, r12d 
	test r10d, 1
	cmovne r12d, edx
	
	mov r11d, -0x7FFF
	mov edx, r8d 
	sub edx, r12d
	add r8d, r12d
	test r10d, 8
	mov r12d, ecx
	mov r10d, [_ima_step_table+rax*4]
	cmovne r8d, edx
	
	mov edx, r10d
	cmp r8d, 32767 
	cmovg r8d, ebx 
	
	shr r12d, 4
	cmp r8d, -32768
	cmovl r8d, r11d
	
	add eax, [_ima_index_table+r12*4]
	cmp eax, 88
	mov [r13], r8w
	cmovge eax, edi
	
	mov r12d, eax
	sar edx, 3 
	sar r12d, 31 
	not r12d 
	and r12d, eax
	test cl, 64
	movsxd r12, r12d
	lea eax, [r10+rdx]
	cmovne edx, eax
	
	mov eax, r10d
	sar eax, 1 
	test cl, 32
	cmove eax, esi 
	
	sar r10d, 2 
	add edx, eax
	add r10d, edx 
	test cl, 16
	mov eax, r15d
	cmovne edx, r10d
	
	mov r10d, r8d
	sub r10d, edx
	add edx, r8d 
	test ecx, 128
	mov r8d, r11d
	cmovne edx, r10d
	
	cmp edx, 32767
	cmovg edx, ebx
	
	cmp edx, -32768 
	cmovge r8d, edx 
	
	mov word [r13+r9*2], r8w
	lea r13, [r13+r9*4]
	mov edx, [_ima_step_table+r12*4]
	cmp r15d, ebp
	jb .decodeLoop
	
	mov r10d, [112+rsp]
	mov ebx, [104+rsp] 
	mov r11, [96+rsp]
	mov rcx, [88+rsp]
	mov rdi, [80+rsp]
	mov r9, [72+rsp]
	
.decodeCount0:
	test ebx, ebx
	jne .doLastDecode
	
.decodeEnd:
	inc r10d
	mov [r9+r11*8], r12d 
	mov [4+r9+r11*8], r8d
	mov r11d, r10d
	cmp r10d, [128+rsp]
	jb .channelLoop
	
	mov r12d, [56+rsp]
	mov edx, [48+rsp] 
	mov r8d, [128+rsp]
	
.channelCount0:
	mov eax, r12d
	imul eax, r8d
	lea rdi, [rdi+rax*2] 
	sub edx, r12d
	jne .countLoop
	
	mov r12, [rsp]
	mov r13, [8+rsp] 
	mov r14, [16+rsp]
	mov r15, [24+rsp]
	mov rbx, [32+rsp]
	mov rbp, [40+rsp]
	
.return:
	add rsp, 136
	ret
	
.doLastDecode:
	mov r15, [64+rsp]
	movzx eax, byte [2+r15+r14]
	mov r14d, 88
	and eax, 15
	add r12d, [_ima_index_table+rax*4]
	cmp r12d, 88
	cmovl r14d, r12d
	
	mov r12d, r14d
	sar r12d, 31
	not r12d
	and r12d, r14d
	mov r14d, edx 
	sar r14d, 3
	test al, 4 
	lea r15d, [rdx+r14]
	cmovne r14d, r15d
	
	mov r15d, edx
	sar r15d, 1
	test al, 2 
	cmove r15d, esi 
	
	sar edx, 2 
	add r14d, r15d
	add edx, r14d 
	test al, 1
	cmovne r14d, edx
	
	mov edx, r8d 
	sub edx, r14d
	add r14d, r8d
	test al, 8
	cmovne r14d, edx
	
	mov r8d, 32767
	cmp r14d, 32767 
	cmovg r14d, r8d 
	
	mov r8d, -32768 
	cmp r14d, -32768 
	cmovge r8d, r14d 
	
	mov word [r13], r8w
	jmp .decodeEnd