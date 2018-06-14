global @ASM_strset@8
extern @ASM_strlen@4
extern @ASM_memset@12
%define ASM_strlen @ASM_strlen@4
%define ASM_memset @ASM_memset@12

segment .text align=16

%define string ecx  ; char *, string to modify
%define character edx      ; char, value to fill string with
%define backString esi
%define backChar ebx
%define loBackChar bl
%define result eax
%define strlenRet eax
%define memsetPtr ecx
%define memsetVal edx
@ASM_strset@8:
    push backString
    push backChar
    sub esp, 4
    mov backString, string
    mov backChar, character

    call ASM_strlen
    sub esp, 12
    movsx memsetVal, loBackChar
    mov memsetPtr, backString
    inc strlenRet
    push strlenRet
    call ASM_memset ; return (char *)ASM_memset(string, val, ASM_strlen(string) + 1);

    add esp, 16
    pop backChar
    pop backString
    ret

