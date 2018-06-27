global @ASM_strchr@8

segment .text align=16

%define result eax
%define string ecx
%define character edx
@ASM_strchr@8:
    push ebx
    mov result, string
    jmp .startLoop
    align 16

.loop:
    inc result
    test bl, bl
    je .return0

.startLoop:
    movsx ebx, byte [result]
    cmp ebx, character
    jne .loop

    pop ebx
    ret

.return0:
    xor result, result
    pop ebx
    ret
