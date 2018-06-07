; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Changed segment to .text and aligned routine
; 1.0.2 : Added "Versions" section

global _ASM_ldsquare@12

segment .text align=16

%define number 4
%define result st0
_ASM_ldsquare@12:
    fld tword [esp + number]
    fmul result, result
    ret 0Ch
