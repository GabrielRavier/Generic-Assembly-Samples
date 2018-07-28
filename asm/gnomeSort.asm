global @ASM_gnomeSort@8

segment .text align=16

%define array ecx
%define arraySize edx
%define stackArraySize 0
%define last edx
%define i eax
@ASM_gnomeSort@8:
    push ebp
    push edi
    push esi
    push ebx
    sub esp, 4
    mov dword [esp + stackArraySize], arraySize

    cmp arraySize, 1
    jbe .return

    xor last, last
    mov i, 1
    mov ebx, 1
    jmp .swapLoop

.findLoop:
    test last, last
    cmovne i, last

    inc i
    xor last, last

.loopChk:
    mov ebx, i
    cmp dword [esp + stackArraySize], i
    jbe .return

.swapLoop:
    sal ebx, 2
    lea edi, [array + ebx]
    mov esi, dword [edi]
    lea ebx, [array - 4 + ebx]
    mov ebp, dword [ebx]
    cmp esi, ebp
    jge .findLoop

    mov dword [edi], ebp
    mov dword [ebx], esi

    cmp i, 1
    je .swapToChk

    test last, last
    cmove last, i

    dec i

    mov ebx, i
    cmp dword [esp + stackArraySize], i
    ja .swapLoop

.return:
    add esp, 4
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret

.swapToChk:
    mov i, 2
    jmp .loopChk

