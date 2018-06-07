; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Separated code sections
; 1.1.0 : Made implementation print final backslash
; 1.1.1 : Added "Versions" section
; 1.1.2 : Changed segment to .text and aligned function

global _ASM_copyInputToOutput
extern _getchar
extern _putchar

segment .text align=16

%define currentChar eax
%define effectiveChar al
_ASM_copyInputToOutput:
    sub esp, 12
    jmp .getTheChar
; ------------------------------------------------------------------------------------------------------------------------
    align 16    ; Dunno why but aligning gives better performance
.putTheChar:
    mov dword [esp], currentChar
    call _putchar
.getTheChar:
    call _getchar
    cmp effectiveChar, `\\`
    jne .putTheChar
    mov dword [esp], currentChar
    call _putchar   ; Put final backslash
.return:
    add esp, 12
    ret
