global @ASM_bcopy@12
extern _getInstructionSet

segment .data align=16

    actualASM_bcopyPtr dd actualASM_bcopyGetPtr

segment .text align=16

%define source ecx
%define destination edx
%define length 4

; Version for 386 processors
%define regLength ecx
%define backSrc esi
%define backDest edi
actualASM_bcopy386:
    push ebp
    push backDest
    push backSrc
    push ebx
    push ebx
    mov backSrc, source
    mov backDest, destination
    mov regLength, dword [esp + 20 + length]

    lea eax, [regLength - 1]
    cmp destination, backSrc
    jnb .destAfterSrcStartLoop

    test regLength, regLength
    je .return

    lea edx, [backSrc + 4]
    cmp backDest, edx
    setnb bl

    lea edx, [backDest + 4]
    cmp backSrc, edx
    setnb dl

    or ebx, edx
    cmp eax, 12
    seta dl

    test bl, dl
    je .startMovsb

    mov edx, backDest
    or edx, backSrc
    and edx, 3
    jne .startMovsb

    mov ebx, backSrc
    mov edx, backDest
    mov ebp, regLength

    and ebp, -4
    add ebp, backSrc

    mov dword [esp], eax

.dwordLoop:
    mov eax, dword [ebx]
    mov dword [edx], eax

    add ebx, 4
    add edx, 4

    cmp ebx, ebp
    jne .dwordLoop

    mov eax, dword [esp]
    mov ebx, regLength
    and ebx, -4
    add backSrc, ebx
    add backDest, ebx
    sub eax, ebx

    cmp regLength, ebx
    je .return

    mov cl, byte [backSrc]
    mov byte [backDest], cl

    test eax, eax
    je .return

    mov cl, byte [backSrc + 1]
    mov byte [backDest + 1], cl

    dec eax
    je .return

    mov al, byte [backSrc + 2]
    mov byte [backDest + 2], al

.return:
    pop eax
    pop ebx
    pop backSrc
    pop backDest
    pop ebp
    ret 4
    align 16

.destAfterSrcStartLoop:
    test regLength, regLength
    je .return

    lea ecx, [backSrc - 1]
    lea edx, [edx - 1]

.destAfterSrc:
    mov bl, byte [ecx + eax + 1]
    mov byte [edx + eax + 1], bl

    dec eax
    cmp eax, -1
    jne .destAfterSrc

    pop eax
    pop ebx
    pop backSrc
    pop backDest
    pop ebp
    ret 4

.startMovsb:
    add regLength, backDest
.movsbLoop:
    movsb

    cmp backDest, regLength
    jne .movsbLoop
    jmp .return
; end of actualASM_bcopy386





    align 16
actualASM_bcopySSE:
    push ebp
    push edi
    push esi
    push ebx
    mov edi, destination
    mov esi, source
    mov regLength, dword [esp + 16 + length]
    lea eax, [ecx - 1]

    cmp destination, esi
    jnb .destBiggerThanSrc

    test regLength, regLength
    je .return

    lea edx, [esi + 16]
    lea ebx, [edi + 16]
    cmp edi, edx
    setnb dl
    cmp esi, ebx
    setnb bl
    or dl, bl
    cmp eax, 14
    seta bl
    test dl, dl
    je .startMovsb

    mov edx, edi
    or edx, esi
    test dl, 15
    jne .startMovsb

    mov ebp, regLength
    and ebp, -16
    add ebp, esi
    mov edx, esi
    mov ebx, edi

