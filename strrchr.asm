global @ASM_strrchr@8

%define result eax
%define string ecx
%define character dl
@ASM_strrchr@8:
    mov result, string
.findEndOfStringLoop:   ; First find end of string
    inc result
    cmp byte [result - 1], 0
    jnz .findEndOfStringLoop
    dec result
    cmp string, result
    jz .charNotFound    ; Oops string has only one character
.findCharLoop:
    cmp [result], character
    jz .return  ; Character found
    dec result
    cmp string, result  ; Till we're back at the start
    jnz .findCharLoop
; If we're back at the start the character was not found
.charNotFound:
    xor result, result      ; Reset result (return NULL if not found)
    cmp [string], character ; Maybe first char is a match ?
    cmovz result, string    ; If so, point result at first char
.return:
    ret
