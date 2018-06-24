global @ASM_memmove@12
extern @ASM_bcopy@12
%define ASM_bcopy @ASM_bcopy@12

segment .text align=16

%define destination ecx
%define source edx
%define length 4
%define retVal eax
%define backDest ebx

@ASM_memmove@12:
    push backDest
    mov backDest, destination
    mov ecx, source

    push dword [esp + 4 + length]
    mov edx, backDest
    call ASM_bcopy

    mov retVal, backDest
    pop backDest
    ret 4
