global _isPowerOf2	; bool isPowerOf2(int32_t a1)
global _isPowerOf264	; bool isPowerOf264(int64_t a1)

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
	
	
	
_isPowerOf2BMI2:
	xor eax, eax
	
	test edi, edi
	je .return
	
	blsr eax, edi
	sete al
	
.return:
	ret
	
	
	
	
	
_isPowerOf264:
	xor eax, eax
	
	test rdi, rdi
	je .return
	
	lea rax, [rdi - 1]
	test rax, rdi
	sete al
	
.return:
	ret
	
	
	
_isPowerOf264BMI2:
	xor eax, eax
	
	test rdi, rdi
	je .return
	
	blsr rax, rdi
	sete al
	
.return:
	ret