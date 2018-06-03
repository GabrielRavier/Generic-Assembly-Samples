global @ASM_bitcount@4

segment text

%define result eax
%define number ecx
%define andComp edx
@ASM_bitcount@4:
    xor result, result  ; bitCount = 0
    test number, number ; Check number equal to 0
    je .returnAligned
.loop:
    mov andComp, number
    and andComp, 1
    cmp andComp, 1
    sbb result, -1
    shr number, 1
    jne .loop
    ret
    align 16
.returnAligned:
    ret
