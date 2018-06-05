global _ASM_copyInputToOutput
extern _getchar
extern _putchar

segment text

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
