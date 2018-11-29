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
global _shiftLeft64
global _shiftRight64
global _rol64
global _ror64

segment .text align=16

_add64:
	lea rax, [rdi + rsi]
	ret
	
	
	
	
	
	align 16
_sub64:
	mov rax, rdi
	sub rax, rsi
	ret
	
	
	
	
	
	align 16
_mul64:
	mov rax, rdi
	imul rax, rsi
	ret
	
	
	
	
	
	align 16
_isEqual64:
	cmp rdi, rsi
	sete al
	ret
	
	
	
	
	
	align 16
_isGreater64:
	cmp rdi, rsi
	setg al
	ret
	
	
	
	
	
	align 16
_divide64:
	mov rax, rdi
	cqo
	idiv rsi
	ret
	
	
	
	
	
	align 16
_modulo64:
	mov rax, rdi
	cqo
	idiv rsi
	mov rax, rdx
	ret
	
	
	
	
	
	align 16
_getVal64:
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_getOpposite64:
	mov rax, rdi
	neg rax
	ret
	
	
	
	
	
	align 16
_getComplement64:
	mov rax, rdi
	not rax
	ret
	
	
	
	
	
	align 16
_shiftLeft64:
	mov ecx, esi
	shl rdi, cl
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_shiftRight64:
	mov ecx, esi
	sal rdi, cl
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_rol64:
	mov ecx, esi
	rol rdi, cl
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_ror64:
	mov ecx, esi
	rol rdi, cl
	mov rax, rdi
	ret