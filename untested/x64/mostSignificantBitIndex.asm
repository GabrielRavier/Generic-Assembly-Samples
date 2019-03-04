global _mostSignificantBitIndex32

segment .text align=16

_mostSignificantBitIndex32:
	test edi, edi
	je .returnMinus1
	
	bsr eax, edi
	ret
	
.returnMinus1:
	mov eax, -1
	ret
	
	
	
	
	
	align 16
_mostSignificantBitIndex32Alt:
	test edi, edi
	je .returnMinus1
	
	xor eax, eax
	
	test edi, 0xFFFF0000
	je .nope1
	
	shr edi, 16
	mov eax, 16
	
.nope1:
	test edi, 0xFF00
	je .nope2
	
	shr edi, 8
	or eax, 8
	
.nope2:
	test dil, 0xF0
	je .nope3
	
	shr edi, 4
	or eax, 4
	
.nope3:
	test dil, 0xC
	je .nope4
	
	shr edi, 2
	or eax, 2
	
.nope4:
	mov edx, eax
	or edx, 1
	and edi, 2
	cmovne eax, edx
	ret
	
.returnMinus1:
	mov eax, -1
	ret