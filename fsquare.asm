; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Changed segment to .text and aligned routine
; 1.0.2 : Added "Versions" section
; 1.0.3 : Corrected ret to ret 4

global @ASM_fsquare@4

segment .text align=16

%define number 4
%define result st0
@ASM_fsquare@4:
    fld dword [esp + number]
    fmul result, result
    ret 4
