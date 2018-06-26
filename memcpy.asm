global @ASM_memcpy@12
extern _getInstructionSet

segment .data align=16

    actualASM_memcpyPtr dd actualASM_memcpyGetPtr

segment .text align=16

%define destination ecx
%define source edx
%define result eax
%define length 4

actualASM_memcpy386:
    push ebp
    push edi
    push esi
    push ebx
    push ebx
    mov result, destination
    mov ecx, dword [esp + 20 + length]

    test ecx, ecx
    je .return

    mov esi, source
    lea edx, [result + 4]
    cmp esi, edx
    lea ebp, [ecx - 1]
    lea edx, [esi + 4]
    setnb bl
    cmp result, edx
    setnb dl
    or ebx, edx
    cmp ebp, 12
    seta dl
    test bl, dl
    je .doMovsb

    mov edx, result
    or edx, esi
    and edx, 3
    jne .doMovsb

    mov edx, ecx
    mov ebx, esi
    and edx, -4
    mov edi, result
    add edx, esi
    mov dword [esp], result

.dwordLoop:
    mov eax, dword [ebx]
    add ebx, 4
    mov dword [edi], eax
    add edi, 4

    cmp ebx, edx
    jne .dwordLoop

    mov ebx, ecx
    mov result, dword [esp]
    and ebx, -4
    add esi, ebx
    sub ebp, ebx
    lea edi, [result + ebx]
    cmp ecx, ebx
    je .return

    mov cl, byte [esi]
    test ebp, ebp
    mov byte [edi], cl
    je .return

    mov cl, byte [esi + 1]
    dec ebp
    mov byte [edi + 1], cl
    je .return

    mov cl, byte [esi + 2]
    mov byte [edi + 2], cl

.return:
    pop edx
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4
    align 16

.doMovsb:
    add ecx, result
    mov edi, result

.movsbLoop:
    movsb

    cmp edi, ecx
    jne .movsbLoop

    pop edx
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4





    align 16
actualASM_memcpySSE:
    push ebp
    push edi
    push esi
    push ebx
    mov result, destination
    mov edi, dword [esp + 16 + length]

    test edi, edi
    je .return

    lea ebx, [edi - 1]
    mov esi, source
    lea edx, [destination + 16]
    lea ecx, [esi + 16]
    cmp esi, edx
    setnb dl
    cmp result, ecx
    setnb cl
    or dl, cl
    cmp ebx, 14
    seta cl
    test dl, cl
    je .doMovsb

    mov edx, result
    or edx, esi
    test dl, 15
    jne .doMovsb

    mov ebp, edi
    mov edx, esi
    and ebp, -16
    mov ecx, eax
    add ebp, esi

.xmmLoop:
    movaps xmm0, oword [edx]
    add edx, 16
    add ecx, 16
    movaps oword [ecx - 16], xmm0

    cmp edx, ebp
    jne .xmmLoop

    mov ebp, edi
    and ebp, -16
    add esi, ebp
    sub ebx, ebp
    lea ecx, [result + ebp]
    cmp edi, ebp
    je .return

    movzx edx, byte [esi]
    test ebx, ebx
    mov byte [ecx], dl
    je .return

%macro doAByteSSE 1
    movzx edx, byte [esi + %1]
    cmp ebx, %1
    mov byte [ecx + %1], dl
    je .return
%endmacro
    doAByteSSE 1
    doAByteSSE 2
    doAByteSSE 3
    doAByteSSE 4
    doAByteSSE 5
    doAByteSSE 6
    doAByteSSE 7
    doAByteSSE 8
    doAByteSSE 9
    doAByteSSE 10
    doAByteSSE 11
    doAByteSSE 12
    doAByteSSE 13

    movzx ebx, byte [esi + 14]
    mov byte [ecx + 14], bl

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.doMovsb:
    lea edx, [result + edi]
    mov edi, result

.movsbLoop:
    movsb

    cmp edi, edx
    jne .movsbLoop

    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4





    align 16
actualASM_memcpySSE2:
    push ebp
    push edi
    push esi
    push ebx
    sub esp, 28
    mov result, destination
    mov ebp, dword [esp + 44 + length]

    test ebp, ebp
    je .return

    mov esi, source
    lea source, [source + 16]
    cmp destination, source
    setnb bl
    lea edx, [destination + 16]
    cmp esi, edx
    setnb dl
    or bl, dl
    je .doMovsb

    lea ecx, [ebp - 1]
    cmp ecx, 29
    jbe .doMovsb

    mov edx, esi
    neg edx
    and edx, 15
    je .skipAlign

