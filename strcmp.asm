global @ASM_strcmp@8
extern @ASM_strlen@4
extern @ASM_memcmp@12
%define ASM_strlen @ASM_strlen@4
%define ASM_memcmp @ASM_memcmp@12

segment .text align=16

%define str1 ecx
%define str2 edx
%define strlenStr ecx
%define strlenRet eax
%define memcmpBuf1 ecx
%define memcmpBuf2 edx


@ASM_strcmp@8:
    push edi
    push esi
    push ebx
    mov ebx, str1
    mov esi, str2

    call ASM_strlen
    mov edi, strlenRet

    mov strlenStr, esi
    call ASM_strlen

    lea edx, [edi + 1]
    lea ecx, [strlenRet + 1]
    cmp edi, strlenRet
    cmovb ecx, edx
    sub esp, 12
    push ecx
    mov memcmpBuf2, esi
    mov memcmpBuf1, ebx
    call ASM_memcmp
    add esp, 12

    pop ebx
    pop esi
    pop edi
    ret
