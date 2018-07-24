global @ASM_bzero@8
extern @ASM_memset@12
%define ASM_memset @ASM_memset@12

segment .text align=16

%define size edx
%define memsetCharacter edx
@ASM_bzero@12:
    sub esp, 24

    push size
    xor memsetCharacter, memsetCharacter
    call ASM_memset

    add esp, 24
    ret
