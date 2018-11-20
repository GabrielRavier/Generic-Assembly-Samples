global _oppositeSigns
global _oppositeSigns64

segment .text align=16

_oppositeSigns:
	mov eax, [esp + 4]
	xor eax, [esp + 8]
	shr eax, 31
	ret
	
	
	
	
	
	align 16
_oppositeSigns64:
	xor edx, edx
	mov eax, [esp + 8]
	xor eax, [esp + 16]
	sub eax, edx
	jge .false
	
	mov edx, 1
	
.false:
	mov eax, edx
	ret