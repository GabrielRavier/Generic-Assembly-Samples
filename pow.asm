; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Changed names for arguments (kinda dumb names before)
; 2.0.0 : Made new quicker implementation of pow
; 2.0.1 : Added seperators and defines to make the code more readable
; 2.0.2 : Changed segment to .text and aligned function
; 2.0.3 : Added "Versions" section
; 2.0.4 : Added separators between code sections

; Weird name to avoid linking warning
global @ASM_pow@8
%define ASM_pow @ASM_pow@8

segment .text align=16
; According to the __fastcall calling convention, first argument goes to ecx and the second to edx
%define base ecx  ; int
%define exponent edx   ; int
%define result eax  ; int
%define startBase ebx
%define startExponent esi

@ASM_pow@8:
    mov result, 1
    test exponent, exponent
    jne .exponentNotZero

    ret ; Return immediately on exponent 0
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.exponentNotZero:
    push startExponent  ; We do the function prolog here because it's not needed until here
    push startBase

    mov startExponent, exponent
    mov startBase, base

    sub esp, 4
    shr exponent, 1
    call ASM_pow ; Do recursive call with exponent divided by 2

    and startExponent, 1    ; Test exponent % 2 == 0
    jne .returnBaseByTempByTemp ; If not use the base

.returnTempByTemp:
    imul result, result ; result is also the recursive call's retval (temp)

    add esp, 4
    pop startBase
    pop startExponent
    ret
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.returnBaseByTempByTemp:
    imul startBase, result  ; result is also the recursive call's retval (temp)
    imul result, startBase

    add esp, 4
    pop startBase
    pop startExponent
    ret
