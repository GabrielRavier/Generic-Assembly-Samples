global @ASM_strncpy@12
extern @ASM_strnlen@8
extern @ASM_memcpy@12
extern @ASM_memset@12
%define ASM_strnlen @ASM_strnlen@8
%define ASM_memcpy @ASM_memcpy@12
%define ASM_memset @ASM_memset@12

segment .text align=16

%define destination ecx
%define source edx
%define maxLen 4
%define startDest esi
%define startSrc ebp
%define regMaxLen ebx
%define strnlenRet eax
%define length edi
%define strnlenStr ecx
%define strnlenMaxLen edx
%define memcpyDest ecx
%define memcpySrc edx
%define memsetDest ecx
%define memsetVal edx
%define result eax

@ASM_strncpy@12:
    push startSrc
    push length
    push startDest
    push regMaxLen
    sub esp, 12

    mov startSrc, source
    mov startDest, destination
    mov strnlenStr, startSrc

    mov regMaxLen, dword [esp + 28 + maxLen]
    mov strnlenMaxLen, regMaxLen
    call ASM_strnlen
    sub esp, 12

    mov length, strnlenRet
    sub regMaxLen, length

    mov memcpyDest, startDest
    mov memcpySrc, startSrc
    push strnlenRet
    call ASM_memcpy

    lea memsetDest, [startDest + length]
    xor memsetVal, memsetVal
    push regMaxLen
    call ASM_memset

    mov result, startDest
    add esp, 24
    pop regMaxLen
    pop startDest
    pop length
    pop startSrc
    ret 4
