; Versions :
; 1.0.0 : Initial commit
; 2.0.0 : Made new faster implementation
; 2.0.1 : Changed segment to .text and aligned function
; 2.0.2 : Added "Versions" section

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
