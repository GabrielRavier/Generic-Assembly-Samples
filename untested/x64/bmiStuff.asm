global _andn	; int32_t andn(int32_t a1, int32_t a2)
global _blsi	; int32_t blsi(int32_t a1)
global _blsr	; int32_t blsr(int32_t a1)
global _andn64	; int64_t andn64(int64_t a1, int64_t a2)
global _blsi64	; int64_t blsi64(int64_t a1)
global _blsr64	; int64_t blsr64(int64_t a1)

segment .text align=16

_andn:
	not esi
	mov eax, edi
	and eax, esi
	ret
	
	
	
_andnBMI2:
	andn eax, edi, esi
	ret
	
	
	
	
	
_blsi:
	mov eax, edi
	neg eax
	and eax, edi
	ret
	
	
	
_blsiBMI2:
	blsi eax, edi
	
	
	
	
	
_blsr:
	lea eax, [rdi - 1]
	and eax, edi
	ret
	
	
	
_blsrBMI2:
	blsr eax, edi
	ret
	
	
	
	
	
_andn64:
	not rdi
	mov rax, rdi
	and rax, rsi
	ret
	
	
	
_andn64BMI2:
	andn rax, rdi, rsi
	
	
	
	
	
_blsi64:
	mov rax, rdi
	neg rax
	and rax, rdi
	ret
	
	
	
_blsi64BMI2:
	blsi rax, rdi
	ret
	
	
	
	
	
_blsr64:
	lea rax, [rdi - 1]
	and rax, rdi
	ret
	
	
	
_blsr64BMI2:
	blsr rax, rdi
	ret