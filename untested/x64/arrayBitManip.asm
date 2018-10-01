global _setBit	; void setBit(uint8_t *buf, size_t pos)
global _clearBit	; void clearBit(uint8_t *buf, size_t pos)
global _getBit	; bool getBit(uint8_t *buf, size_t pos)

segment .text align=16

_setBit:
	mov rdx, rsi
	mov ecx, esi
	mov eax, 1
	
	shr rdx, 3
	and ecx, 7
	sal eax, cl
	
	or byte [rdi + rdx], al
	ret
	
	
	
_setBitBMI2:
	mov rdx, rsi
	mov eax, 1
	
	and esi, 7
	shr rdx, 3
	shlx esi, eax, esi
	or byte [rdi + rdx], sil
	
	ret
	
	
	
	
	
_clearBit:
	mov ecx, esi
	mov rdx, rsi
	mov eax, 1
	
	and ecx, 7
	shr rdx, 3
	sal eax, cl
	not eax
	
	or byte [rdi + rdx], al
	ret
	
	
	
_clearBitBMI2:
	mov rdx, rsi
	mov eax, 1
	
	and esi, 7
	shr rdx, 3
	shlx esi, eax, esi
	not esi
	
	and byte [rdi + rdx], sil
	ret
	
	
	
	
	
_getBit:
	mov rax, rsi
	mov ecx, esi
	
	shr rax, 3
	and ecx, 7
	
	movzx eax, byte [rsi + rax]
	
	sar eax, cl
	and eax, 1
	
	ret
	
	
	
_getBitBMI2:
	mov rax, rsi
	
	and esi, 7
	shr rax, 3
	
	movzx edx, byte [rdi + rax]
	
	sarx eax, edx, esi
	and eax, 1
	
	ret