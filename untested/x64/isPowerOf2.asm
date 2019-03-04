global _isPowerOf2
global _isPowerOf264

segment .text align=16

_isPowerOf2:
	xor eax, eax
	
	test edi, edi
	je .return
	
	lea eax, [rdi - 1]
	test eax, edi
	sete al
	
.return:
	ret
	
	
	
	align 16
_isPowerOf2BMI2:
	xor eax, eax
	
	test edi, edi
	je .return
	
	blsr eax, edi
	sete al
	
.return:
	ret
	
	
	
	
	
	align 16
_isPowerOf264:
	xor eax, eax
	
	test rdi, rdi
	je .return
	
	lea rax, [rdi - 1]
	test rax, rdi
	sete al
	
.return:
	ret
	
	
	
	align 16
_isPowerOf264BMI2:
	xor eax, eax
	
	test rdi, rdi
	je .return
	
	blsr rax, rdi
	sete al
	
.return:
	ret