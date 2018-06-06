global @ASM_strrchr@8

segment .text align=16

%define result eax
%define string ecx
%define character edx
%define currentCharacter ebx
%define loCurrentCharacter bl
@ASM_strrchr@8:
    xor result, result
    push currentCharacter
    movsx currentCharacter, byte [string]
    test loCurrentCharacter, loCurrentCharacter
    je .return
 .loop:
    cmp character, currentCharacter
    cmovz result, string
    inc string
    movsx currentCharacter, byte [string]
    test loCurrentCharacter, loCurrentCharacter
    jne .loop
.return:
    pop currentCharacter
    ret
