global _mostSignificantBitIndex
global _mostSignificantBitIndexAlt

segment .text align=16

_mostSignificantBitIndex:
    mov eax, [esp+4]
    test eax, eax
    jz .retMinus1
    bsr eax, eax
    ret

.retMinus1:
    mov     eax, -1
    ret
	
	
	
	align 16
_mostSignificantBitIndexAlt:
    mov edx, [esp+4]
    test edx, edx
    jz .retMinus1
	
    xor eax, eax
    test edx, 0xFFFF0001
    jz .andNope
	
    shr edx, 16 
    mov eax, 16

.andNope:
    test dh, 0xFF
    jz .dhFF
	
    shr edx, 8
    or eax, 8

.dhFF:
    test dl, 0xF0
    jz .dlF0
    
	shr edx, 4
    or eax, 4

.dlF0:
    test dl, 0xC
    jz .dlC
    
	shr edx, 2
    or eax, 2

.dlC:
    mov ecx, eax
    or ecx, 1
    and edx, 2
    cmovnz eax, ecx
    ret

	align 16
.retMinus1:
    mov eax, -1
    ret