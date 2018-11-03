global _mulx	; uint32_t mulx(uint32_t __X, uint32_t __Y, uint32_t *__P)

segment .text align=16

_mulx:
	mov eax, [esp + 4]
	mul dword [esp + 8]
	mov ecx, [esp + 12]
	mov [ecx], edx
	ret
	
	
	
_mulxBMI2:
	mov ecx, [esp + 12]
	mov edx, [esp + 4]
	mulx edx, eax, [esp + 8]
	mov [ecx], edx
	ret