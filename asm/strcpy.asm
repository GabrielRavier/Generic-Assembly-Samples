global @ASM_strcpy@8
extern @ASM_strlen@4
extern @ASM_memcpy@12
%define ASM_strlen @ASM_strlen@4
%define ASM_memcpy @ASM_memcpy@12

segment .text align=16

%define destination ecx
%define source edx
%define startDest esi
%define startSrc ebx
%define strlenStr ecx
%define strlenRet eax
%define memcpyDest ecx
%define memcpySrc edx
%define result eax
@ASM_strcpy@8:
    push startDest
    push startSrc
    mov startDest, destination

    mov startSrc, source
    sub esp, 4

    mov strlenStr, source
    call ASM_strlen
    sub esp, 12

    mov memcpyDest, startDest
    mov memcpySrc, startSrc
    inc strlenRet
    push strlenRet
    call ASM_memcpy

    add esp, 16
    pop startSrc
    pop startDest
    ret
