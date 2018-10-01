global _gcd	; int32_t gcd(int32_t a1, int32_t a2)
global _lcm	; int32_t lcm(int32_t a1, int32_t a2)
global _gcd64	; int64_t gcd64(int64_t a1, int64_t a2)
global _lcm64	; int64_t lcm64(int64_t a1, int64_t a2)

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