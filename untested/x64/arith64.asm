global _add64
global _sub64
global _mul64
global _isEqual64
global _isGreater64
global _divide64
global _modulo64
global _getVal64
global _getOpposite64
global _getComplement64

segment .text align=16

_add64:
	mov rax, [rsi]
	add [rdi], rax
	ret
	
	
	
	
	
_sub64:
	mov rax, [rsi]
	sub [rdi], rax
	ret
	
	
	
	
	
_mul64:
	mov rax, [rdi]
	imul rax, [rsi]
	mov [rdi], rax
	ret
	
	
	
	
	
_isEqual64:
	mov rax, [rsi]
	cmp [rdi], rax
	sete al
	ret
	
	
	
	
	
_isGreater64:
	mov rax, [rsi]
	cmp [rdi], rax
	setg al
	ret
	
	
	
	
	
_divide64:
	mov rax, rdi
	cqo
	idiv rsi
	ret
	
	
	
	
	
_modulo64:
	mov rax, rdi
	cqo
	idiv rsi
	mov rax, rdx
	ret
	
	
	
	
	
_getVal64:
	mov rax, rdi
	ret
	
	
	
	
	
_getOpposite64:
	mov rax, rdi
	neg rax
	ret
	
	
	
	
	
_getComplement64:
	mov rax, rdi
	not rax
	ret