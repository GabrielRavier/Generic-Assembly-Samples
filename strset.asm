global @ASM_strset@8
extern @ASM_strlen@4
extern @ASM_memset@12
%define ASM_strlen @ASM_strlen@4
%define ASM_memset @ASM_memset@12

segment .text align=16

%define string ecx  ; char *, string to modify
%define character edx      ; char, value to fill string with
%define strlenRet eax
%define start eax   ; char *, string, now filled with character
%define backCharacter esi
%define backString ebx
@ASM_strset@8:
    push backCharacter
    push backString
    sub esp, 4
    mov backCharacter, character
    mov backString, string

    call ASM_strlen ; string already in ecx
    sub esp, 12
    mov character, backCharacter
    mov string, backString
    push strlenRet
    call ASM_memset

    add esp, 16
    pop backString
    pop backCharacter
    ret
