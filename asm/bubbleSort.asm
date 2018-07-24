global @ASM_bubbleSort@8

segment .text align=16

%define array ecx
%define arraySize edx
%define arraySizeMinus1 edi
%define i esi
@ASM_bubbleSort@8:
    test arraySize, arraySize
    jle .return

    push ebp
    push arraySizeMinus1
    push i
    push ebx
    lea arraySizeMinus1, [arraySize - 1]
    test arraySizeMinus1, arraySizeMinus1
    jle .properReturn

    lea ebp, [array - 8 + arraySize * 4]

    xor i, i

.forwardLoop:
    mov eax, ebp
    mov edx, arraySizeMinus1

.backwardsLoop:
    mov ebx, dword [eax]
    mov ecx, dword [eax + 4]

    cmp ebx, ecx
    jle .noSwapNeeded

    mov dword [eax + 4], ebx
    mov dword [eax], ecx

.noSwapNeeded:
    dec edx
    sub eax, 4
    cmp i, edx
    jl .backwardsLoop

    inc i
    cmp i, arraySizeMinus1
    jl .forwardLoop

.properReturn:
    pop ebx
    pop i
    pop arraySizeMinus1
    pop ebp
    ret
    align 16

.return:
    ret
