global @ASM_memset@12
extern _getInstructionSet

segment .data align=16

    actualASM_memsetPtr dd actualASM_memsetGetPtr

segment .text align=16

%define buffer ecx
%define character edx
%define loCharacter dl
%define result eax
%define size 4
%define regSize esi

actualASM_memset386:
    push ebp
    push edi
    push regSize
    push ebx
    sub esp, 12
    mov result, buffer
    mov regSize, dword [esp + 28 + size]

    test regSize, regSize
    je .return

    mov ebx, result
    lea edi, [regSize - 1]
    neg ebx
    and ebx, 3
    mov cl, loCharacter
    mov dword [esp], ebx
    cmp edi, 7
    jbe .lessThan8Bytes

    test ebx, ebx
    je .noAlign

    lea ebp, [result + 1]
    mov byte [result], loCharacter

    lea edi, [regSize - 2]
    cmp ebx, 1
    je .endAlign

    lea ebp, [result + 2]
    mov byte [result + 1], loCharacter

    lea edi, [regSize - 3]
    cmp ebx, 3
    jne .endAlign

    lea ebp, [result + 3]
    mov byte [result + 2], loCharacter
    lea edi, [regSize - 4]

.endAlign:
    mov ebx, dword [esp]
    sub esi, ebx
    xor ebx, ebx
    mov bl, cl
    mov dword [esp + 4], esi
    movzx ecx, loCharacter
    mov esi, ecx
    mov bh, dl
    sal esi, 16
    sal ecx, 24
    mov dword [esp + 8], esi
    movzx esi, bx
    mov ebx, dword [esp + 8]
    or esi, ebx
    mov ebx, dword [esp]
    or ecx, esi
    mov esi, dword [esp + 4]
    add ebx, result
    and esi, -4
    add esi, ebx

.dwordLoop:
    mov dword [ebx], ecx

    add ebx, 4
    cmp ebx, esi
    jne .dwordLoop

    mov esi, dword [esp + 4]
    mov ebx, esi
    and ebx, -4
    sub edi, ebx
    cmp esi, ebx
    lea ecx, [ebp + ebx]
    je .return

.doTrailingBytes:
    mov byte [ecx], loCharacter
    test edi, edi
    je .return

%macro doTrailingByte386 1
    mov byte [ecx + %1], loCharacter
    cmp edi, %1
    je .return
%endmacro

    doTrailingByte386 1
    doTrailingByte386 2
    doTrailingByte386 3
    doTrailingByte386 4
    doTrailingByte386 5    doTrailingByte386 6

    mov byte [ecx + 7], loCharacter

.return:
    add esp, 12
    pop ebx
    pop regSize
    pop edi
    pop ebp
    ret 4

.noAlign:
    mov ebp, result
    jmp .endAlign

.lessThan8Bytes:
    mov ecx, result
    jmp .doTrailingBytes





    align 16
%define regSize esi
; Contrary to the name, this doesn't use SSE ; it just does 16-bytes at once since that's faster on SSE CPUs.
; It does use conditional move instructions though.
actualASM_memsetSSE:
    push ebp
    push edi
    push esi
    push ebx
    sub esp, 44
    mov result, buffer
    mov regSize, dword [esp + 60 + size]

    lea ecx, [regSize - 1]
    test regSize, regSize
    mov dword [esp + 4], ecx
    je .return

    mov byte [esp + 15], loCharacter
    mov ebx, result
    mov ebp, 23
    neg ebx
    and ebx, 15
    lea edi, [ebx + 15]
    cmp edi, 23
    cmovb edi, ebp
    cmp ecx, edi
    jb .lessThan16Bytes

    test ebx, ebx
    je .noAlign

%macro do1ByteAlignSSE 1
    mov byte [result + %1 - 1], loCharacter
    lea edi, [result + %1]
    cmp ebx, %1
    mov dword [esp + 8], edi

    lea edi, [regSize - %1 - 1]
    mov dword [esp + 4], edi
    je .endAlign
