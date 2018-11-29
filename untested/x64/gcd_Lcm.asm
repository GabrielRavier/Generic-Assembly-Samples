global _gcd
global _lcm
global _gcd64
global _lcm64

segment .text align=16

_gcd:
	test edi, edi
	je .return0
	
	test esi, esi
	je .return0
	
	cmp esi, edi
	je .returnEsi
	
	jl .bigger
	
	sub esi, edi
	jmp _gcd
	
.bigger:
	sub edi, esi
	jmp _gcd
	
.return0:
	xor eax, eax
	ret
	
.returnEsi:
	mov eax, esi
	ret
	
	
	
	
	
	align 16
_lcm:
	push rbx
	
	mov ebx, esi
	imul ebx, edi
	
	call _gcd
	
	mov ecx, eax
	mov eax, ebx
	
	
	pop rbx
	
	cdq
	idiv ecx
	
	ret
	
	
	
	
	
	align 16
_gcd64:
	test rdi, rdi
	je .return0
	
	test rsi, rsi
	je .return0
	
	cmp rsi, rdi
	je .returnRsi
	
	jl .bigger
	
	sub rsi, rdi
	jmp _gcd64
	
.bigger:
	sub rdi, rsi
	jmp _gcd64
	
.return0:
	xor eax, eax
	ret
	
.returnRsi:
	mov rax, rsi
	ret
	
	
	
	
	
	align 16
_lcm64:
	push rbx
	
	mov rbx, rsi
	imul rbx, rdi
	
	call _gcd64
	
	mov rcx, rax
	mov rax, rbx
	cqo
	idiv rcx
	
	pop rbx
	ret