; Weird name to avoid linking warning
global @ASM_strnset@12

%define string ecx  ; char *, string to modify
%define val dl      ; char, value to fill string with
%define start eax   ; char *, string, now filled with val
%define count 4     ; stack pos of count
%define regCount esi ; count of characters to fill
@ASM_strnset@12:
    push regCount
    mov start, string
    mov regCount, [esp + 4 + count]
    test regCount, regCount
    jz .return
    cmp byte [string], 0
    jz .return
    add regCount, string    ; regCount now a pointer to last allowed bytes
    mov [string], val
    inc string
    cmp string, regCount    ; Do start of loop
    jz .return
.loop:
    cmp byte [string], 0
    jz .return
    mov [string], val
.loopStart:
    inc string
    cmp string, regCount
    jnz .loop
.return:
    pop regCount
    ret