%endmacro

    do1ByteAlignSSE 1
    do1ByteAlignSSE 2
    do1ByteAlignSSE 3
    do1ByteAlignSSE 4
    do1ByteAlignSSE 5
    do1ByteAlignSSE 6
    do1ByteAlignSSE 7
    do1ByteAlignSSE 8

%macro do1ByteAlign2SSE 1
    lea edi, [result + %1]
    cmp ebx, %1
    mov dword [esp + 8], edi
    lea ecx, [regSize - %1 - 1]
    mov byte [result + %1 - 1], loCharacter
    mov dword [esp + 4], ecx
    je .endAlign
%endmacro

    do1ByteAlign2SSE 9
    do1ByteAlign2SSE 10
    do1ByteAlign2SSE 11
    do1ByteAlign2SSE 12
    do1ByteAlign2SSE 13

    lea edi, [result + 14]
    cmp ebx, 15
    mov dword [esp + 8], edi
    lea ecx, [regSize - 15]
    mov byte [result + 13], loCharacter
    mov dword [esp + 4], ecx
    jne .endAlign

    mov byte [result + 14], loCharacter
    lea edi, [result + 15]
    mov dword [esp + 8], edi
    lea ecx, [regSize - 16]
    mov dword [esp + 4], ecx

.endAlign:
    movzx ebp, byte [esp + 15]
    sub esi, ebx
    mov dword [esp + 24], esi
    mov ecx, ebp
    mov edi, ebp
    sal edi, 16
    mov ch, loCharacter
    mov dword [esp + 16], edi
    mov esi, ecx
    mov ecx, ebp
    sal ecx, 24
    or esi, edi
    mov edi, dword [esp + 16]
    mov dword [esp + 20], ecx
    or esi, ecx
    mov ecx, ebp
    mov dword [esp + 28], esi
    mov ch, loCharacter
    mov esi, dword [esp + 16]
    or edi, ecx
    mov ecx, dword [esp + 20]
    or edi, ecx
    mov ecx, ebp
    mov ch, loCharacter
    or esi, ecx
    mov ecx, dword [esp + 20]
    or esi, ecx
    mov ecx, ebp
    mov ebp, dword [esp + 16]
    mov ch, loCharacter
    mov edx, dword [esp + 20]
    or ebp, ecx
    mov ecx, dword [esp + 28]
    or ebp, edx
    lea edx, [result + ebx]
    mov ebx, dword [esp + 24]
    and ebx, -16
    add ebx, edx
    align 16

.dwordLoop:
    mov dword [edx], ecx
    add edx, 16
    mov dword [edx - 12], edi
    mov dword [edx - 8], esi
    mov dword [edx - 4], ebp

    cmp edx, ebx
    jne .dwordLoop

    mov edi, dword [esp + 24]
    mov edx, dword [esp + 8]
    mov ebx, edi
    and ebx, -16
    sub dword [esp + 4], ebx
    add edx, ebx
    cmp edi, ebx
    je .return

.doTrailingBytes:
    mov edi, dword [esp + 4]
    movzx ecx, byte [esp + 15]
    lea ebx, [edx + edi + 1]

.doTrailingBytesLoop:
    mov byte [edx], cl
    inc edx

    cmp edx, ebx
    jne .doTrailingBytesLoop

.return:
    add esp, 44
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.lessThan16Bytes:
    mov edx, result
    jmp .doTrailingBytes

.noAlign:
    mov dword [esp + 8], result
    jmp .endAlign





    align 16
%define regSize ecx
actualASM_memsetSSE2:
    push ebp
    push edi
    push esi
    push ebx
    sub esp, 28
    mov result, buffer
    mov regSize, dword [esp + 44 + size]

    test regSize, regSize
    je .return

    lea esi, [regSize - 1]
    mov byte [esp + 15], loCharacter
    mov ebx, result
    neg ebx
    and ebx, 15
    lea ebp, [ebx + 15]
    cmp ebp, 23
    mov edi, 23
    cmovb ebp, edi
    cmp esi, ebp
    jb .lessThan16Bytes

    test ebx, ebx
    je .skipAlign

