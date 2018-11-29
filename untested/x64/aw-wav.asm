global _wav_write
global _wav_parse

segment .text align=16

_wav_write:
	mov edx, [rsi + 36]
	cmp edx, 1
	je .nbytes2
	
	mov eax, -1
	cmp edx, 3
	jne .return
	
	mov eax, 4
	jmp .continue
	
.nbytes2:
	mov eax, 2
	
.continue:
	mov dword [rdi], 0x46464952
	mov r8d, [rsi + 8]
	lea ecx, [r8 + 36]
	mov [rdi + 4], ecx
	mov rcx, 0x20746D6645564157
	mov [rdi + 8], rcx
	mov dword [rdi + 16], 16
	mov [rdi + 20], dx
	mov ecx, [rsi + 32]
	mov [rdi + 22], cx
	
	movsd xmm0, [rsi + 16]
	cvttsd2si rdx, xmm0
	mov [rdi + 24], edx
	
	cvtsi2sd xmm1, eax
	cvtsi2sd xmm2, rcx
	mulsd xmm1, xmm0
	mulsd xmm1, xmm2
	cvttsd2si rdx, xmm1
	mov [rdi + 28], edx
	
	imul ecx, eax
	mov [rdi + 34], ax
	
	shl eax, 3
	mov [rdi + 34], ax
	mov dword [rdi + 36], 0x61746164
	mov [rdi + 40], r8d
	xor eax, eax
	
.return:
	ret
	
	
	
	
	
	align 16
_wav_parse:
	mov r8d, -1
	
	cmp dword [rsi], 0x46464952
	jne .returnR8d
	
	mov r8d, -2
	cmp dword [rsi + 8], 0x45564157
	jne .returnR8d
	
	add rsi, 12
	jmp .startLoop
	
.loop:
	add rsi, rax
	add rsi, 8
	
.startLoop:
	mov edx, [rsi]
	mov eax, [rsi + 4]
	bswap edx
	
	cmp edx, 0x666D7420
	je .fmt
	
	cmp edx, 0x64617461
	jne .loop
	jmp .match
	
.fmt:
	lea rcx, [rsi + 8]
	jmp .loop
	
.match:
	add rsi, 8
	mov [rdi], rsi
	mov [rdi + 8], rax

	mov edx, [rcx + 4]
	cvtsi2sd xmm0, rdx
	movsd [rdi + 16], xmm0
	
	movzx edx, word [rcx]
	mov [rdi + 36], edx
	
	movzx esi, word [rcx + 2]
	mov [rdi + 32], esi
	
	xor r8d, r8d
	xor edx, edx
	div esi
	
	movzx ecx, word [rcx + 14]
	shr ecx, 3
	xor edx, edx
	div ecx
	
	mov [rdi + 24], rax
	
.returnR8d:
	mov eax, r8d
	ret