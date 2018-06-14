global @ASM_fpow@16
%define ASM_fpow @ASM_fpow@16

segment .data

    align 16
    decimalOne  dd 1.0

segment .text align=16

%define exponent ecx
%define tempExponent edx
%define absExponent eax
%define loAbsExponent al
%define result st0
%define base 4
@ASM_fpow@16:
    fld tword [esp + base]

    mov tempExponent, exponent
    sar tempExponent, 31
    mov absExponent, tempExponent
    xor absExponent, exponent
    sub absExponent, tempExponent   ; Get absolute value of exponent

    fld1    ; st0 = 1, st1 = base

    test exponent, exponent
    je .returnOne   ; Jump if exponent == 0
    jmp .startLoop
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.loop:
    fxch st1

.startLoop:
    test loAbsExponent, 1   ; Jump if absExponent & 1 != 0
    je .onlySquare

    fmul result, st1    ; Multiply if first bit of absExponent == 1
    fxch st1
    jmp .doSquare
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.onlySquare:
    fxch st1
.doSquare:
    fmul result, result ; Square base

    shr absExponent, 1  ; Get next bit (also check for exp == 0)
    jne .loop   ; Loop for each bit in exponent
    fstp result

    test exponent, exponent
    jns .return

    fdivr dword [decimalOne]    ; Reciprocal if n is negative

    jmp .return
; ------------------------------------------------------------------------------------------------------------------------
.returnOne:
    fstp st1
.return:
    ret 12
