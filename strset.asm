; Versions :
; 1.0.0 : Initial commit
; 2.0.0 : Made implementation using other faster functions
; 2.0.1 : Changed segment to .text and aligned function
; 2.0.2 : Added "Versions" section
; 2.1.0 : Made implementation directly jump to memset since that's faster (we return its result so it works)

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
    mov [esp + 16], strlenRet   ; Length gotten via strlen
    add esp, 4
    mov character, backCharacter
    mov string, backString
    ; Function prolog before jump to before to not have to make the call
    pop backCharacter
    pop backString
    jmp ASM_memset
