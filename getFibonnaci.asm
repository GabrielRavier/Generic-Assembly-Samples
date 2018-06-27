global @ASM_getFibonacci@4
extern _getInstructionSet

segment .data align=16

    actualASM_getFibonacciPtr dd actualASM_getFibonacciGetPtr

segment .rodata align=16

    owordOne dq 1
             dq 0

segment .text align=16

%define number ecx
%define loResult eax
%define hiResult edx
%define loopCnt ebp
%define loTemp ecx
%define hiTemp ebx
%define loTemp2 esi
%define hiTemp2 edi
actualASM_getFibonacci386:
    push loopCnt
    push hiTemp2
    push loTemp2
    push hiTemp
    sub esp, 12
    mov dword [esp + 4], number

    cmp number, 1
    jbe .return1
    mov loopCnt, 1

    mov loTemp, 1
    xor hiTemp, hiTemp

    xor loTemp2, loTemp2
    xor hiTemp2, hiTemp2

.loop:
    mov loResult, loTemp2
    mov hiResult, hiTemp2

    add loResult, loTemp
    adc hiResult, hiTemp

    inc loopCnt
    mov loTemp2, loTemp
    mov hiTemp2, hiTemp

    mov loTemp, loResult
    mov hiTemp, hiResult

    cmp dword [esp + 4], loopCnt
    jne .loop

    add esp, 12
    pop hiTemp
    pop loTemp2
    pop hiTemp2
    pop loopCnt
    ret

.return1:
    mov loResult, 1
    xor hiResult, hiResult

    add esp, 12
    pop hiTemp
    pop loTemp2
    pop hiTemp2
    pop loopCnt
    ret





    align 16
%define loopCnt ebx
%define loResult eax
%define hiResult edx
actualASM_getFibonacciSSSE3:
    cmp number, 1
    jbe .return1

    push loopCnt
    mov loopCnt, 1

    movdqa xmm1, oword [owordOne]

    pxor xmm0, xmm0

.loop:
    movdqa xmm3, xmm0
    paddq xmm3, xmm1
    movdqa xmm0, xmm3
    movd loResult, xmm3
    psrlq xmm0, 32
    movd hiResult, xmm0

    inc loopCnt
    movdqa xmm0, xmm1
    movdqa xmm1, xmm3

    cmp number, loopCnt
    jne .loop

    pop loopCnt
    ret

    align 16
.return1:
    mov loResult, 1
    xor hiResult, hiResult
    ret





    align 16
%define loopCnt ebx
actualASM_getFibonacciSSE42:
    cmp number, 1
    jbe .return1

    push loopCnt
    mov loopCnt, 1

    movdqa xmm1, oword [owordOne]
    pxor xmm2, xmm2

.loop:
    movdqa xmm3, xmm2
    paddq xmm3, xmm1
    movd loResult, xmm3
    pextrd hiResult, xmm3, 1

    inc loopCnt
    movdqa xmm2, xmm1
    movdqa xmm1, xmm3

    cmp number, loopCnt
    jne .loop

    pop loopCnt
    ret

.return1:
    mov loResult, 1
    xor hiResult, hiResult
    ret





    align 16
%define loopCnt ebx
actualASM_getFibonacciAVX:
    cmp number, 1
    jbe .return1
    push loopCnt
    mov loopCnt, 1

    vmovdqa xmm1, oword [owordOne]
    vpxor xmm2, xmm2, xmm2

.loop:
    vpaddq xmm0, xmm2, xmm1
    vmovd loResult, xmm0
    vpextrd hiResult, xmm0, 1

    inc loopCnt
    vmovdqa xmm2, xmm1
    vmovdqa xmm1, xmm0

    cmp number, loopCnt
    jne .loop

    pop loopCnt
    ret

.return1:
    vmovdqa xmm0, oword [owordOne]
    vmovd loResult, xmm0
    vpextrd hiResult, xmm0, 1
    ret


    align 16
%define SSSE3Supported 6
%define SSE42Supported 10
%define AVXSupported 11
@ASM_getFibonacci@4:
    jmp dword [actualASM_getFibonacciPtr]

    align 16
actualASM_getFibonacciGetPtr:
    sub esp, 28
    mov dword [esp + 12], number

    call _getInstructionSet

    cmp eax, SSSE3Supported - 1
    mov number, dword [esp + 12]
    jg .not386
    mov dword [actualASM_getFibonacciPtr], actualASM_getFibonacci386
    jmp .doJmp

.not386:
    cmp eax, SSE42Supported - 1
    jg .notSSSE3
    mov dword [actualASM_getFibonacciPtr], actualASM_getFibonacciSSSE3
    jmp .doJmp

.notSSSE3:
    cmp eax, AVXSupported - 1
    jg .notSSE42
    mov dword [actualASM_getFibonacciPtr], actualASM_getFibonacciSSE42
    jmp .doJmp

.notSSE42:
    mov dword [actualASM_getFibonacciPtr], actualASM_getFibonacciAVX

.doJmp:
    add esp, 28
    jmp dword [actualASM_getFibonacciPtr]