.xmmLoop:
    movaps xmm0, oword [edx]
    add edx, 16
    movaps oword [ebx], xmm0
    add ebx, 16

    cmp ebx, ebp
    jne .xmmLoop

    mov edx, regLength
    and edx, -16
    add esi, edx
    add edi, edx
    sub eax, edx
    cmp ecx, edx
    je .return

    movzx ecx, byte [esi]
    mov byte [edi], cl
    test eax, eax
    je .return

    movzx ecx, byte [esi + 1]
    mov byte [edi + 1], cl
    cmp eax, 1
    je .return

    movzx ecx, byte [esi + 2]
    mov byte [edi + 2], cl
    cmp eax, 2
    je .return

    movzx ecx, byte [esi + 3]
    mov byte [edi + 3], cl
    cmp eax, 3
    je .return

    movzx ecx, byte [esi + 4]
    mov byte [edi + 4], cl
    cmp eax, 4
    je .return

    movzx ecx, byte [esi + 5]
    mov byte [edi + 5], cl
    cmp eax, 5
    je .return

    movzx ecx, byte [esi + 6]
    mov byte [edi + 6], cl
    cmp eax, 6
    je .return

    movzx ecx, byte [esi + 7]
    mov byte [edi + 7], cl
    cmp eax, 7
    je .return

    movzx ecx, byte [esi + 8]
    mov byte [edi + 8], cl
    cmp eax, 8
    je .return

    movzx ecx, byte [esi + 9]
    mov byte [edi + 9], cl
    cmp eax, 9
    je .return

    movzx ecx, byte [esi + 10]
    mov byte [edi + 10], cl
    cmp eax, 10
    je .return

    movzx ecx, byte [esi + 12]
    mov byte [edi + 12], cl
    cmp eax, 12
    je .return

    movzx ecx, byte [esi + 13]
    mov byte [edi + 13], cl
    cmp eax, 13
    je .return

    movzx eax, byte [esi + 14]
    mov byte [edi + 14], al

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4
    align 16

.destBiggerThanSrc:
    test regLength, regLength
    je .return
    lea ecx, [esi - 1]
    lea edx, [edi - 1]

.destBiggerThanSrcLoop:
    movzx ebx, byte [ecx + eax + 1]
    mov byte [edx + eax + 1], bl

    dec eax
    cmp eax, -1
    jne .destBiggerThanSrcLoop

    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4
    align 16

.startMovsb:
    add regLength, edi

.movsbLoop:
    movsb
    cmp edi, regLength
    jne .movsbLoop
    jmp .return
; end of actualASM_bcopySSE1





    align 16
actualASM_bcopySSE2:
    push ebp
    push edi
    push esi
    push ebx
    mov esi, source
    mov edi, destination
    mov edx, dword [esp + 16 + length]

    lea eax, [edx - 1]
    cmp edi, ecx
    jnb .destBiggerThanSrc

    test edx, edx
    je .return

    lea ecx, [ecx + 16]
    cmp edi, ecx
    setnb bl
    lea ecx, [edi + 16]
    cmp esi, ecx
    setnb cl
    or bl, cl
    je .doMovsb

    cmp eax, 29
    jbe .doMovsb

    mov ecx, esi
    neg ecx
    and ecx, 15
    je .earlyXmm

    lea ebp, [esi + 1]
    lea ebx, [edi + 1]
    movzx eax, byte [esi]
    mov byte [edi], al

    lea eax, [edx - 2]
    cmp ecx, 1
    je .doXmm

    lea ebp, [esi + 2]
    lea ebx, [edi + 2]
    movzx eax, byte [esi + 1]
    mov byte [edi + 1], al

    lea eax, [edx - 3]
    cmp ecx, 2
    je .doXmm

    lea ebp, [esi + 3]
    lea ebx, [edi + 3]
    movzx eax, byte [esi + 2]
    mov byte [edi + 2], al

    lea eax, [edx - 4]
    cmp ecx, 3
    je .doXmm

    lea ebp, [esi + 4]
    lea ebx, [edi + 4]
    movzx eax, byte [esi + 3]
    mov byte [edi + 3], al

    lea eax, [edx - 5]
    cmp ecx, 4
    je .doXmm

    lea ebp, [esi + 5]
    lea ebx, [edi + 5]
    movzx eax, byte [esi + 4]
    mov byte [edi + 4], al

    lea eax, [edx - 6]
    cmp ecx, 5
    je .doXmm

    lea ebp, [esi + 6]
    lea ebx, [edi + 6]
    movzx eax, byte [esi + 5]
    mov byte [edi + 5], al

    lea eax, [edx - 7]
    cmp ecx, 6
    je .doXmm

    lea ebp, [esi + 7]
    lea ebx, [edi + 7]
    movzx eax, byte [esi + 6]
    mov byte [edi + 6], al

    lea eax, [edx - 8]
    cmp ecx, 7
    je .doXmm

    lea ebp, [esi + 8]
    lea ebx, [edi + 8]
    movzx eax, byte [esi + 7]
    mov byte [edi + 7], al

    lea eax, [edx - 9]
    cmp ecx, 8
    je .doXmm

    lea ebp, [esi + 9]
    lea ebx, [edi + 9]
    movzx eax, byte [esi + 8]
    mov byte [edi + 8], al

    lea eax, [edx - 10]
    cmp ecx, 9
    je .doXmm

    lea ebp, [esi + 10]
    lea ebx, [edi + 10]
    movzx eax, byte [esi + 9]
    mov byte [edi + 9], al

    lea eax, [edx - 11]
    cmp ecx, 10
    je .doXmm

    lea ebp, [esi + 11]
    lea ebx, [edi + 11]
    movzx eax, byte [esi + 10]
    mov byte [edi + 10], al

    lea eax, [edx - 12]
    cmp ecx, 11
    je .doXmm

    lea ebp, [esi + 12]
    lea ebx, [edi + 12]
    movzx eax, byte [esi + 11]
    mov byte [edi + 11], al

    lea eax, [edx - 13]
    cmp ecx, 12
    je .doXmm

    lea ebp, [esi + 13]
    lea ebx, [edi + 13]
    movzx eax, byte [esi + 12]
    mov byte [edi + 12], al

    lea eax, [edx - 14]
    cmp ecx, 13
    je .doXmm

    lea ebp, [esi + 14]
    lea ebx, [edi + 14]
    movzx eax, byte [esi + 13]
    mov byte [edi + 13], al

    lea eax, [edx - 15]
    cmp ecx, 15
    jne .doXmm

    lea ebp, [esi + 15]
    lea ebx, [edi + 15]
    movzx eax, byte [esi + 14]
    mov byte [edi + 14], al

    lea eax, [edx - 16]

