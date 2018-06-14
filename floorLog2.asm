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
