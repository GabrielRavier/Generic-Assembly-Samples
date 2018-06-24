global @ASM_reverseString@4
extern @ASM_strlen@4
%define ASM_strlen @ASM_strlen@4

segment .text align=16

%define string ecx
%define strlenRet eax
%define result eax
@ASM_reverseString@4:
    push esi
    push ebx
    sub esp, 4
    mov esi, string

    test string, string
    je .returnString

    cmp byte [string], 0
    jne .doReverse

.returnString:
    mov result, esi
    add esp, 4
    pop ebx
    pop esi
    ret

.doReverse:
    call ASM_strlen
    lea eax, [strlenRet + esi - 1]

    cmp esi, eax
    jnb .returnString

    mov edx, esi

.loop:
    mov cl, byte [edx]
    mov bl, byte [eax]
    mov byte [edx], bl
    mov byte [eax], cl

    inc edx
    dec eax
    cmp edx, eax
    jb .loop

    mov result, esi
    add esp, 4
    pop ebx
    pop esi
    ret
