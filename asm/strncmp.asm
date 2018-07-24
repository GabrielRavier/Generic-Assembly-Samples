global @ASM_strncmp@12

segment .text align=16

%define count 4
%define regCount esi
%define count4 edi
%define str1 ecx
%define str2 edx
%define tmpChar eax
%define tmpChar2 ebx
%define loTmpChar al
%define loTmpChar2 bl
%define result eax
@ASM_strncmp@12:
    push count4
    push regCount
    push tmpChar2
    mov regCount, dword [esp + 12 + count]

    cmp regCount, 3
    jbe .skipBigComp

    mov ebx, regCount
    and ebx, -4
    lea count4, [str1 + ebx]

.dwordLoop:
    movzx tmpChar, byte [str1]
    movzx tmpChar2, byte [str2]

    test loTmpChar, loTmpChar
    je .foundChar
    cmp loTmpChar, loTmpChar2
    jne .foundChar

    movzx tmpChar, byte [str1 + 1]
    movzx tmpChar2, byte [str2 + 1]

    test loTmpChar, loTmpChar
    je .foundChar
    cmp loTmpChar, loTmpChar2
    jne .foundChar

    movzx tmpChar, byte [str1 + 2]
    movzx tmpChar2, byte [str2 + 2]

    test loTmpChar, loTmpChar
    je .foundChar
    cmp loTmpChar, loTmpChar2
    jne .foundChar

    movzx tmpChar, byte [str1 + 3]
    movzx tmpChar2, byte [str2 + 3]

    add str1, 4
    add str2, 4

    test loTmpChar, loTmpChar
    je .foundChar
    cmp loTmpChar, loTmpChar2
    jne .foundChar

    cmp count4, str1
    jne .dwordLoop

    and regCount, 3
    jmp .doEndBytes
    align 16

.skipBigComp:
    xor tmpChar, tmpChar
    xor tmpChar2, tmpChar2

.doEndBytes:
    ; regCount is smaller than 4 at this point so yeah
    test regCount, regCount
    je .foundChar

    movzx tmpChar, byte [str1]
    movzx tmpChar2, byte [str2]

    test loTmpChar, loTmpChar
    je .foundChar
    cmp loTmpChar2, loTmpChar
    jne .foundChar

    dec regCount
    je .foundChar

    movzx tmpChar,  byte [str1 + 1]
    movzx tmpChar2, byte [str2 + 1]

    test loTmpChar, loTmpChar
    je .foundChar
    cmp loTmpChar2, loTmpChar
    jne .foundChar

    cmp regCount, 1
    je .foundChar

    movzx tmpChar,  byte [str1 + 2]
    movzx tmpChar2, byte [str2 + 2]

.foundChar:
    movzx count4, loTmpChar2
;   mov result, tmpChar
    sub result, count4
    pop tmpChar2
    pop regCount
    pop count4
    ret 4
