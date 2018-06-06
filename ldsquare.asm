global _ASM_ldsquare@12

segment .text align=16

%define number 4
%define result st0
_ASM_ldsquare@12:
    fld tword [esp + number]
    fmul result, result
    ret 0Ch
