global @ASM_memcmp@12

segment .text align=16

%define str1 ecx
%define str2 edx
%define count 4
%define regCount eax
%define cmpTemp bx
%define loCmpTemp bl
%define result eax
@ASM_memcmp@12:
    push cmpTemp

    mov regCount, [esp + 2 + count]
    add regCount, str2
    jmp .enterLoop
    align 16

.loop:
    inc str1
    inc str2
    mov loCmpTemp, byte [str2 - 1]
    cmp byte [str1 - 1], loCmpTemp
    jne .foundDiff

.enterLoop:
    cmp str2, regCount
    jne .loop

    xor result, result

    pop cmpTemp
    ret 4

.foundDiff:
    sbb result, result
    or result, 1

    pop cmpTemp
    ret 4
