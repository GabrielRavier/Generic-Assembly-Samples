global _oppositeSigns	; bool oppositeSigns(int x, int y)
global _oppositeSigns64	; bool oppositeSigns64(int64_t x, int64_t y)

segment .text align=16

_oppositeSigns:
	mov eax, [esp + 4]
	xor eax, [esp + 8]
	shr eax, 31
	ret
	
	
	
	
	
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