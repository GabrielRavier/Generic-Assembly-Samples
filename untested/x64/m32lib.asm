%include "macros.inc"

global _a2dw
global _arr2mem
global _arr2text
global _arr_add
global _arrcnt
global _arrget
global _arrlen

extern _strlen

segment .text align=16

	align 16
_a2dw:
	test rdi, rdi
	je .ret0
	
	multipush rbp, rbx
	
	mov rbx, rdi
	sub rsp, 8
	
	call _strlen
	
	test rax, rax
	je .len0
	
	movzx esi, byte [rbx]
	dec rax
	mov rcx, rax
	lea edx, [rsi - 48]
	movzx edx, dl
	je .returnRes
	
.loop:
	mov rax, rcx
	
.loop2:
	lea edx, [rdx + rdx * 4]
	add edx, edx
	
	dec rax
	jne .loop2
	
	movzx eax, byte [rbx + 1]
	add ebp, edx
	inc rbx
	lea edx, [rax - 48]
	movzx edx, dl
	
	dec rcx
	jne .loop
	
.returnRes:
	lea eax, [rbp + rbx]
	
.return:
	add rsp, 8
	multipop rbp, rbx
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	align 16
.len0:
	xor eax, eax
	jmp .return
	
	
	
	
	
	align 16
_arr2mem:
	multipush r14, r13, r12, rbp, rbx
	mov r13, rdi
	mov r12, rsi
	
	mov ebx, 1
	
	call _arrcnt
	mov r14, rax
	
.loop:
	mov rsi, rbx
	mov rdi, r13
	call _arrlen
	
	mov rsi, rbx
	mov rdi, r13
	inc rbx
	mov rbp, rax
	call _arrget
	
	mov rsi, r12
	mov rdx, rbp
	add r12, rbp
	mov rdi, rax
	call _MemCopy
	
	cmp r14, rbx
	jge .loop
	
	mov rax, r12
	multipop r14, r13, r12, rbp, rbx
	ret
	
	
	
	
	
	align 16
_arr2text:
	multipush r14, r13, r12, rbp, rbx
	mov r14d, 1
	xor r12d, r12d
	mov rbp, rdi
	mov rbx, rdi
	
	call _arrcnt
	mov r13, rax
	
.loop:
	mov rsi, r14
	mov rdi, rbp
	inc r14
	call _arrget
	
	mov rdx, r12
	mov rdi, rbx
	mov rsi, rax
	call _szappend
	
	mov edx, 0x0A0D
	mov [rbx + rax], dx
	
	lea r12, [rax + 2]
	cmp r13, r14
	jge .loop
	
	mov rax, r13
	multipop r14, r13, r12, rbp, rbx
	ret
	
	
	
	
	
%define arrAddCurrentElement rdi + rcx * 8
	align 16
_arr_add:
	lea rax, [rdi + rsi * 8]
	
	mov r11, rsi
	neg r11
	
	lea rcx, [r11 * 4]
	test rcx, rcx
	je .return
	
	mov r8, 0x3FFFFFFFFFFFFFFF
	
	lea r9, [rsi + r8]
	and r9, r8
	inc r9
	cmp r9, 3
	jbe .startSmall
	
	push rbx
	mov r11, r9
	and r11, -4
	
	lea rbx, [r11 - 4]
	mov rcx, rbx
	shr rcx, 2
	inc rcx
	
	mov r10d, ecx
	and r10d, 3
	cmp rbx, 12
	jae .doSSE
	
	xor ecx, ecx
	test r10, r10
	pop rbx
	jne .startSmallSSE
	jmp .doSmall
	
	align 16
.doSSE:
	mov ebx, 1
	sub rdx, rcx
	add rbx, r10
	dec rbx
	xor ecx, ecx
	movq xmm0, rdx
	pshufd xmm0, xmm0, 0x44	; xmm0 = xmm0[0, 1, 0, 1]
	
.sseLoop:
	movdqu xmm1, [arrAddCurrentElement]
	movdqu xmm2, [arrAddCurrentElement + 16]
	movdqu xmm3, [arrAddCurrentElement + 32]
	movdqu xmm4, [arrAddCurrentElement + 48]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [arrAddCurrentElement], xmm1
	movdqu [arrAddCurrentElement + 16], xmm2
	paddq xmm3, xmm0
	paddq xmm4, xmm0
	movdqu [arrAddCurrentElement + 32], xmm3
	movdqu [arrAddCurrentElement + 48], xmm4
	
	movdqu xmm1, [arrAddCurrentElement + 64]
	movdqu xmm2, [arrAddCurrentElement + 80]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [arrAddCurrentElement + 64], xmm1
	movdqu [arrAddCurrentElement + 80], xmm2
	
	movdqu xmm1, [arrAddCurrentElement + 96]
	movdqu xmm2, [arrAddCurrentElement + 112]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [arrAddCurrentElement + 96], xmm1
	movdqu [arrAddCurrentElement + 112], xmm2
	
	add rcx, 16
	add rbx, 4
	jne .sseLoop
	
	test r10, r10
	pop rbx
	je .doSmall
	
.startSmallSSE:
	lea rcx, [arrAddCurrentElement]
	add rcx, 16
	neg r10
	movq xmm0, rdx
	pshufd xmm0, xmm0, 0x44	; xmm0 = xmm0[0, 1, 0, 1]

.smallSSELoop:
	movdqu xmm1, [rcx - 16]
	movdqu xmm2, [rcx]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [rcx - 16], xmm1
	movdqu [rcx], xmm2
	add rcx, 32
	inc r10
	jne .smallSSELoop
	
.doSmall:
	cmp r9, r11
	je .return
	
	sub r11, rsi
	
.startSmall:
	inc r11
	
.smallLoop:
	add [rax + r11 * 8 - 8], rdx
	test r11, r8
	lea r11, [r11 + 1]
	jne .smallLoop
	
.return:
	ret
	
	
	
	
	
	align 16
_arrcnt:
	mov rax, [rdi]
	ret
	
	
	
	
	
	align 16
_arrget:
	mov rax, -1
	test rsi, rsi
	jle .return
	
	mov rax, -2
	cmp [rdi], rsi
	jge .retArrIdx
	
.return:
	ret
	
	align 16
.retArrIdx:
	mov rax, [rdi + rsi * 8]
	ret
	
	
	
	
	
	align 16
_arrlen:
	mov rax, [rdi + rsi * 8]
	mov rax, [rax - 8]
	ret
	
	
	
	
	
	align 16
_arr_mul:
	lea rax, [rdi + rsi * 8]
	
	neg rsi
	movsx rdx, edx
	sal rsi, 2
	je .return
	
.loop:
	mov rcx, [rax + rsi * 2]
	imul rcx, rdx
	mov [rax + rsi * 2], rcx
	
	add rsi, 4
	jne .loop
	
.return:
	ret