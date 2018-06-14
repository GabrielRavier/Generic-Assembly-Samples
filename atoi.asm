global @ASM_atoi@4
extern _strtol

segment .text align=16

%define string ecx
@ASM_atoi@4:
    sub esp, 16
    push 10
    push 0
    push string
    call _strtol
    add esp, 28
    ret
