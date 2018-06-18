global @ASM_strcpy@8

segment .text align=16

%define dest ecx
%define src edx
%define result eax
%define index ebx
%define loDest cl
@ASM_strcpy@8:
    push index
    xor index, index
    mov result, dest
    align 16    ; Align the loop

.loop:
    mov loDest, byte [src + index]
    mov byte [result + index], loDest
    inc index
    test loDest, loDest
    jne .loop

    pop index
    ret