.doXmm:
    sub edx, ecx
    add esi, ecx
    add ecx, edi
    mov edi, edx
    and edi, -16
    add edi, esi

.xmmLoop:
    movdqa xmm0, oword [esi]
    movdqu oword [ecx], xmm0

    add esi, 16
    add ecx, 16
    cmp esi, edi
    jne .xmmLoop

    mov ecx, edx
    and ecx, -16
    add ebp, ecx
    add ebx, ecx
    sub eax, ecx
    cmp edx, ecx
    je .return

    movzx edx, byte [ebp]
    mov byte [ebx], dl

    test eax, eax
    je .return

    movzx edx, byte [ebp + 1]
    mov byte [ebx + 1], dl

    cmp eax, 1
    je .return

    movzx edx, byte [ebp + 2]
    mov byte [ebx + 2], dl

    cmp eax, 2
    je .return

    movzx edx, byte [ebp + 3]
    mov byte [ebx + 3], dl

    cmp eax, 3
    je .return

    movzx edx, byte [ebp + 4]
    mov byte [ebx + 4], dl

    cmp eax, 4
    je .return

    movzx edx, byte [ebp + 5]
    mov byte [ebx + 5], dl

    cmp eax, 5
    je .return

    movzx edx, byte [ebp + 6]
    mov byte [ebx + 6], dl

    cmp eax, 6
    je .return

    movzx edx, byte [ebp + 7]
    mov byte [ebx + 7], dl

    cmp eax, 7
    je .return

    movzx edx, byte [ebp + 8]
    mov byte [ebx + 8], dl

    cmp eax, 8
    je .return

    movzx edx, byte [ebp + 9]
    mov byte [ebx + 9], dl

    cmp eax, 9
    je .return

    movzx edx, byte [ebp + 10]
    mov byte [ebx + 10], dl

    cmp eax, 10
    je .return

    movzx edx, byte [ebp + 11]
    mov byte [ebx + 11], dl

    cmp eax, 11
    je .return

    movzx edx, byte [ebp + 12]
    mov byte [ebx + 12], dl

    cmp eax, 12
    je .return

    movzx edx, byte [ebp + 13]
    mov byte [ebx + 13], dl

    cmp eax, 13
    je .return

    movzx edx, byte [ebp + 14]
    mov byte [ebx + 14], dl

.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4
    align 16

.destBiggerThanSrc:
    test edx, edx
    je .return
    dec ecx
    lea edx, [edi - 1]

.destBiggerThanSrcLoop:
    movzx ebx, byte [ecx + eax + 1]
    mov byte [edx + eax + 1], bl

    dec eax
    cmp eax, -1
    jne .destBiggerThanSrcLoop

    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4
    align 16

.doMovsb:
    add edx, esi

