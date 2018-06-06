; Weird name to avoid linking warning
global @ASM_strnset@12
extern @ASM_strlen@4
extern @ASM_memset@12
%define ASM_strlen @ASM_strlen@4
%define ASM_memset @ASM_memset@12

%define string ecx  ; char *, string to modify
%define val edx      ; char, value to fill string with
%define result eax   ; char *, string, now filled with val
%define count 4     ; stack pos of count
%define backVal edi
%define backString ebx
%define regCount esi
%define strlenRet eax
@ASM_strnset@12:
    push backVal
    push backString
    push regCount
    sub esp, 16

    mov backVal, val
    mov backString, string
    mov regCount, [esp + 28 + count]

    call ASM_strlen

    mov val, backVal
    mov string, backString
    cmp strlenRet, regCount
    cmova strlenRet, regCount
    mov dword [esp], strlenRet

    call ASM_memset ;
    add esp, 12 ; -4 + 16 = 12
    pop regCount    ; We just return the memset retval (memset returns the buffer sent to it)
    pop backString
    pop backVal
    ret
