global @ASM_isSuffix@8
extern @ASM_strlen@4
extern @ASM_strcmp@8
%define ASM_strlen @ASM_strlen@4
%define ASM_strcmp @ASM_strcmp@8

segment .text align=16

%define string ecx
%define suffix edx
%define result eax
%define loResult al
@ASM_isSuffix@8:
    push edi
    push esi
    push ebx
    mov ebx, string
    mov edi, suffix

    call ASM_strlen
    mov esi, result

    mov ecx, edi
    call ASM_strlen

    cmp esi, result
    jl .return0

    sub esi, result
    lea ecx, [ebx + esi]
    mov edx, edi
    call ASM_strcmp
    test result, result

    sete loResult
    movzx result, loResult

    pop ebx
    pop esi
    pop edi
    ret

.return0:
    xor result, result

    pop ebx
    pop esi
    pop edi
    ret

