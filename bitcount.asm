global @ASM_bitcount@4

segment text

%define result eax
%define number ecx
%define temp edx
@ASM_bitcount@4:
    mov result, number
    mov temp, result
    shr result, 1   ; Shift depending on the current "fence width" (increases)
    and result, 0x55555555    ; The magic numbers are bitmasks with an ever-widening "fence" of 1 and 0s
    and temp, 0x55555555    ; We end up with odd bits in result and even bits in number
    add result, temp
    ; Unrolled loop so it's quicker (and boring)
    mov temp, result
    shr result, 2
    and result, 0x33333333
    and temp, 0x33333333
    add result, temp
    mov temp, result
    shr result, 4
    add result, temp
    and result, 0x0F0F0F0F
    mov temp, result
    shr result, 8
    add result, temp
    mov temp, result
    shr result, 16  ; Last bitmask is 0x0000FFFF so that works too (and it's quicker)
    add result, temp
    and result, 0x03F   ; We apply the second-to-last bitmask here (it's quicker)
    ret
