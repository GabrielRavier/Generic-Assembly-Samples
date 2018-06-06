global @ASM_square@4
global @ASM_square64@8

segment .text align=16

%define result eax
%define number ecx
@ASM_square@4:
    mov result, number
    imul result, number
    ret

%define loNumber 4
%define hiNumber 8
%define loResult eax
%define hiResult edx
%define temp ecx
@ASM_square64@8:
    mov loResult, [esp + loNumber]
    mov temp, [esp + hiNumber]
    imul temp, loResult
    mul loResult
    add temp, temp
    add hiResult, temp
    ret 8
