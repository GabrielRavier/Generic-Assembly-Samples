; Weird name to avoid linking warning
global @ASM_pow@8

segment test
; According to the __fastcall calling convention, first argument goes to ecx and the second to edx
%define base ecx  ; int
%define exponent edx   ; int
%define result eax  ; int

@ASM_pow@8:
    mov base, 1
    test exponent, exponent
    jle .return   ; power smaller than 1, return 1
.loop:
    imul base, base
    dec exponent
    jnz .loop   ; while power above 0
.return:
    ret
