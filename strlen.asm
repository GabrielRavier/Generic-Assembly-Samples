global @ASM_strlen@4

segment text

%define string ecx  ; char *, string
%define result eax  ; length of string

@ASM_strlen@4:
    xor result, result
    cmp byte [string], 0
    jz .return
.loop:
    inc result
    cmp byte [string + result], 0
    jnz .loop
.return:
    ret
