; Versions
; 1.0.0 : Initial commit
; 1.0.1 : Added separator after align
; 1.0.2 : Changed segment to .text and aligned function
; 1.0.3 : Added "Versions" section
; 1.0.4 : Separated code sections

; Weird name to avoid linking warning
global @ASM_memchr@12

segment .text align=16
; According to the __fastcall calling convention, first argument goes to ecx and the second to edx

%define buffer ecx
%define character dl
%define result eax
%define regCount edi
%define count 4
@ASM_memchr@12:
    push regCount
    mov regCount, [esp + 4 + count]
    test regCount, regCount
    jz .return0

    lea result, [buffer + 1]
    cmp character, [buffer]
    jz .returnResult

    add buffer, regCount
    cmp buffer, result  ; Unroll first iter
    jz .return0

.compareChar:
    inc result
    cmp [result - 1], character
    jz .returnResult

    cmp buffer, result
    jnz .compareChar

.return0:
    xor result, result
    pop regCount
    ret 4
; ------------------------------------------------------------------------------------------------------------------------
    align 16

.returnResult:
    dec result
    pop regCount
    ret 4