.movsbLoop:
    movsb

    cmp esi, edx
    jne .movsbLoop
    jmp .return
    align 16

.earlyXmm:
    mov ebx, edi
    mov ebp, esi
    jmp .doXmm
; End of actualASM_bcopySSE2





    align 16
actualASM_bcopySSSE3:
    push ebp
    push edi
    push esi
    push ebx
    sub esp, 28
    mov edi, destination
    mov esi, source
    mov edx, [esp + 44 + length]
    lea eax, [edx - 1]

    cmp edi, source
    jnb .destBiggerThanSrc

    test edx, edx
    je .return

    lea ecx, [ecx + 16]
    cmp edi, ecx
    lea ecx, [edi + 16]
    setnb bl
    cmp esi, ecx
    setnb cl
    or bl, cl
    je .doMovsb

    cmp eax, 14
    jbe .doMovsb

    mov ebp, edx
    mov ecx, esi
    mov ebx, edi
    and ebp, -16
    add ebp, esi

.xmmLoop:
    movdqu xmm0, oword [ecx]
    movups oword [ebx], xmm0
    add ecx, 16
    add ebx, 16
    cmp ecx, ebp
    jne .xmmLoop

    mov ebx, edx
    and ebx, -16
    add esi, ebx
    add edi, ebx
    sub eax, ebx
    cmp edx, ebx
    je .return

    movzx edx, byte [esi]
    mov byte [edi], dl

    test eax, eax
    je .return

    movzx edx, byte [esi + 1]
    mov byte [edi + 1], dl

    cmp eax, 1
    je .return

    movzx edx, byte [esi + 2]
    mov byte [edi + 2], dl

    cmp eax, 2
    je .return

    movzx edx, byte [esi + 3]
    mov byte [edi + 3], dl

    cmp eax, 3
    je .return

    movzx edx, byte [esi + 4]
    mov byte [edi + 4], dl

    cmp eax, 4
    je .return

    movzx edx, byte [esi + 5]
    mov byte [edx + 5], dl

    cmp eax, 5
    je .return

    movzx edx, byte [esi + 6]
    mov byte [edi + 6], dl

    cmp eax, 6
    je .return

    movzx edx, byte [ebp + 7]
    mov byte [edi + 7], dl

    cmp eax, 7
    je .return

    movzx edx, byte [esi + 8]
    mov byte [edi + 8], dl

    cmp eax, 8
    je .return

    movzx edx, byte [esi + 9]
    mov byte [edi + 9], dl

    cmp eax, 9
    je .return

    movzx edx, byte [esi + 10]
    mov byte [edi + 10], dl

    cmp eax, 10
    je .return

    movzx edx, byte [esi + 11]
    mov byte [edi + 11], dl

    cmp eax, 11
    je .return

    movzx edx, byte [esi + 12]
    mov byte [edi + 12], dl

    cmp eax, 12
    je .return

    movzx edx, byte [esi + 13]
    mov byte [edi + 13], dl

    cmp eax, 13
    je .return

    movzx eax, byte [esi + 14]
    mov byte [edi + 14], al

.return:
    add esp, 28
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.destBiggerThanSrc:
    lea ebx, [source + eax]
    mov dword [esp + 4], ebx

    lea ecx, [edi + eax]
    mov dword [esp + 8], ecx

    test edx, edx
    je .return

    lea ebx, [edx - 16]
    lea ecx, [esi + ebx]
    lea ebp, [edi + ebx]
    mov dword [esp + 12], ecx
    lea ebx, [edi + edx]
    cmp ecx, ebx
    setnb byte [esp + 3]
    movzx ecx, byte [esp + 3]
    lea ebx, [esi + edx]
    cmp ebp, edx
    setnb bl
    or cl, bl
    je .doByteLoop

    cmp eax, 14
    jbe .doByteLoop

    mov ecx, dword [esp + 12]
    mov esi, edx
    mov ebx, ebp
    and esi, -16
    mov edi, ecx
    sub edi, esi
    mov esi, edi