%macro do1ByteAlignSSE2 1
    lea ebp, [result + %1]
    mov byte [result + %1 - 1], loCharacter
    lea esi, [regSize - %1 - 1]
    cmp ebx, %1
    je .endAlign
%endmacro

    do1ByteAlignSSE2 1
    do1ByteAlignSSE2 2
    do1ByteAlignSSE2 3
    do1ByteAlignSSE2 4
    do1ByteAlignSSE2 5
    do1ByteAlignSSE2 6
    do1ByteAlignSSE2 7
    do1ByteAlignSSE2 8
    do1ByteAlignSSE2 9
    do1ByteAlignSSE2 10
    do1ByteAlignSSE2 11
    do1ByteAlignSSE2 12
    do1ByteAlignSSE2 13

    lea ebp, [result + 14]
    mov byte [result + 13], loCharacter
    lea esi, [regSize - 15]
    cmp ebx, 15
    jne .endAlign

    lea ebp, [result + 15]
    mov byte [result + 14], loCharacter
    lea esi, [regSize - 16]

.endAlign:
    sub ecx, ebx

    movd xmm0, character
    punpcklbw xmm0, xmm0
    punpcklwd xmm0, xmm0
    pshufd xmm0, xmm0, 0

    add ebx, result
    mov edx, ecx
    and edx, -16
    add edx, ebx
    movzx edi, byte [esp + 15]

.xmmLoop:
    movdqa oword [ebx], xmm0

    add ebx, 16
    cmp ebx, edx
    jne .xmmLoop

    mov ebx, edi
    mov byte [esp + 15], bl
    mov edx, ecx
    and edx, -16
    add ebp, edx
    sub esi, edx
    cmp ecx, edx
    je .return

.doTrailingBytes:
    inc esi
    add esi, ebp
    movzx edx, byte [esp + 15]

.doTrailingBytesLoop:
    mov byte [ebp], dl
    inc ebp

    cmp ebp, esi
    jne .doTrailingBytesLoop

.return:
    add esp, 28
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.lessThan16Bytes:
    mov ebp, result
    jmp .doTrailingBytes

.skipAlign:
    mov ebp, result
    jmp .endAlign





    align 16
%define regSize ecx
actualASM_memsetSSSE3:
    push edi
    push esi
    push ebx
    mov result, buffer
    mov regSize, dword [esp + 12 + size]

    test regSize, regSize
    je .return

    lea esi, [regSize - 1]
    cmp esi, 14
    jbe .lessThan16Bytes

    mov edi, regSize
    movd xmm0, character
    mov ebx, result
    pxor xmm1, xmm1
    and edi, -16
    pshufb xmm0, xmm1
    add edi, result

.xmmLoop:
    movups oword [ebx], xmm0

    add ebx, 16
    cmp ebx, edi
    jne .xmmLoop

    mov edi, buffer
    and edi, -16
    lea ebx, [result + edi]
    sub esi, edi
    cmp buffer, edi
    je .return

.doTrailingBytes:
    mov byte [ebx], loCharacter
    test esi, esi
    je .return

%macro doTrailingByteSSSE3 1
    mov byte [ebx + %1], loCharacter
    cmp esi, %1
    je .return
%endmacro

    doTrailingByteSSSE3 1
    doTrailingByteSSSE3 2
    doTrailingByteSSSE3 3
    doTrailingByteSSSE3 4
    doTrailingByteSSSE3 5
    doTrailingByteSSSE3 6
    doTrailingByteSSSE3 7
    doTrailingByteSSSE3 8
    doTrailingByteSSSE3 9
    doTrailingByteSSSE3 10
    doTrailingByteSSSE3 11
    doTrailingByteSSSE3 12
    doTrailingByteSSSE3 13

    mov byte [ebx + 14], loCharacter

.return:
    pop ebx
    pop esi
    pop edi
    ret 4

.lessThan16Bytes:
    mov ebx, result
    jmp .doTrailingBytes





    align 16
