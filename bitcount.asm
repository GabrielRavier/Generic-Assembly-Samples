global @ASM_bitcount@4

segment text

%define result eax
%define loResult ax
%define number ecx
%define temp edx
@ASM_bitcount@4:
    mov result, number
    shr number, 1   ; Shift depending on the current "fence width" (increases)
    and result, 0x55555555    ;  The magic numbers are bitmasks with an ever-widening "fence" of 1 and 0s
    and number, 0x55555555
    add result, number
    ; Unrolled loop so it's quicker (and boring)
    mov temp, result
    shr result, 2
    and temp, 0x33333333
    and result, 0x33333333
    add result, temp
    mov temp, result
    shr result, 4
    and temp, 0x0F0F0F0F
    and result, 0x0F0F0F0F
    add result, temp
    mov temp, result
    shr result, 8
    and temp, 0x00FF00FF
    and result, 0x00FF00FF
    add result, temp
    movzx temp, loResult
    shr result, 16  ; Last bitmask is 0x0000FFFF so that works too (and it's quicker)
    add result, temp
    ret
