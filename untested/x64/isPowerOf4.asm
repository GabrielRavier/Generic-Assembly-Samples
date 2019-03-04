global _isPowerOf4
global _isPowerOf464

segment .text align=16

_isPowerOf4:
	test edi, edi
	je .return0
	
	cmp edi, 1
	je .return1
	
	test dil, 3
	je .startLoop
	jmp .return0
	
	align 16
.loop:
	test dil, 3
	jne .return0
	
.startLoop:
	test edi, edi
	lea eax, [rdi + 3]
	cmovs edi, eax
	sar edi, 2
	
	cmp edi, 1
	jne .loop
	
.return1:
	mov eax, 1
	ret
	
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_isPowerOf464:
	test rdi, rdi
	je .return0
	
	cmp rdi, 1
	je .return1
	
.loop:
	mov rdx, rdi
	sar rdx, 1
	shr rdx, 62
	add rdx, rdi
	sar edx, 2
	lea rax, [rdx * 4]
	cmp rax, rdi
	jne .return0
	
	mov rdi, rdx
	cmp rdx, 1
	jne .loop
	
.return1:
	mov eax, 1
	ret
	
.return0:
	xor eax, eax
	ret