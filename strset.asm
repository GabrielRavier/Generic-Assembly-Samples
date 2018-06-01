global @ASM_strset@8

%define string ecx  ; char *, string to modify
%define val dl      ; char, value to fill string with
%define start eax   ; char *, string, now filled with val
@ASM_strset@8:
    mov start, string ; Immediately set return value since we're changing the pointer
    cmp byte [string], 0    ; Check null terminator
    jz .return
.loop:
    mov [string], val
    inc string
    cmp byte [string], 0
    jnz .loop
.return:
    ret ; Returns start
