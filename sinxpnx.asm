global _ASM_sinxpnx
extern _sin

segment text

%define x 4
%define n 12
%define result st0
_ASM_sinxpnx:
    fld qword [esp + x]
    sub esp, 8  ; Space for x
    fstp qword [esp]    ; Store param and clear st0
    call _sin
    add esp, 8
    fild dword [esp + 12]
    fmul qword [esp + 4]    ; result = n * x
    fadd    ; result = sin(x) + n * x
    ret
