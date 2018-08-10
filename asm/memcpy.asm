; Performance for copying a 100000 bytes buffer for all the versions (lower is better) :
; 386 : 32210/10185 = 3.16
; SSE : 11108/10042 = 1.11
; std version : 10086/10036 = 1.00
; SSE2 : 10380/10607 = 0.98
; AVX : 7632/9294 = 0.82
; Calculated by using the clocks taken by the algorithm divided by the clocks taken by the std version

global @ASM_memcpy@12
extern _getInstructionSet

segment .data align=16

    actualASM_memcpyPtr dd actualASM_memcpyGetPtr

segment .text align=16

%define destination ecx
%define source edx
%define result eax
%define length 4
%define regLength ecx

actualASM_memcpy386:
    push ebp
    mov result, destination
    push edi
    push esi
    push ebx
    sub esp, 4
    mov regLength, dword [esp + 20 + length]

    test regLength, regLength
    je .return

    mov esi, source
    mov edx, result
    or edx, esi
    and edx, 3
    jne .doMovsb

    lea ebp, [regLength - 1]
    cmp ebp, 3
    jbe .doMovsb

    mov edx, regLength
    mov ebx, esi
    mov edi, result
    mov dword [esp], result
    and edx, -4
    add edx, esi

.dwordLoop:
    mov eax, dword [ebx]
    add ebx, 4
    add edi, 4
    mov dword [edi - 4], eax

    cmp ebx, edx
    jne .dwordLoop

    mov eax, dword [esp]
    mov ebx, ecx
    and ebx, -4
    add esi, ebx
    sub ebp, ebx
    lea edi, [eax + ebx]
    cmp ecx, ebx
    je .return

    movzx ecx, byte [esi]
    mov byte [edi], cl

    test ebp, ebp
    je .return

    movzx edx, byte [esi + 1]
    mov byte [edi + 1], dl

    cmp ebp, 1
    je .return

    movzx ebx, byte [esi + 2]
    mov byte [edi + 2], bl

.return:
    add esp, 4
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.doMovsb:
    add ecx, result
    mov edi, result

.movsbLoop:
    movsb

    cmp edi, ecx
    jne .movsbLoop

    add esp, 4
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4





    align 16
%define regLength ecx
actualASM_memcpySSE:
    push ebp
    mov result, destination
    push edi
    push esi
    push ebx
    mov regLength, dword [esp + 16 + length]

    test regLength, regLength
    je .return

    mov esi, source
    mov edx, result
    or edx, esi
    and edx, 15
    jne .doMovsb

    lea ebx, [regLength - 1]
    cmp ebx, 14
    jbe .doMovsb

    mov ebp, regLength
    mov edx, esi
    mov edi, result
    and ebp, -16
    add ebp, esi

.xmmLoop:
    movaps xmm0, oword [edx]
    add edx, 16
    add edi, 16
    movaps oword [edi - 16], xmm0

    cmp edx, ebp
    jne .xmmLoop

    mov ebp, regLength
    and ebp, -16
    lea edi, [eax + ebp]
    sub edx, ebp
    lea esi, [esi + ebp]
    cmp ecx, ebp
    je .return

    movzx ecx, byte [esi]
    mov byte [edi], cl

    test ebx, ebx
    je .return

%macro doTrailingByteSSEedx 1
    movzx edx, byte [esi + %1]
    mov byte [edi + %1], dl
    cmp ecx, %1
    je .return
%endmacro

%macro doTrailingByteSSEecx 1
    movzx ecx, byte [esi + %1]
    mov byte [edi + %1], cl
    cmp ecx, %1
    je .return
%endmacro

    doTrailingByteSSEedx 1
    doTrailingByteSSEecx 2
    doTrailingByteSSEedx 3
    doTrailingByteSSEecx 4
    doTrailingByteSSEedx 5
    doTrailingByteSSEecx 6
    doTrailingByteSSEedx 7
    doTrailingByteSSEecx 8
    doTrailingByteSSEedx 9
    doTrailingByteSSEecx 10
    doTrailingByteSSEedx 11
    doTrailingByteSSEecx 12
    doTrailingByteSSEedx 13

    movzx ebx, byte [esi + 14]
    mov byte [edi + 14], bl

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.doMovsb:
    add ecx, result
    mov edi, result

.movsbLoop:
    movsb

    cmp edi, ecx
    jne .movsbLoop

    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4





    align 16
