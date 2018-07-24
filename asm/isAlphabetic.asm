global @ASM_isAlphabetic@4

segment .text align=16

%define character cl
%define result al

@ASM_isAlphabetic@4:
    and character, -33
    sub character, `A`
    cmp character, 25
    setbe result

    ret
