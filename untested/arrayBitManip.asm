global _setBit	; void setBit(uint8_t *buf, size_t pos)
global _clearBit	; void clearBit(uint8_t *buf, size_t pos)
global _getBit	; bool getBit(uint8_t *buf, size_t pos)

segment .text align=16

_setBit:
	mov ecx, [esp + 8]
	
	mov edx, 1
	mov eax, ecx
	and ecx, 7
	shr eax, 3
	add eax, [esp + 4]
	sal edx, cl
	or byte [eax], dl
	ret
	
	
	
	
	
_clearBit:
	mov ecx, [esp + 8]
	
	mov eax, 1
	mov edx, ecx
	and ecx, 7
	shr edx, 3
	add edx, dword [esp + 4]
	sal eax, cl
	not eax
	and byte [edx], al
	ret
	
	
	
	
	
_getBit:
	mov ecx, [esp + 8]
	mov edx, [esp + 4]
	
	mov eax, ecx
	and ecx, 7
	shr eax, 3
	movzx eax, byte [edx + eax]
	sar eax, cl
	and eax, 1
	ret