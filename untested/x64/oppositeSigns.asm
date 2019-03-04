global _oppositeSigns
global _oppositeSigns64


segment .text align=16

_oppositeSigns:
	xor esi, edi
	mov eax, esi
	shr eax, 31
	
	ret
	
	
	
	
	
	align 16
_oppositeSigns64:
	xor rsi, rdi
	shr rsi, 31
	setne al
	
	ret