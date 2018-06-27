global @ASM_memcmp@12

segment .text align=16

%define buf1 ecx
%define buf2 edx
%define count 4
%define regCount eax
%define cmpTemp bx
%define loCmpTemp bl
%define result eax
@ASM_memcmp@12:
    push cmpTemp

    mov regCount, [esp + 2 + count]
    add regCount, buf2
    jmp .enterLoop
    align 16

.loop:
    inc buf1
    inc buf2
    mov loCmpTemp, byte [buf2 - 1]
    cmp byte [buf1 - 1], loCmpTemp
    jne .foundDiff

.enterLoop:
    cmp buf2, regCount
    jne .loop

    xor result, result

    pop cmpTemp
    ret 4

.foundDiff:
    sbb result, result
    or result, 1

    pop cmpTemp
    ret 4
