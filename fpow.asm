global @ASM_fpow@8
%define ASM_fpow @ASM_fpow@8

segment text

%define exponent ecx
%define base 8
%define startExponent ebx
%define loStartExponent bl
%define result st0
%define startBase st1
@ASM_fpow@8:
    fld1    ; Return 1 if exponent 0 (loads 1)
    test exponent, exponent
    jne .exponentNotZero
    ret 4
    align 16
; ------------------------------------------------------------------------------------------------------------------------
.exponentNotZero:
    fstp st0    ; Pop float stack
    push startExponent  ; Function prolog cos we didn't need it before lol
    mov startExponent, exponent
    sub esp, 20
    shr exponent, 31
    add exponent, startExponent
    sar exponent, 1
    push dword [esp + 20 + base]
    call ASM_fpow   ; Recursive call with base (and exponent / 2)
    add esp, 12
    test loStartExponent, 1 ; test exponent % 2 == 0
    je .returnTempByTemp
    test startExponent, startExponent
    jle .returnTempByTempDividedByBase
.returnBaseByTempByTemp:
    fld dword [esp + 8 + base]
    fmul result, startBase
    fmulp startBase, result ; After the mul pop the stack so that startBase becomes the return value
    add esp, 8
    pop startExponent
    ret 4
    align 16
; ------------------------------------------------------------------------------------------------------------------------
.returnTempByTempDividedByBase:
    fmul result, result
    fdiv dword [esp + 8 + base]
    add esp, 8
    pop startExponent
    ret 4
    align 16
; ------------------------------------------------------------------------------------------------------------------------
.returnTempByTemp:
    fmul result, result
    add esp, 8
    pop startExponent
    ret 4
