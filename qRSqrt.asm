; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Added "Versions" section

global @ASM_qRSqrt@4

segment .data

    flt0Point5  dd 0.5
    flt1Point5  dd 1.5

segment .text align=16

%define magicNumber 0x5f3759df
%define regMagicNumber edx
%define regNumber eax
%define number 4
@ASM_qRSqrt@4:
    sub esp, 4
    mov regMagicNumber, magicNumber
    mov regNumber, [esp + 4 + number]
    sar regNumber, 1
    sub regMagicNumber, regNumber
    mov dword [esp], regMagicNumber
    fld dword [esp + 4 + number]
    fmul dword [flt0Point5]
    fmul dword [esp]
    fmul dword [esp]
    fsubr dword [flt1Point5]
    fmul dword [esp]
    add esp, 4
    ret 4
