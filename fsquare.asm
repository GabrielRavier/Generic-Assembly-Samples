global _ASM_fsquare@4

segment text

%define number 4
%define result st0
_ASM_fsquare@4:
    fld dword [esp + number]
    fmul result, result
    ret
