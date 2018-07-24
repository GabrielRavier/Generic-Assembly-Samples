global @ASM_isPossibleIdentifier@4

segment .text align=16

%define result al
%define character cl
@ASM_isPossibleIdentifier@4:
    mov result, character
    and result, -33
    sub result, `A`
    cmp result, 25
    setbe result

    cmp character, `_`
    sete dl
    or result, dl
    je .checkForNumbers

    ret

.checkForNumbers:
    sub character, `0`
    cmp character, 9
    setbe result

    ret
