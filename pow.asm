; Weird name to avoid linking warning
global @ASM_pow@8

segment test
; According to the __fastcall calling convention, first argument goes to ecx and the second to edx
%define number ecx  ; int
%define power edx   ; int
%define result eax  ; int

@ASM_pow@8:
    mov result, 1
    test power, power
    jle .return   ; power smaller than 1, return 1
.loop:
    imul result, number
    dec power
    jnz .loop   ; while power above 0
.return:
    ret