%define regLength edi
actualASM_memcpySSE2:
    push ebp
    mov result, destination
    push edi
    push esi
    push ebx
    mov regLength, dword [esp + 16 + length]

    test regLength, regLength
    je .return

    lea ebx, [regLength - 1]
    cmp ebx, 14
    jbe .noXmm

    mov ebp, edi
    mov ecx, edx
    mov esi, eax
    and ebp, -16
    add ebp, edx

.xmmLoop:
    movdqu xmm0, oword [ecx]
    add ecx, 16
    add esi, 16
    movups oword [esi - 16], xmm0

    cmp ecx, ebp
    jne .xmmLoop

    mov ecx, edi
    and ecx, -16
    lea esi, [result + ecx]
    add edx, ecx
    sub edx, ecx
    cmp edi, ecx
    je .return

.doTrailingBytes:

    movzx ecx, byte [edx]
    mov byte [esi], cl
    test ebx, ebx
    je .return

%macro doTrailingByteSSE2 1
    movzx ecx, byte [edx + %1]
    mov byte [esi + %1], cl
    cmp ebx, %1
    je .return
%endmacro

    doTrailingByteSSE2 1
    doTrailingByteSSE2 2
    doTrailingByteSSE2 3
    doTrailingByteSSE2 4
    doTrailingByteSSE2 5
    doTrailingByteSSE2 6
    doTrailingByteSSE2 7
    doTrailingByteSSE2 8
    doTrailingByteSSE2 9
    doTrailingByteSSE2 10
    doTrailingByteSSE2 11
    doTrailingByteSSE2 12
    doTrailingByteSSE2 13

    movzx edx, byte [edx + 14]
    mov byte [esi + 14], dl

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.noXmm:
    mov esi, destination
    jmp .doTrailingBytes





    align 16
%define regLength edi
actualASM_memcpyAVX:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    and esp, -32
    sub esp, 32
    mov result, destination

    mov regLength, dword [ebp + 4 + length]
    lea ebx, [regLength - 1]
    mov dword [esp + 28], ebx

    test regLength, regLength
    je .return

    mov esi, source
    cmp ebx, 30
    jbe .lessThan32

    and regLength, -32
    add regLength, source

.avxLoop:
    vmovdqu ymm0, yword [source]
    vmovdqu yword [destination], ymm0

    add source, 32
    add destination, 32
    cmp source, regLength
    jne .avxLoop

    mov ebx, dword [ebp + 4 + length]
    and ebx, -32
    lea edi, [result + ebx]
    add esi, ebx
    sub dword [esp + 28], ebx
    vzeroupper
    cmp dword [ebp + 4 + length], ebx
    je .return

.doMovsb:
    mov edx, dword [esp + 28]
    lea ecx, [esi + edx + 1]

.movsbLoop:
    movsb

    cmp esi, ecx
    jne .movsbLoop

.return:
    lea esp, [ebp - 12]
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.lessThan32:
    mov edi, destination
    jmp .doMovsb


    align 16
%define SSESupported 3
%define SSE2Supported 4
%define SSSE3Supported 6
%define AVXSupported 11
%define AVX2Supported 13
@ASM_memcpy@12:
    jmp dword [actualASM_memcpyPtr]

    align 16
actualASM_memcpyGetPtr:
    push ebx
    sub esp, 24
    mov dword [esp + 12], destination
    mov dword [esp + 8], source
    mov ebx, dword [esp + 28 + length]

    call _getInstructionSet

    cmp eax, SSESupported - 1
    mov source, dword [esp + 8]
    mov destination, dword [esp + 12]
    jg .not386

    mov dword [actualASM_memcpyPtr], actualASM_memcpy386
    jmp .doJmp

.not386:
    cmp eax, SSE2Supported - 1
    jne .notSSE

    mov dword [actualASM_memcpyPtr], actualASM_memcpySSE
    jmp .doJmp

.notSSE:
    cmp eax, SSSE3Supported - 1
    jg .notSSE2

    mov dword [actualASM_memcpyPtr], actualASM_memcpySSE2
    jmp .doJmp

.notSSE2:
    mov dword [actualASM_memcpyPtr], actualASM_memcpyAVX

.doJmp:
    mov dword [esp + 28 + length], ebx

    add esp, 24
    pop ebx
    jmp dword [actualASM_memcpyPtr]

