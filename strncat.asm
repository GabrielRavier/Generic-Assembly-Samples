global @ASM_strncat@12
extern @ASM_strlen@4
extern @ASM_memcpy@12
extern @ASM_strnlen@8
%define ASM_strlen @ASM_strlen@4
%define ASM_memcpy @ASM_memcpy@12
%define ASM_strnlen @ASM_strnlen@8

segment .text align=16

%define destination ecx
%define source edx
%define count 4
%define startSrc edi
%define startDest esi
%define strlenRet eax
%define strnlenMaxLen edx
%define strnlenStr ecx
%define strnlenRet eax
%define memcpyDest ecx
%define memcpySrc edx
%define result eax

@ASM_strncat@12:
    push startSrc
    push startDest
    push ebx

    mov startSrc, source
    mov startDest, destination

;   mov strlenStr, destination  ; ecx = destination = strlenStr
    call ASM_strlen
    lea ebx, [startDest + strlenRet]

    mov strnlenMaxLen, dword [esp + 12 + count]
    mov strnlenStr, startSrc
    call ASM_strnlen
    sub esp, 12
    mov byte [ebx + strnlenRet], 0

    mov memcpySrc, startSrc
    mov memcpyDest, ebx
    push strnlenRet
    call ASM_memcpy

    add esp, 12
    mov result, startDest
    pop ebx
    pop startDest
    pop startSrc
    ret 4