.xmmLoopReverse:
    movdqu xmm1, oword [ecx]
    movups oword [ebx], xmm1
    sub ecx, 16
    sub edx, 16

    cmp ecx, esi
    jne .xmmLoopReverse

    mov esi, edx
    mov ebx, dword [esp + 4]
    and esi, -16
    mov ecx, esi
    sub eax, esi
    neg ecx
    add ebx, ecx
    add ecx, dword [esp + 8]
    cmp edx, esi
    je .return

    movzx edx, byte [ebx]
    mov byte [ecx], dl

    test eax, eax
    je .return

    movzx edx, byte [ebx + 1]
    mov byte [ecx + 1], dl

    cmp eax, 1
    je .return

    movzx edx, byte [ebx + 2]
    mov byte [ecx + 2], dl

    cmp eax, 2
    je .return

    movzx edx, byte [ebx + 3]
    mov byte [ecx + 3], dl

    cmp eax, 3
    je .return

    movzx edx, byte [ebx + 4]
    mov byte [ecx + 4], dl

    cmp eax, 4
    je .return

    movzx edx, byte [ebx + 5]
    mov byte [ecx + 5], dl

    cmp eax, 5
    je .return

    movzx edx, byte [ebx + 6]
    mov byte [ecx + 6], dl

    cmp eax, 6
    je .return

    movzx edx, byte [ebx + 7]
    mov byte [ecx + 7], dl

    cmp eax, 7
    je .return

    movzx edx, byte [ebx + 8]
    mov byte [ecx + 8], dl

    cmp eax, 8
    je .return

    movzx edx, byte [ebx + 9]
    mov byte [ecx + 9], dl

    cmp eax, 9
    je .return

    movzx edx, byte [ebx + 10]
    mov byte [ecx + 10], dl

    cmp eax, 10
    je .return

    movzx edx, byte [ebx + 11]
    mov byte [ecx + 11], dl

    cmp eax, 11
    je .return

    movzx edx, byte [ebx + 12]
    mov byte [ecx + 12], dl

    cmp eax, 12
    je .return

    movzx edx, byte [ebx + 13]
    mov byte [ecx + 13], dl

    cmp eax, 13
    je .return

    movzx eax, byte [ebx + 14]
    mov byte [ecx + 14], al
    jmp .return
    align 16

.doMovsb:
    add edx, esi

.movsbLoop:
    movsb

    cmp esi, edx
    jne .movsbLoop
    jmp .return
    align 16

.doByteLoop:
    lea ebx, [esi - 1]
    lea ecx, [edi - 1]

.byteLoop:
    movzx edx, byte [ebx + eax + 1]
    mov byte [ecx + eax + 1], dl

    dec eax
    cmp eax, -1
    jne .byteLoop
    jmp .return





actualASM_bcopyAVX:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    mov edi, destination
    and esp, -32    ; Align stack
    sub esp, 32
    mov eax, dword [ebp + 4 + length]
    lea ebx, [eax - 1]
    mov dword [esp + 28], ebx

    cmp destination, source
    jnb .destBiggerThanSrc

    test eax, eax
    je .return

    lea ebx, [source + 32]
    cmp destination, ebx
    setnb bl
    mov esi, ebx
    lea ebx, [destination + 32]
    mov edx, esi
    cmp source, edx
    setnb bl
    or dl, bl
    je .doMovsb

    cmp dword [esp + 28], 30
    jbe .doMovsb

    mov esi, eax
    mov edx, source
    mov ebx, edi
    and esi, -32
    add esi, source

.avxLoop:
    vmovdqu xmm1, oword [edx]
    add edx, 32
    vinsertf128 ymm0, ymm1, oword [edx - 16], 1
    add ebx, 32
    vmovups oword [ebx - 32], xmm0
    vextractf128 oword [ebx - 16], ymm0, 1

    cmp edx, esi
    jne .avxLoop

    mov edx, eax
    and edx, -32
    lea esi, [source + edx]
    add edi, edx
    cmp eax, edx
    je .avxReturn

.movsbLoopAfterAvx:
    movsb

    cmp esi, source
    jne .movsbLoopAfterAvx

.avxReturn:
    vzeroupper

.return:
    lea esp, [ebp - 12]
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4
    align 16

