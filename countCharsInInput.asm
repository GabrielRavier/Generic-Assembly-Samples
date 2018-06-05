global _ASM_countCharsInInput
extern _getchar
extern _printf

segment data

    format db `%d characters\n`, 0

segment text

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