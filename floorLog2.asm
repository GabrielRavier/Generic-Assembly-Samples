; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Changed segment to .text and aligned routine
; 1.0.2 : Added "Versions" section
; 1.0.3 : Added spacing between code sections

global @ASM_floorLog2@4

segment .text align=16

%define numToFloor ecx
%define result eax
@ASM_floorLog2@4:
    mov result, -1

.loop:
    inc result
    sar numToFloor, 1
    jne .loop

    ret
