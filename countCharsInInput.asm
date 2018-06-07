; Versions :
; 1.0.0 : Initial commit
; 1.1.0 : Changed string to make it look nice
; 1.1.1 : Renamed from countCharsInLine.asm to countCharsInInput.asm (also changed routine name obviously
; 1.1.2 : Changed segment to .text and aligned function
; 1.1.3 : Added "Versions" section

global _ASM_countCharsInInput
extern _getchar
extern _printf

segment .data

    align 16
    format db `%d characters\n`, 0

segment .text align=16

%define currentChar eax
%define charCount esi   ; int
_ASM_countCharsInInput:
    push charCount
    sub esp, 8
    call _getchar
    xor charCount, charCount
    dec charCount     ; We inc before the check so we need to start at -1
.countLoop:
    call _getchar
    inc charCount
    cmp currentChar, `\\`
    jne .countLoop
    sub esp, 8  ; Allocate space for arguments
    push charCount
    push format
    call _printf
.return:
    add esp, 24
    pop charCount
    ret
