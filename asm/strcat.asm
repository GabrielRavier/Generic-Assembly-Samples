global @ASM_strcat@8
extern @ASM_strlen@4
extern @ASM_strcpy@8
%define ASM_strlen @ASM_strlen@4
%define ASM_strcpy @ASM_strcpy@8

segment .text align=16

%define destination ecx
%define source edx
%define strlenRet eax
%define result eax
%define strcpyDest ecx
%define strcpySrc edx
@ASM_strcat@8:
    push esi
    push ebx
    sub esp, 4
    mov ebx, destination
    mov esi, source

    call ASM_strlen
    lea strcpyDest, [ebx + strlenRet]
    mov strcpySrc, esi
    call ASM_strcpy

    mov result, ebx
    add esp, 4
    pop ebx
    pop esi
    ret