%macro byteAlignSSE2 1
    lea edi, [esi + %1]
    lea ebx, [result + %1]
    movzx ecx, byte [esi + %1 - 1]
    mov byte [result + %1 - 1], cl
    lea ecx, [ebp - %1 - 1]
    cmp edx, %1
    je .doXmm
%endmacro

    byteAlignSSE2 1
    byteAlignSSE2 2
    byteAlignSSE2 3
    byteAlignSSE2 4
    byteAlignSSE2 5
    byteAlignSSE2 6
    byteAlignSSE2 7
    byteAlignSSE2 8
    byteAlignSSE2 9
    byteAlignSSE2 10
    byteAlignSSE2 11
    byteAlignSSE2 12
    byteAlignSSE2 13

    lea edi, [esi + 14]
    lea ebx, [result + 14]
    movzx ecx, byte [esi + 13]
    mov byte [result + 13], cl
    lea ecx, [ebp - 15]
    cmp edx, 15
    jne .doXmm

    lea edi, [esi + 15]
    lea ebx, [result + 15]
    movzx ecx, byte [esi + 14]
    mov byte [result + 14], cl
    lea ecx, [ebp - 16]

.doXmm:
    sub ebp, edx
    mov dword [esp + 12], ebp
    add esi, edx
    add edx, result
    and ebp, -16
    add ebp, esi

.xmmLoop:
    movdqa xmm0, oword [esi]
    movdqu oword [edx], xmm0

    add esi, 16
    add edx, 16
    cmp esi, ebp
    jne .xmmLoop

    mov esi, dword [esp + 12]
    mov edx, esi
    and edx, -16
    add ebx, edx
    add edi, edx
    sub ecx, edx
    cmp esi, edx
    je .return

    movzx edx, byte [edi]
    mov byte [ebx], dl
    test ecx, ecx
    je .return

%macro doTrailingBytesSSE2 1
    movzx edx, byte [edi + %1]
    mov byte [ebx + %1], dl
    cmp ecx, %1
    je .return
%endmacro

    doTrailingBytesSSE2 1
    doTrailingBytesSSE2 2
    doTrailingBytesSSE2 3
    doTrailingBytesSSE2 4
    doTrailingBytesSSE2 5
    doTrailingBytesSSE2 6
    doTrailingBytesSSE2 7
    doTrailingBytesSSE2 8
    doTrailingBytesSSE2 9
    doTrailingBytesSSE2 10
    doTrailingBytesSSE2 11
    doTrailingBytesSSE2 12
    doTrailingBytesSSE2 13

    movzx ecx, byte [edi + 14]
    mov byte [ebx + 14], cl

.return:
    add esp, 28
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.doMovsb:
    add ebp, result
    mov edi, result

.movsbLoop:
    movsb

    cmp edi, ebp
    jne .movsbLoop

    add esp, 28
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.skipAlign:
    mov edi, esi
    mov ebx, result
    jmp .doXmm





    align 16
actualASM_memcpySSSE3:
    push ebp
    push edi
    push esi
    push ebx
    sub esp, 28
    mov result, destination
    mov ecx, dword [esp + 44 + length]

    lea ebp, [ecx - 1]
    mov dword [esp + 12], ebp
    test ecx, ecx
    je .return

    mov esi, edx
    lea edx, [edx + 16]
    cmp result, edx
    setnb dl
    mov edi, edx
    lea edx, [result + 16]
    cmp result, edx
    setnb dl
    mov edi, edx
    lea edx, [result + 16]
    mov ebx, edi
    cmp esi, edx
    setnb dl
    or bl, dl
    je .doMovsb
    cmp ebp, 14
    jbe .doMovsb
    mov ebp, ecx
    mov edx, esi
    mov edi, result
    and ebp, -16
    add ebp, esi

