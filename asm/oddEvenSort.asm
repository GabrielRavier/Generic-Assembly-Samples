global @ASM_oddEvenSort@8

segment .text align=16

%define array ecx
%define arraySize edx
%define swapped ebx
%define loSwapped bl
%define true 1
@ASM_oddEvenSort@8:
    push ebp
    push edi
    push esi
    push swapped
    lea esi, [arraySize - 1]
    lea eax, [array * 4 - 12]
    and eax, -8
    lea edi, [array + eax + 12]

.whileLoop:
    lea eax, [array + 4]
    xor swapped, swapped
    cmp esi, 1
    jbe .skipFirstLoop

.firstLoop:
    mov edx, dword [eax]
    mov ebp, dword [eax + 4]
    cmp edx, ebp
    jle .noSwap1

    mov dword [eax], ebp
    mov dword [eax + 4], edx
    mov loSwapped, true

.noSwap1:
    add eax, 8
    cmp edi, eax
    jne .firstLoop

.endFirstLoop:
    xor eax, eax

.secondLoop:
    mov edx, dword [array + eax * 4]
    mov ebp, dword [array + 4 + eax * 4]
    cmp ebp, edx
    jge .noSwap2

    mov dword [array + eax * 4], ebp
    mov dword [array + 4 + eax * 4], edx
    mov loSwapped, 1

.noSwap2:
    add eax, 2
    cmp eax, esi
    jb .secondLoop

    test loSwapped, loSwapped
    jne .whileLoop

.return:
    pop swapped
    pop esi
    pop edi
    pop ebp
    ret

    align 16
.skipFirstLoop:
    test esi, esi
    jne .endFirstLoop
    jmp .return