%define regSize esi
actualASM_memsetAVX:
    push ebp
    mov ebp, esp
    push edi
    push regSize
    push ebx
    mov result, buffer
    mov regSize, dword [ebp + 4 + size]

    test regSize, regSize
    je .return

    lea ecx, [regSize - 1]
    mov ebx, character
    cmp ecx, 30
    jbe .lessThan32Bytes

    mov edi, regSize
    vmovd xmm0, character
    mov edx, result
    vpxor xmm1, xmm1, xmm1
    and edi, -32
    vpshufb xmm0, xmm0, xmm1
    vinsertf128 ymm0, ymm0, xmm0, 1
    add edi, result

.avxLoop:
    vmovups oword [edx], xmm0
    vextractf128 oword [edx + 16], ymm0, 1

    add edx, 32
    cmp edx, edi
    jne .avxLoop

    mov edi, esi
    and edi, -32
    lea edx, [result + edi]
    sub ecx, edi
    cmp esi, edi
    je .avxReturn
    vzeroupper

.doTrailingBytes:
    lea ecx, [edx + ecx + 1]

.trailingBytesLoop:
    mov byte [edx], bl
    inc edx

    cmp edx, ecx
    jne .trailingBytesLoop

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.lessThan32Bytes:
    mov edx, result
    jmp .doTrailingBytes

.avxReturn:
    vzeroupper
    jmp .return





    align 16
%define regSize ecx
actualASM_memsetAVX2:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    mov result, buffer
    mov regSize, dword [ebp + 4 + size]

    test regSize, regSize
    je .return

    lea esi, [regSize - 1]
    cmp esi, 30
    jbe .lessThan32Bytes

    vmovd xmm0, character
    vpbroadcastb ymm0, xmm0

    mov ebx, result
    mov edi, regSize
    and edi, -32
    add edi, result

.avxLoop:
    vmovdqu yword [ebx], ymm0

    add ebx, 32
    cmp ebx, edi
    jne .avxLoop

    mov edi, ecx
    and edi, -32
    lea ebx, [result + edi]
    sub esi, edi
    cmp ecx, edi
    je .avxReturn
    vzeroupper

.doTrailingBytes:
    lea esi, [ebx + esi + 1]

.trailingBytesLoop:
    mov byte [ebx], loCharacter
    inc ebx

    cmp ebx, esi
    jne .trailingBytesLoop

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.lessThan32Bytes:
    mov ebx, result
    jmp .doTrailingBytes

.avxReturn:
    vzeroupper
    jmp .return





    align 16
%define SSESupported 3
%define SSE2Supported 4
%define SSSE3Supported 6
%define AVXSupported 11
%define AVX2Supported 13
@ASM_memset@12:
    jmp dword [actualASM_memsetPtr]

    align 16
actualASM_memsetGetPtr:
    push ebx
    sub esp, 24
    mov dword [esp + 12], buffer
    mov dword [esp + 8], character
    mov ebx, [esp + 28 + size]

    call _getInstructionSet

    cmp eax, SSESupported - 1
    mov character, dword [esp + 8]
    mov buffer, dword [esp + 12]
    jg .not386
    mov dword [actualASM_memsetPtr], actualASM_memset386
    jmp .doJmp

.not386:
    cmp eax, SSE2Supported - 1
    jne .notSSE
    mov dword [actualASM_memsetPtr], actualASM_memsetSSE
    jmp .doJmp

.notSSE:
    cmp eax, SSSE3Supported - 1
    jg .notSSE2
    mov dword [actualASM_memsetPtr], actualASM_memsetSSE2
    jmp .doJmp

.notSSE2:
    cmp eax, AVXSupported - 1
    jg .notSSSE3
    mov dword [actualASM_memsetPtr], actualASM_memsetSSSE3
    jmp .doJmp

.notSSSE3:
    cmp eax, AVX2Supported - 1
    jg .notAVX2
    mov dword [actualASM_memsetPtr], actualASM_memsetAVX
    jmp .doJmp

.notAVX2:
    mov dword [actualASM_memsetPtr], actualASM_memsetAVX2

.doJmp:
    mov dword [esp + 28 + size], ebx

    add esp, 24
    pop ebx

    jmp dword [actualASM_memsetPtr]
