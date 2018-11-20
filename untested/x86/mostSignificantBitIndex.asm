global _mostSignificantBitIndex
global _mostSignificantBitIndexAlt

segment .text align=16

_mostSignificantBitIndex:
    mov     eax, [esp+4]
    test    eax, eax
    jz      .retMinus1
    bsr     eax, eax
    ret

.retMinus1:
    mov     eax, -1
    ret
	
	
	
	align 16
_mostSignificantBitIndexAlt:
    mov     edx, [esp+4]
    test    edx, edx
    jz      .retMinus1
    xor     eax, eax
    test    edx, 0xFFFF0001
    jz      .L3
    shr     edx, 16 
    mov     eax, 16

.L3:
    test    dh, 0xFF
    jz      .L4
    shr     edx, 8
    or      eax, 8

.L4:
    test    dl, 0xF0
    jz      .L5
    shr     edx, 4
    or      eax, 4

.L5:
    test    dl, 0xC
    jz      .L6
    shr     edx, 2
    or      eax, 2

.L6:
    mov     ecx, eax
    or      ecx, 1
    and     edx, 2
    cmovnz  eax, ecx
    ret

	align 16
.retMinus1:
    mov     eax, -1
    ret