.xmmLoop:
    movdqu xmm0, oword [edx]
    add edx, 16
    add edi, 16
    movups oword [edi - 16], xmm0

    cmp edx, ebp
    jne .xmmLoop

    mov ebx, dword [esp + 12]
    mov ebp, ecx
    and ebp, -16
    lea edi, [result + ebp]
    lea edx, [esi + ebp]
    sub ebx, ebp
    cmp ecx, ebp
    je .return

    movzx ecx, byte [edx]
    mov byte [edi], cl
    test edx, edx
    je .return

%macro doTrailingBytesSSSE3 1
    movzx ecx, byte [edx + %1]
    mov byte [edi + %1], cl
    cmp ebx, %1
    je .return
%endmacro

    doTrailingBytesSSSE3 1
    doTrailingBytesSSSE3 2
    doTrailingBytesSSSE3 3
    doTrailingBytesSSSE3 4
    doTrailingBytesSSSE3 5
    doTrailingBytesSSSE3 6
    doTrailingBytesSSSE3 7
    doTrailingBytesSSSE3 8
    doTrailingBytesSSSE3 9
    doTrailingBytesSSSE3 10
    doTrailingBytesSSSE3 11
    doTrailingBytesSSSE3 12
    doTrailingBytesSSSE3 13

    movzx ebx, byte [edx + 14]
    mov byte [edi + 14], dl

.return:
    add esp, 28
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

    add esp, 28
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4





    align 16
actualASM_memcpyAVX:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    mov esi, source
    mov result, destination
    mov edx, dword [ebp + 4 + length]

    test edx, edx
    je .return

    lea ecx, [esi + 32]
    cmp result, ecx
    lea ecx, [eax + 32]
    setnb bl
    cmp esi, ecx
    setnb cl
    or bl, cl
    je .doMovsb

    lea ecx, [edx - 1]
    cmp ecx, 30
    jbe .doMovsb

    mov ebx, edx
    mov edi, esi
    mov ecx, result
    and ebx, -32
    add ebx, esi

.avxLoop:
    vmovdqu xmm1, oword [edi]
    add edi, 32
    vinsertf128 ymm0, ymm1, oword [edi - 16], 1
    add ecx, 32
    vmovups oword [ecx - 32], xmm0
    vextractf128 oword [ecx - 16], ymm0, 1

    cmp edi, ebx
    jne .avxLoop

    mov ecx, edx
    lea edi, [result + ecx]
    add esi, ecx
    cmp edx, ecx
    je .avxReturn
    add edx, result

.trailingBytesLoop:
    movsb

    cmp edx, edi
    jne .trailingBytesLoop

.avxReturn:
    vzeroupper

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.doMovsb:
    add edx, result
    mov edi, result

.movsbLoop:
    movsb

    cmp edi, edx
    jne .movsbLoop

    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4





    align 16
actualASM_memcpyAVX2:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    mov result, destination
    mov ecx, dword [ebp + 4 + length]

    test ecx, ecx
    je .return

    mov esi, edx
    add edx, 32
    cmp result, edx
    lea edx, [result + 32]
    setnb bl
    cmp esi, edx
    setnb dl
    or bl, dl
    je .doMovsb

    lea edx, [ecx - 1]
    cmp edx, 30
    jbe .doMovsb

    mov ebx, ecx
    mov edx, esi
    mov edi, result
    and ebx, -32
    add ebx, esi

.avxLoop:
    vmovdqu ymm0, yword [edx]
    vmovdqu yword [edi], ymm0

    add edx, 32
    add edi, 32

    cmp edx, ebx
    jne .avxLoop

    mov edx, ecx
    and edx, -32
    lea edi, [result + edx]
    add esi, edx
    cmp ecx, edx
    je .avxReturn

    add ecx, result

.trailingBytesLoop:
    movsb

    cmp ecx, edi
    jne .trailingBytesLoop

.avxReturn:
    vzeroupper

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
    cmp eax, AVXSupported - 1
    jg .notSSSE3

    mov dword [actualASM_memcpyPtr], actualASM_memcpySSSE3
    jmp .doJmp

.notSSSE3:
    cmp eax, AVX2Supported - 1
    jg .notAVX

    mov dword [actualASM_memcpyPtr], actualASM_memcpyAVX
    jmp .doJmp

.notAVX:
    mov dword [actualASM_memcpyPtr], actualASM_memcpyAVX2

.doJmp:
    mov dword [esp + 28 + length], ebx

    add esp, 24
    pop ebx
    jmp dword [actualASM_memcpyPtr]

