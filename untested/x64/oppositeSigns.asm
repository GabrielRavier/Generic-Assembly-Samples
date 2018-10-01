global _oppositeSigns	; bool oppositeSigns(int32_t a1, int32_t a2)
global _oppositeSigns64	; bool oppositeSigns64(int64_t a1, int64_t a2)


segment .text align=16

_oppositeSigns:
	xor esi, edi
	mov eax, esi
	shr eax, 31
	
	ret
	
	
	
	
	
_oppositeSigns64:
	xor rsi, rdi
	shr rsi, 31
	setne al
	
	ret