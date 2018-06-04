global @ASM_fpow@8
%define ASM_fpow @ASM_fpow@8

segment text

%define exponent ecx
%define base 12
%define startExponent ebx
%define loStartExponent bl
%define result st0
%define startBase st1
@ASM_fpow@8:
    test exponent, exponent
    jne .exponentNotZero

    fld1
    ret 12
    align 16
; ------------------------------------------------------------------------------------------------------------------------
.exponentNotZero:
    push startExponent  ; Function prolog cos we didn't need it before lol
    mov startExponent, exponent
    sub esp, 28

    shr exponent, 31
    add exponent, startExponent
    sar exponent, 1
    push dword [esp + 32 + base]    ; esp goes back each time so yeah
    push dword [esp + 32 + base]
    push dword [esp + 32 + base]
    call ASM_fpow   ; Recursive call with base (and exponent / 2)
    pop eax ; (We don't do anything with this)

    fstp dword [esp + base]
    fld dword [esp + base]

    test loStartExponent, 1
    je .returnTempByTemp ; Jump if exponent % 2 != 0

    test startExponent, startExponent
    jle .returnTempByTempDividedByBase

    fld tword [esp + 24 + base]
    fmul result, startBase
    fmulp startBase, result

.return:
    add esp, 24
    pop startExponent
    ret
; ------------------------------------------------------------------------------------------------------------------------
.returnTempByTemp
    fmul result, result
    jmp .return
    align 16
; ------------------------------------------------------------------------------------------------------------------------
.returnTempByTempDividedByBase:
    fmul result, result
    fld tword [esp + 24 + base]
    fdivp startBase, result
    jmp .return
