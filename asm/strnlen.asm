global @ASM_strnlen@8
extern @ASM_memchr@12
%define ASM_memchr @ASM_memchr@12

segment .text align=16

%define string ecx
%define maxLength edx
%define startString esi
%define startMaxLength ebx
%define searchedChar edx
%define searchedString ecx
%define result eax
%define memchrRet eax
@ASM_strnlen@8:
    push startString
    push startMaxLength
    mov startString, string
    mov startMaxLength, maxLength
    sub esp, 16

    push maxLength
    xor searchedChar, searchedChar
;   mov searchedString, string  ; Both are ecx
    call ASM_memchr

    mov edx, memchrRet
    sub edx, startString
    test memchrRet, memchrRet
    mov result, startMaxLength
    cmovne result, edx

    add esp, 16
    pop startMaxLength
    pop startString
    ret
