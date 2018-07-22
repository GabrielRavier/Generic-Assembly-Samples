global @ASM_getGreatestCommonDivider@16
extern _getInstructionSet

segment .data align=16

    actualASM_getGreatestCommonDividerPtr dd actualASM_getGreatestCommonDividerGetPtr

    align 16

    xmmOne dq 1
           dq 0

segment .text align=16

%define loNum1 4
%define hiNum1 8
%define loNum2 12
%define hiNum2 16
%define loResult eax
%define hiResult edx
%define loTemp esi
%define hiTemp edi
actualASM_getGreatestCommonDivider386:
    push hiTemp
    push loTemp
    push ebx
    sub esp, 16
    mov hiResult, dword [esp + 28 + hiNum2]
    mov loResult, dword [esp + 28 + loNum2]
    mov ecx, edx
    mov dword [esp + 8], loResult
    mov edx, eax
    mov eax, ecx
    mov loTemp, dword [esp + 28 + loNum1]
    mov hiTemp, dword [esp + 28 + hiNum1]
    mov dword [esp + 12], ecx

    or eax, hiResult
    je .returnNum1

    mov eax, hiTemp
    or eax, loTemp
    je .returnNum2

    mov dword [esp], loTemp
    mov dword [esp + 4], hiTemp

.checkBothEven:
    xor edx, edx
    mov eax, dword [esp]
    mov ebx, dword [esp + 8]
    and eax, 1
    mov edi, edx
    and ebx, 1
    xor esi, esi
    or edi, eax
    jne .checkOddEven

    mov ecx, dword [esp + 4]
    mov edx, dword [esp]
    shrd edx, ecx, 1
    mov eax, esi
    mov dword [esp], edx
    shr ecx, 1
    or eax, ebx
    mov dword [esp + 4], ecx
    jne .checkIfNum1Is0

    mov ebx, dword [esp + 12]
    mov edi, ecx
    mov ecx, dword [esp + 8]
    shrd ecx, ebx, 1
    shr ebx, 1

    push ebx
    push ecx
    push edi
    push edx
    call actualASM_getGreatestCommonDivider386

    shld hiResult, loResult, 1
    add loResult, loResult
    mov esi, hiResult
    mov ebx, loResult

.returnEbxEsi:
    mov loResult, ebx
    mov hiResult, esi

.return:
    add esp, 16
    pop ebx
    pop esi
    pop edi
    ret 16

.checkNum1GreaterThanNum2:
    mov ecx, dword [esp + 8]
    mov esi, dword [esp]
    mov edi, dword [esp + 4]
    mov ebx, dword [esp + 12]
    cmp esi, ecx
    mov eax, edi
    sbb eax, ebx
    jc .num1SmallerThanNum2

    sub esi, ecx
    sbb edi, ebx
    shrd esi, edi, 1
    shr edi, 1
    mov dword [esp], esi
    mov dword [esp + 4], edi

.checkIfNum1Is0:
    mov edi, dword [esp + 4]
    mov esi, dword [esp]
    mov eax, edi
    or eax, esi
    jne .checkBothEven
    mov ebx, dword [esp + 8]
    mov esi, dword [esp + 12]
    jmp .returnEbxEsi

.checkOddEven:
    mov edi, esi
    or edi, ebx
    jne .checkNum1GreaterThanNum2

    mov hiResult, dword [esp + 12]
    mov loResult, dword [esp + 8]
    shrd loResult, hiResult, 1
    shr hiResult, 1
    mov esi, loResult
    mov dword [esp + 8], loResult
    mov eax, hiResult
    mov dword [esp + 12], hiResult
    or eax, esi
    jne .checkBothEven
    mov esi, dword [esp]
    mov edi, dword [esp + 4]
    jmp .returnNum1

.num1SmallerThanNum2:
    sub ecx, esi
    sbb ebx, edi
    shrd ecx, ebx, 1
    shr ebx, 1
    mov dword [esp + 8], ecx
    mov eax, ebx
    mov dword [esp + 12], ebx
    or eax, ecx
    jne .checkIfNum1Is0

.returnNum1:
    mov loResult, esi
    mov hiResult, edi
    jmp .return

.returnNum2:
    mov loResult, edx
    mov hiResult, ecx
    jmp .return





    align 16
