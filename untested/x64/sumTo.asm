global _sumTo
global _sumTo64

segment .text align=16

_sumTo:
	test edi, edi
	je .ret0
	
	lea eax, [rdi - 1]
	lea ecx, [rdi - 2]
	imul rcx, rax
	shr rcx, 1
	lea eax, [rcx + rdi - 1]
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_sumTo64:
	test rdi, rdi
	je .ret0
	
	lea rax, [rdi - 1]
	lea rcx, [rdi - 2]
	mul rcx
	shld rdx, rax, 63
	lea rax, [rax + rdi - 1]
	ret
	
	
	align 16
.ret0:
	xor eax, eax
	ret