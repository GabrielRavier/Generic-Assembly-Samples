global _andn
global _blsi
global _blsr
global _andn64
global _blsi64
global _blsr64

segment .text align=16

_andn:
	not esi
	mov eax, edi
	and eax, esi
	ret
	
	
	
	align 16
_andnBMI2:
	andn eax, edi, esi
	ret
	
	
	
	
	
	align 16
_blsi:
	mov eax, edi
	neg eax
	and eax, edi
	ret
	
	
	
	align 16
_blsiBMI2:
	blsi eax, edi
	ret
	
	
	
	
	
	align 16
_blsr:
	lea eax, [rdi - 1]
	and eax, edi
	ret
	
	
	
	align 16
_blsrBMI2:
	blsr eax, edi
	ret
	
	
	
	
	
	align 16
_andn64:
	not rdi
	mov rax, rdi
	and rax, rsi
	ret
	
	
	
	align 16
_andn64BMI2:
	andn rax, rdi, rsi
	ret
	
	
	
	
	
	align 16
_blsi64:
	mov rax, rdi
	neg rax
	and rax, rdi
	ret
	
	
	
	align 16
_blsi64BMI2:
	blsi rax, rdi
	ret
	
	
	
	
	
	align 16
_blsr64:
	lea rax, [rdi - 1]
	and rax, rdi
	ret
	
	
	
	align 16
_blsr64BMI2:
	blsr rax, rdi
	ret