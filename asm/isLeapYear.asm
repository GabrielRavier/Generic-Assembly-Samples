global @ASM_isLeapYear@4
%define ASM_isLeapYear @ASM_isLeapYear@4

segment .text align=16

%define year ecx
%define result eax
%define true 1

ASM_isLeapYear:
    mov eax, year
    mov edx, 0x51EB851F

    push ebx
    mul edx
    mov result, true
    mov ebx, edx
    shr ebx, 7
    imul ebx, 400
    cmp ecx, ebx
    jz .return

    shr edx, 5
    xor result, result
    imul edx, 100
    cmp ecx, edx
    jz .return

    and ecx, 3
    setz al

.return:
    pop ebx
    ret
