global @ASM_cocktailSort@8

segment .text align=16

%define array ecx
%define arraySize edx
%define swapped ebx
%define loSwapped bl
%define backwardsIterator 4
%define forwardsIterator 0
@ASM_cocktailSort@8:
    push ebp
    push edi
    push esi
    push swapped
    sub esp, 8

    lea eax, [arraySize - 1]
    mov dword [esp + backwardsIterator], eax
    mov esi, array
    lea edi, [array - 4 + arraySize * 4]
    mov dword [esp + forwardsIterator], 0

.whileLoop:
    mov ebx, dword [esp + backwardsIterator]
    cmp dword [esp + forwardsIterator], ebx
    jnb .return
    mov eax, esi

    xor swapped, swapped

.forwardLoop:
    mov edx, dword [eax]
    mov ecx, dword [eax + 4]
    cmp edx, ecx
    jle .noSwapForward

    mov dword [eax], ecx
    mov dword [eax + 4], edx

    mov loSwapped, 1

.noSwapForward:
    add eax, 4

    cmp edi, eax
    jne .forwardLoop

    test loSwapped, loSwapped
    je .return

    xor swapped, swapped

.backwardsLoop:
    mov edx, dword [eax]
    mov ecx, dword [eax - 4]
    cmp ecx, edx
    jle .noSwapBackwards

    mov dword [eax], ecx
    mov dword [eax - 4], edx
    mov loSwapped, 1

.noSwapBackwards:
    sub eax, 4
    cmp esi, eax
    jne .backwardsLoop

    inc dword [esp + forwardsIterator]
    dec dword [esp + backwardsIterator]

    add esi, 4
    sub edi, 4

    test loSwapped, loSwapped
    jne .whileLoop

.return:
    add esp, 8
    pop swapped
    pop esi
    pop edi
    pop ebp
    ret

