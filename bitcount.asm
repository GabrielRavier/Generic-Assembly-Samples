global @ASM_bitcount@4

segment text

%define result eax
%define number ecx
%define andComp edx
@ASM_bitcount@4:
    xor result, result  ; bitCount = 0
    test number, number ; Check number equal to 0
    jz .return
.loop:
    mov andComp, number
    and andComp, 1
    add result, andComp ; Add 1 if next byte 1
    shr number, 1   ; Discard first byte
    jnz .loop   ; Loop if number not zero (shr sets flags)
.return:
    ret
