global @ASM_getProcessorName@0

segment .data
    align 16
    nameBuffer times 50h db 0   ; Static buffer for name

segment .text align=16

@ASM_getProcessorName@0:
    mov eax, nameBuffer
    ret
