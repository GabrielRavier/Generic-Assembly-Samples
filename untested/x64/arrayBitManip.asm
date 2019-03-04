global _setBit
global _clearBit
global _getBit

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
	
	
	
	align 16
_setBitBMI2:
	mov rdx, rsi
	mov eax, 1
	
	and esi, 7
	shr rdx, 3
	shlx esi, eax, esi
	or byte [rdi + rdx], sil
	
	ret
	
	
	
	
	
	align 16
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
	
	
	
	align 16
_clearBitBMI2:
	mov rdx, rsi
	mov eax, 1
	
	and esi, 7
	shr rdx, 3
	shlx esi, eax, esi
	not esi
	
	and byte [rdi + rdx], sil
	ret
	
	
	
	
	
	align 16
_getBit:
	mov rax, rsi
	mov ecx, esi
	
	shr rax, 3
	and ecx, 7
	
	movzx eax, byte [rsi + rax]
	
	sar eax, cl
	and eax, 1
	
	ret
	
	
	
	align 16
_getBitBMI2:
	mov rax, rsi
	
	and esi, 7
	shr rax, 3
	
	movzx edx, byte [rdi + rax]
	
	sarx eax, edx, esi
	and eax, 1
	
	ret