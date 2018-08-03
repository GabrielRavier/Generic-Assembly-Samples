global @ASM_memmove@12
extern @ASM_bcopy@12
%define ASM_bcopy @ASM_bcopy@12

segment .text align=16

%define destination ecx
%define source edx
%define length 4
%define retVal eax
%define temp ebx

@ASM_memmove@12:
    push temp
    mov temp, destination
    mov ecx, source

    push dword [esp + 4 + length]
    mov edx, temp
    call ASM_bcopy

    mov retVal, temp
    pop temp
    ret 4
