global @ASM_atoi@4
extern _isspace

segment text

%define stringIndex edi
%define string ecx
%define stringCopy esi
%define tempChar ebp
%define charFromString ebx
%define loCharFromString bl
%define retIsSpace eax
%define checkIsDigit eax
%define loResult eax
%define hiResult edx
%define sign 18h

@ASM_atoi@4:
    push tempChar
    push stringIndex
    push stringCopy
    push charFromString
    xor stringIndex, stringIndex
    mov stringCopy, string
    sub esp, 2Ch
    jmp .skipWhitespaces
    align 16
.incStringIndex:
    inc stringIndex
.skipWhitespaces:
    movsx tempChar, byte [stringCopy + stringIndex]
    mov dword [esp], ebp
    call _isspace
    test retIsSpace, retIsSpace
    jne .incStringIndex
    mov charFromString, tempChar
    cmp loCharFromString, `-`
    je .setMinus
    mov dword [esp + sign], 1
    mov dword [esp + sign+4], 0
    sub tempChar, `+`
    and tempChar, 0xFD
    jz .incIndex
.makeNumLoop:
    lea checkIsDigit, [charFromString - `0`]
    cmp checkIsDigit, 9
    ja .return0
    lea ecx, [stringCopy + stringIndex]
    xor loResult, loResult
    xor hiResult, hiResult
    mov stringCopy, ecx
    mov ebp, 10
    align 16
.innerLoop:
    imul ecx, hiResult, 10
    mul ebp
    add hiResult, ecx
    lea ecx, [ebx - `0`]
    mov ebx, ecx
    sar ebx, 1Fh
    add loResult, ecx
    adc hiResult, ebx
    inc esi
    movsx ebx, byte [stringCopy]
    lea ecx, [ebx - 30h]
    cmp ecx, 9
    jbe .innerLoop
    mov edi, [esp + sign]
    mov esi, [esp + sign+4]
    mov ecx, edi
    imul esi, loResult
    imul ecx, hiResult
    mul edi
    add ecx, esi
    add hiResult, ecx
.return:
    add esp, 2Ch
    pop charFromString
    pop stringCopy
    pop stringIndex
    pop tempChar
    ret
    align 16
.setMinus:
    mov dword [esp + sign], -1
    mov dword [esp + sign+4], -1
.incIndex:
    movsx charFromString, byte [stringCopy + stringIndex]
    inc stringIndex
    jmp .makeNumLoop
.return0:
    xor loResult, loResult
    xor hiResult, hiResult
    jmp .return