.destBiggerThanSrc:
    lea esi, [eax - 1]
    lea ebx, [source + esi]
    lea edx, [edx + esi]
    mov dword [esp + 16], ebx
    mov dword [esp + 12], edx

    test eax, eax
    je .return

    lea ebx, [eax - 16]
    lea edx, [edi + ebx]
    lea esi, [source + ebx]
    mov dword [esp + 24], edx
    lea ebx, [edi + eax]
    cmp esi, ebx
    setnb byte [esp + 23]
    movzx edx, byte [esp + 23]
    lea ebx, [source + eax]
    cmp dword [esp + 24], ebx
    setnb bl
    or dl, bl
    je .doReverseByteLoop

    cmp dword [esp + 28], 14
    jbe .doReverseByteLoop

    mov ebx, dword [esp + 24]
    lea edx, [eax - 1]
    mov ecx, esi
    mov esi, eax
    and esi, -16
    mov edi, ecx
    sub edi, esi
    mov esi, edi

.reverseAvxLoop:
    vmovdqu xmm2, oword [ecx]
    sub ecx, 16
    sub ebx, 16
    vmovups oword [ebx + 16], xmm2

    cmp ecx, esi
    jne .reverseAvxLoop

    mov ebx, eax
    mov esi, dword [esp + 16]
    and ebx, -16
    mov ecx, ebx
    sub edx, ebx
    neg ecx
    add esi, ecx
    add ecx, dword [esp + 12]
    cmp eax, ebx
    je .return

    movzx eax, byte [esi]
    mov byte [ecx], al

    test edx, edx
    je .return

    movzx eax, byte [esi-1]
    mov byte [ecx-1], al

    cmp edx, 1
    je .return

    movzx eax, byte [esi-2]
    mov byte [ecx-2], al

    cmp edx, 2
    je .return

    movzx eax, byte [esi-3]
    mov byte [ecx-3], al

    cmp edx, 3
    je .return

    movzx eax, byte [esi-4]
    mov byte [ecx-4], al

    cmp edx, 4
    je .return

    movzx eax, byte [esi-5]
    mov byte [ecx-5], al

    cmp edx, 5
    je .return

    movzx eax, byte [esi-6]
    mov byte [ecx-6], al

    cmp edx, 6
    je .return

    movzx eax, byte [esi-7]
    mov byte [ecx-7], al

    cmp edx, 7
    je .return

    movzx eax, byte [esi-8]
    mov byte [ecx-8], al

    cmp edx, 8
    je .return

    movzx eax, byte [esi-9]
    mov byte [ecx-9], al

    cmp edx, 9
    je .return

    movzx eax, byte [esi-10]
    mov byte [ecx-10], al

    cmp edx, 10
    je .return

    movzx eax, byte [esi-11]
    mov byte [ecx-11], al

    cmp edx, 11
    je .return

    movzx eax, byte [esi-12]
    mov byte [ecx-12], al

    cmp edx, 12
    je .return

    movzx eax, byte [esi-13]
    mov byte [ecx-13], al

    cmp edx, 13
    je .return

    movzx eax, byte [esi-14]
    mov byte [ecx-14], al
    jmp .return
    align 16

.doMovsb:
    add eax, ecx
    mov esi, ecx

.movsbLoop:
    movsb

    cmp esi, eax
    jne .movsbLoop
    jmp .return
    align 16

.doReverseByteLoop:
    mov edx, dword [esp + 28]
    lea ebx, [source - 1]
    lea ecx, [edi - 1]

.reverseByteLoop:
    movzx eax, byte [ebx + edx + 1]
    mov byte [ecx + edx + 1], al

    dec edx
    cmp edx, -1
    jne .reverseByteLoop
    jmp .return
; End of actualASM_bcopyAVX





actualASM_bcopyAVX2:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    mov edi, destination
    and esp, -32    ; Align stack
    sub esp, 32
    mov eax, dword [ebp + 4 + length]
    dec eax

    cmp destination, source
    jnb .destBiggerThanSrc

    mov ebx, dword [ebp + 4 + length]
    test ebx, ebx
    je .return

    lea edx, [source + 32]
    cmp edi, edx
    lea edx, [edi + 32]
    setnb bl
    cmp source, edx
    setnb dl
    or bl, dl
    je .doMovsb

    cmp eax, 30
    jbe .doMovsb

    mov ebx, dword [ebp + 4 + length]
    mov eax, source
    mov edx, edi
    and ebx, -32
    add ebx, source

.avxLoop:
    vmovdqu xmm1, oword [eax]
    add eax, 32
    vinserti128 ymm0, ymm1, oword [eax - 16], 1
    add edx, 32
    vmovups oword [edx - 32], xmm0
    vextracti128 oword [edx - 16], ymm0, 1

    cmp ebx, eax
    jne .avxLoop

    mov eax, dword [ebp + 4 + length]
    and eax, -32
    lea esi, [source + eax]
    add edi, eax
    cmp dword [ebp + 4 + length], eax
    je .avxReturn

    add ecx, dword [ebp + 4 + length]

