; Versions :
; 1.0.0 : Initial commit
; 2.0.0 : Made new version using already-made functions
; 2.0.1 : Changed segment to .text and aligned function
; 2.1.0 : Just jumped directly into memset instead of calling it since we're returning it
; 2.1.1 : Added "Versions" section

; Weird name to avoid linking warning
global @ASM_strnset@12
extern @ASM_strlen@4
extern @ASM_memset@12
%define ASM_strlen @ASM_strlen@4
%define ASM_memset @ASM_memset@12

segment .text align=16

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

    mov backVal, val
    mov backString, string
    mov regCount, [esp + 12 + count]

    call ASM_strlen

    mov val, backVal
    mov string, backString
    cmp strlenRet, regCount
    cmova strlenRet, regCount
    mov dword [esp + 16], strlenRet

    pop regCount
    pop backString
    pop backVal
    jmp ASM_memset  ; (We're returning the string, and memset returns our buffer so this works too)
