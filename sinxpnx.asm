; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Added spacing between code sections
; 1.0.2 : Used defined macros instead of magic numbers
; 1.0.3 : Changed segment to .text and aligned routine
; 1.0.4 : Added "Versions" section

global _ASM_sinxpnx
extern _sin

segment .text align=16

%define x 4
%define n 12
%define result st0
_ASM_sinxpnx:
    fld qword [esp + x]

    sub esp, 8  ; Space for x
    fstp qword [esp]    ; Store param and clear st0
    call _sin
    add esp, 8

    fild dword [esp + n]
    fmul qword [esp + x]    ; result = n * x
    fadd    ; result = sin(x) + n * x
    ret
