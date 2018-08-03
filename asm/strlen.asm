global @ASM_strlen@4

segment .text align=16

%define string ecx
%define result eax
@ASM_strlen@4:
    cmp byte [string], 0
    je .return0

    mov result, string

.loop:
    lea edx, [result + 1]
    mov result, edx
    cmp byte [edx], 0
    je .return

    inc result
    cmp byte [result], 0
    je .return

%macro checkByte 1
    lea result, [edx + %1]
    cmp byte [edx + %1], 0
    je .return
%endmacro

    checkByte 2
    checkByte 3
    checkByte 4
    checkByte 5
    checkByte 6

    lea result, [edx + 7]
    cmp byte [edx + 7], 0
    jne .loop

.return:
    sub result, string
    ret

.return0:
    xor result, result
    ret
