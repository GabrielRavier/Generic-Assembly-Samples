global @ASM_combSort@8

segment .text align=16

%define array ecx
%define size edx
%define true 1
%define false 0
%define stackArray 4
%define stackSize 0
%define endOfArray edi
%define gap ebp
%define swapped edx
%define loSwapped dl

@ASM_combSort@8:
    push gap
    push endOfArray
    push esi
    push ebx
    sub esp, 8
    mov dword [esp + stackArray], array
    mov gap, size
    mov dword [esp + stackSize], size

    lea endOfArray, [array + size * 4]
    xor swapped, swapped
    mov ecx, 0x4EC4EC4F

    cmp gap, 1
    jbe .lastChance

.gapSwapLoop:
    lea ebx, [gap + gap * 4]
    add ebx, ebx
    mov eax, ebx
    mul ecx
    shr edx, 2
    mov gap, edx

    cmp dword [esp + stackSize], edx
    jbe .specialGapCheck

.startForLoop:
    mov esi, dword [esp + stackArray]
    lea eax, [esi + gap * 4]
    mov esi, gap
    neg esi
    sal esi, 2
    xor swapped, swapped

.forLoop:
    mov ecx, dword [eax + esi]
    mov ebx, dword [eax]
    cmp ebx, ecx
    jge .noSwap

    mov dword [eax + esi], ebx
    mov dword [eax], ecx

    mov loSwapped, 1

.noSwap:
    add eax, 4

    cmp endOfArray, eax
    jne .forLoop

    mov ecx, 0x4EC4EC4F
    cmp gap, 1
    ja .gapSwapLoop

.lastChance:
    test loSwapped, loSwapped
    je .return

    cmp gap, dword [esp + stackSize]
    jb .startForLoop

.return:
    add esp, 8
    pop ebx
    pop esi
    pop endOfArray
    pop gap
    ret

    align 16
.specialGapCheck:
    cmp ebx, 25 ; ebx / 13 = gap
    ja .gapSwapLoop

    add esp, 8
    pop ebx
    pop esi
    pop endOfArray
    pop gap
    ret