%define hiResult edx
%define loResult eax
%define loTemp esi
%define hiTemp edi
%define xmmNum1 xmm0
%define xmmNum2 xmm2
actualASM_getGreatestCommonDividerSSE42:
    push ebp
    push hiTemp
    push loTemp
    push ebx
    sub esp, 12

    movq xmmNum1, qword [esp + 28 + loNum1]
    pextrd hiResult, xmmNum1, 1
    movq xmmNum2, qword [esp + 28 + loNum2]
    movd loTemp, xmmNum2
    pextrd hiTemp, xmmNum2, 1

    punpcklqdq xmmNum2, xmmNum2
    ptest xmmNum2, xmmNum2
    movd loResult, xmmNum1
    je .returnNum1Part2

.checkIfNum1Is0:
    punpcklqdq xmmNum1, xmmNum1
    ptest xmmNum1, xmmNum1
    je .returnNum2

.checkBothEven:
    movdqa xmm3, oword [xmmOne]
    pand xmm3, xmmNum2
    movdqa xmm1, oword [xmmOne]
    pand xmm1, xmmNum1
    punpcklqdq xmm1, xmm1
    ptest xmm1, xmm1
    jne .checkNum2Even

    psrlq xmmNum1, 1
    movd loResult, xmmNum1
    pextrd hiResult, xmmNum1, 1
    punpcklqdq xmm3, xmm3
    ptest xmm3, xmm3
    jne .checkIfNum1Is0

    ; Now do the recursive call
    movdqa xmm4, xmmNum2
    psrlq xmm4, 1
    movd ecx, xmm4
    pextrd ebx, xmm4, 1

    push ebx
    push ecx
    push hiResult
    push loResult
    call actualASM_getGreatestCommonDividerSSE42
    movd xmmNum1, loResult
    pinsrd xmmNum1, hiResult, 1
    psllq xmmNum1, 1
    movd loResult, xmmNum1
    pextrd hiResult, xmmNum1, 1

.return:
    add esp, 12
    pop ebx
    pop loTemp
    pop hiTemp
    pop ebp
    ret 16

    align 16
.checkNum2Even:
    punpcklqdq xmm3, xmm3
    ptest xmm3, xmm3
    jne .checkNum1NotSmallerThanNum2

    psrlq xmmNum2, 1
    movd loTemp, xmmNum2
    pextrd hiTemp, xmmNum2, 1

    punpcklqdq xmmNum2, xmmNum2
    ptest xmmNum2, xmmNum2
    jne .checkBothEven
    jmp .returnNum1

.checkNum1NotSmallerThanNum2:
    cmp loResult, loTemp
    mov ebp, hiResult
    sbb ebp, hiTemp
    jc .num1SmallerThanNum2

    movdqa xmm5, xmmNum1
    psubq xmm5, xmmNum2
    movdqa xmm6, xmm5
    psrlq xmm6, 1
    movdqa xmmNum1, xmm6
    movd loResult, xmm6
    pextrd hiResult, xmm6, 1

    jmp .checkIfNum1Is0

    align 16
.num1SmallerThanNum2:
    psubq xmmNum2, xmmNum1
    psrlq xmmNum2, 1
    movd loTemp, xmmNum2
    pextrd hiTemp, xmmNum2, 1

    punpcklqdq xmmNum2, xmmNum2
    ptest xmmNum2, xmmNum2
    jne .checkIfNum1Is0

.returnNum1:
    movd loResult, xmmNum1

.returnNum1Part2:
    pextrd hiResult, xmmNum1, 1
    jmp .return

.returnNum2:
    movd loResult, xmmNum2
    pextrd hiResult, xmmNum2, 1
    jmp .return





    align 16
@ASM_getGreatestCommonDivider@16:
    jmp dword [actualASM_getGreatestCommonDividerPtr]

    align 16
%define instructionSet eax
%define SSE42Supported 10
actualASM_getGreatestCommonDividerGetPtr:
    push edi
    push esi
    sub esp, 20

    mov esi, dword [esp + 28 + loNum1]
    mov edi, dword [esp + 28 + hiNum1]
    mov eax, dword [esp + 28 + loNum2]
    mov edx, dword [esp + 28 + hiNum2]

    mov dword [esp + 8], eax
    mov dword [esp + 12], edx

    call _getInstructionSet

    cmp eax, SSE42Supported

    mov eax, actualASM_getGreatestCommonDivider386
    mov edx, actualASM_getGreatestCommonDividerSSE42
    cmovge eax, edx
    mov dword [actualASM_getGreatestCommonDividerPtr], eax

    mov edx, dword [esp + 8]
    mov ecx, dword [esp + 12]
    mov dword [esp + 28 + loNum2], edx
    mov dword [esp + 28 + hiNum2], ecx
    mov dword [esp + 28 + loNum1], esi
    mov dword [esp + 28 + hiNum1], edi

    add esp, 20
    pop esi
    pop edi

    jmp eax
