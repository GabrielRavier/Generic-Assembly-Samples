global _my_mm_malloc
global _my_mm_free

extern _malloc
extern _free
extern ___errno_location

segment .text align=16

_my_mm_malloc:
	push rbx
	
	lea rax, [rsi - 1]
	test rax, rsi
	jne .notPowOf2
	
	test rdi, rdi
	je .ret0
	
	cmp rsi, 16
	mov ebx, 16
	cmovnb rbx, rsi
	
	add rdi, rbx
	call _malloc
	
	test rax, rax
	je .ret0
	
	lea rdx, [rax + rbx]
	
	neg rbx
	mov rsi, rbx
	and rsi, rbx
	
	mov [rsi - 8], rax
	mov rax, rsi
	pop rbx
	ret
	
	align 16
.ret0:
	xor eax, eax
	pop rbx
	ret
	
	align 16
.notPowOf2:
	call ___errno_location
	mov dword [rax], 22
	
	xor eax, eax
	pop rbx
	ret
	
	
	
	
	
	align 16
_my_mm_free:
	test rdi, rdi
	je .ret
	
	mov rdi, [rdi - 8]
	jmp _free
	
	align 16
.ret:
	ret