.movsbLoop:
    movsb
    cmp ecx, esi
    jne .movsbLoop

.avxReturn:
    vzeroupper

.return:
    lea esp, [ebp - 12]
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4

.destBiggerThanSrc:
    mov edx, dword [ebp + 4 + length]
    test edx, edx
    je .return

    lea ebx, [edx - 32]
    lea edx, [source + ebx]
    lea esi, [edi + ebx]
    mov ebx, dword [ebp + 4 + length]
    setnb byte [esp + 28]
    movzx edx, byte [esp + 28]
    add ebx, source
    cmp esi, ebx
    setnb bl
    or dl, bl
    je .doByteLoop

    cmp eax, 30
    jbe .doByteLoop

    mov dword [esp + 28], esi
    mov edx, dword [esp + 24]
    mov esi, dword [esp + 8]
    mov ebx, edx
    and esi, -32
    sub ebx, esi
    mov esi, ebx
    mov ebx, dword [esp + 28]
.reverseAvxLoop:
    vmovdqu xmm2, oword [edx]
    sub edx, 32
    vinserti128 ymm0, ymm2, oword [edx + 48], 1
    sub ebx, 32
    vmovups oword [ebx + 32], xmm0
    vextracti128 oword [ebx + 48], ymm0, 1

    cmp edx, esi
    jne .reverseAvxLoop

    mov edx, dword [ebp + 4 + length]
    and edx, -32
    sub eax, edx
    cmp dword [ebp + 4 + length], edx
    je .avxReturn

.remainingBytesLoop:
    movzx edx, byte [source + eax]
    mov byte [edi + eax], dl

    dec eax
    cmp eax, -1
    jne .remainingBytesLoop

    vzeroupper
    jmp .return
    align 16

.doByteLoop:
    lea ebx, [source - 1]
    lea ecx, [edi - 1]

.byteLoop:
    movzx edx, byte [ebx + eax + 1]
    mov byte [ecx + eax + 1], dl

    dec eax
    cmp eax, -1
    jne .byteLoop
    jmp .return
    align 16

.doMovsb:
    mov eax, dword [ebp + 4 + length]
    mov esi, eax
    add eax, ecx

.movsbLoop2:
    movsb

    cmp esi, eax
    jne .movsbLoop2
    jmp .return
; End of actualASM_bcopyAVX2





    align 16
%define SSESupported 3
%define SSE2Supported 4
%define SSSE3Supported 6
%define AVXSupported 11
%define AVX2Supported 13
@ASM_bcopy@12:
    jmp dword [actualASM_bcopyPtr]

    align 16
actualASM_bcopyGetPtr:
    push ebx
    sub esp, 24
    mov dword [esp + 12], destination
    mov dword [esp + 8], source
    mov ebx, [esp + 28 + length]

    call _getInstructionSet

    cmp eax, SSESupported - 1
    mov source, dword [esp + 8]
    mov destination, dword [esp + 12]
    jg .not386

    mov dword [actualASM_bcopyPtr], actualASM_bcopy386
    jmp .doJmp

.not386:
    cmp eax, SSE2Supported - 1
    jne .notSSE
    mov dword [actualASM_bcopyPtr], actualASM_bcopySSE
    jmp .doJmp

.notSSE:
    cmp eax, SSSE3Supported - 1
    jg .notSSE2
    mov dword [actualASM_bcopyPtr], actualASM_bcopySSE2
    jmp .doJmp

.notSSE2:
    cmp eax, AVXSupported - 1
    jg .notSSSE3
    mov dword [actualASM_bcopyPtr], actualASM_bcopySSSE3
    jmp .doJmp

.notSSSE3:
    cmp eax, AVX2Supported - 1
    jg .notAVX
    mov dword [actualASM_bcopyPtr], actualASM_bcopyAVX
    jmp .doJmp

.notAVX:
    mov dword [actualASM_bcopyPtr], actualASM_bcopyAVX2

.doJmp:
    mov dword [esp + 28 + length], ebx
    add esp, 24
    pop ebx
    jmp dword [actualASM_bcopyPtr]

