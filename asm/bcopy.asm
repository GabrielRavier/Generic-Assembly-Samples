; Performance for copying a 100000 bytes buffer for all the versions (lower is better) :
; std : 11745/11792 = 1.00
; 386 : 26053/8336 = 2.94
; SSE : 9112/8944 = 1.02
; SSE2 : 9018/8960 = 1.01
; std : 8487/8510 = 1.00
; SSSE3 : 7928/8631 = 0.92
; AVX2 : 6691/8487 = 0.79
; Calculated by using the clocks taken by the algorithm divided by the clocks taken by the std version

global @ASM_bcopy@12
extern _getInstructionSet

segment .data align=16

    actualASM_bcopyPtr dd actualASM_bcopyGetPtr

segment .text align=16

%define source ecx
%define destination edx
%define length 4
%define result eax

actualASM_bcopy386:
    push ebp
    push edi
    mov edi, destination
    push esi
    mov esi, source
    push ebx

    mov ecx, [esp + 16 + length]
    cmp ecx, 16
    jb .lessThan16

    cmp esi, edi
    jb .doBackwards

    cmp ecx, 680
    jb .doManualLoopForwards

    mov eax, esi
    xor eax, edi
    and eax, 0ffh
    jz .forwardsMovs

.doManualLoopForwards:
    sub ecx, 16

.forwardsManualLoop:
    sub ecx, 16
    mov eax, [esi]
    mov ebx, [esi + 4]
    mov [edi], eax
    mov [edi + 4], ebx
    mov eax, [esi + 8]
    mov ebx, [esi + 12]
    mov [edi + 8], eax
    mov [edi + 12], ebx
    lea esi, [esi + 16]
    lea edi, [edi + 16]
    jnb .forwardsManualLoop

    add ecx, 16
    jmp .lessThan16

    align 16
.forwardsMovs:
    mov eax, [esi + ecx - 4]
    lea ebx, [edi + ecx - 4]
    shr ecx, 2
    rep movsd
    mov [ebx], eax
    jmp .return

    align 16
.backwardsMovs:
    mov eax, [esi]
    mov ebx, edi
    lea esi, [esi + ecx - 4]
    lea edi, [edi + ecx - 4]
    shr ecx, 2
    std
    rep movsd
    mov [ebx], eax
    cld
    jmp .return

    align 16
.doBackwards:
    cmp ecx, 680
    jb .backwardsNoMovs

    mov eax, esi
    xor eax, edi
    and eax, 0FFh
    jz .backwardsMovs

.backwardsNoMovs:
    add esi, ecx
    add edi, ecx
    sub ecx, 16

.backwardsManualLoop:
    sub ecx, 16
    mov eax, [esi - 4]
    mov ebx, [esi - 8]
    mov [edi - 4], eax
    mov [edi - 8], ebx
    mov eax, [esi - 12]
    mov ebx, [esi - 16]
    mov [edi - 12], eax
    mov [edi - 16], ebx
    lea esi, [esi - 16]
    lea edi, [edi - 16]
    jnb .backwardsManualLoop

    add ecx, 16 ; Calculate position to head
    sub esi, ecx
    sub edi, ecx

    align 16
.lessThan16:
    cmp ecx, 8
    jb .lessThan8

    mov eax, [esi]
    mov ebx, [esi + 4]
    mov ebp, [esi + ecx - 8]
    mov esi, [esi + ecx - 4]
    mov [edi], eax
    mov [edi + 4], ebx
    mov [edi + ecx - 8], ebp
    mov [edi + ecx - 4], esi
    jmp .return

    align 16
.lessThan8:
    cmp ecx, 4
    jb .lessThan4

    mov eax, [esi]
    mov ebx, [esi + ecx - 4]
    mov [edi], eax
    mov [esi + ecx - 4], ebx
    jmp .return

    align 16
.lessThan4:
    cmp ecx, 2
    jb .lessThan2

    mov dx, [esi]
    mov bx, [esi + ecx - 2]
    mov [edi], dx
    mov [edi + ecx - 2], bx
    jmp .return

    align 16
.lessThan2:
    cmp ecx, 1
    jb .return

    mov cl, [esi]
    mov [edi], cl

    align 16
.return:
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret 4
; end of actualASM_bcopy386





    align 16
%define backDest edi
%define backSrc esi
%define regLength ecx
actualASM_bcopySSE:
    push ebp
    push backDest
    mov backDest, destination
    push backSrc
    mov backSrc, source
    push ebx

    sub destination, backSrc

    mov regLength, dword [esp + 16 + length]
    lea eax, [regLength - 1]

    cmp destination, regLength
    jb .doReverse

    test regLength, regLength
    je .return

    lea ebx, [backSrc + 16]
    lea ebp, [backDest + 16]
    cmp backDest, ebx
    setnb dl
    cmp esi, ebp
    setnb bl
    or dl, bl
    cmp eax, 14
    seta bl
    test dl, bl
    je .doMovsb

    mov edx, backDest
    or edx, backSrc
    test dl, 15
    jne .doMovsb

    mov ebp, regLength
    mov edx, backSrc
    and ebp, -16
    mov ebx, backDest
    add ebp, backSrc

    align 16
.xmmLoop:
    movaps xmm0, oword [edx]
    add edx, 16
    add ebx, 16
    movaps oword [ebx - 16], xmm0

    cmp edx, ebp
    jne .xmmLoop

    mov edx, regLength
    and edx, -16
    add backDest, edx
    add backSrc, edx
    sub eax, edx
    cmp regLength, edx
    je .return

    movzx ecx, byte [backSrc]
    test eax, eax
    mov byte [backDest], cl
    je .return

%macro doTrailingByteSSE1 3
    movzx %3, byte [backSrc + %1]
    cmp eax, %1
    mov byte [backDest + %1], %2
    je .return
%endmacro

    doTrailingByteSSE1 1, bl, ebx
    doTrailingByteSSE1 2, dl, edx
    doTrailingByteSSE1 3, cl, ecx
    doTrailingByteSSE1 4, bl, ebx
    doTrailingByteSSE1 5, dl, edx
    doTrailingByteSSE1 6, cl, ecx
    doTrailingByteSSE1 7, bl, ebx
    doTrailingByteSSE1 8, dl, edx
    doTrailingByteSSE1 9, cl, ecx
    doTrailingByteSSE1 10, bl, ebx
    doTrailingByteSSE1 11, dl, edx
    doTrailingByteSSE1 12, cl, ecx
    doTrailingByteSSE1 13, bl, ebx

    movzx eax, byte [backSrc + 14]
    mov byte [backDest + 14], al

.return:
    pop ebx
    pop backSrc
    pop backDest
    pop ebp
    ret 4

    align 16
.doReverse:
    movzx edx, byte [backSrc + eax]
    mov byte [backDest + eax], dl

    dec eax
    cmp eax, -1
    je .return

    movzx edx, byte [backSrc + eax]
    mov byte [backDest + eax], dl

    dec eax
    cmp eax, -1
    jne .doReverse
    jmp .return

    align 16
.doMovsb:
    add regLength, backDest

.movsbLoop:
    movsb

    cmp backDest, regLength
    jne .movsbLoop
    jmp .return

; end of actualASM_bcopySSE1





    align 16
%define backSrc esi
%define backDest edi
%define regLength ecx
actualASM_bcopySSE2:
    push ebp
    push backDest
    push backSrc
    push ebx
    mov backSrc, source
    mov backDest, destination
    mov regLength, dword [esp + 16 + length]

    lea eax, [regLength - 1]
    sub destination, backSrc
    cmp destination, regLength
    jb .doReverse

    test regLength, regLength
    je .return

    lea ebx, [backDest + 16]
    cmp backSrc, ebx
    setnb bl
    lea ebp, [backSrc + 16]
    cmp backDest, ebp
    setnb dl
    or bl, dl
    je .doMovsb

    cmp eax, 29
    jbe .doMovsb

    mov edx, backSrc
    neg edx
    and edx, 15
    je .alreadyAligned

%macro doAlignSSE2 1
    lea ebp, [backSrc + %1]
    movzx eax, byte [backSrc + %1 - 1]
    lea ebx, [backDest + %1]
    mov byte [backDest + %1 - 1], al

    lea eax, [regLength - %1 - 1]
    cmp edx, %1
    je .endAlign
%endmacro

    doAlignSSE2 1
    doAlignSSE2 2
    doAlignSSE2 3
    doAlignSSE2 4
    doAlignSSE2 5
    doAlignSSE2 6
    doAlignSSE2 7
    doAlignSSE2 8
    doAlignSSE2 9
    doAlignSSE2 10
    doAlignSSE2 11
    doAlignSSE2 12
    doAlignSSE2 13
    doAlignSSE2 14

    lea ebp, [backSrc + 15]
    movzx eax, byte [backSrc + 14]
    lea ebx, [backDest + 15]
    mov byte [backDest + 14], al
    lea eax, [regLength - 16]

.endAlign:
;   mov ecx, regLength
    sub ecx, edx
;   mov esi, backSrc
    add esi, edx
    add edx, backDest
    mov edi, ecx
    and edi, -16
    add edi, esi


.xmmLoop:
    movdqa xmm0, oword [esi]
    movdqu oword [edx], xmm0

    add esi, 16
    add edx, 16
    cmp esi, edi
    jne .xmmLoop

    mov esi, ecx
    and esi, -16
    add ebx, esi
    add ebp, esi
    sub eax, esi
    cmp ecx, esi
    je .return

    movzx ecx, byte [ebp]
    mov byte [ebx], cl
    test eax, eax
    je .return

%macro doTrailingByteSSE2edx 1
    movzx edx, byte [ebp + %1]
    mov byte [ebx + %1], dl
    cmp eax, %1
    je .return
%endmacro

%macro doTrailingByteSSE2ecx 1
    movzx ecx, byte [ebp + %1]
    mov byte [ebx + %1], cl
    cmp eax, %1
    je .return
%endmacro

    doTrailingByteSSE2edx 1
    doTrailingByteSSE2ecx 2
    doTrailingByteSSE2edx 3
    doTrailingByteSSE2ecx 4
    doTrailingByteSSE2edx 5
    doTrailingByteSSE2ecx 6
    doTrailingByteSSE2edx 7
    doTrailingByteSSE2ecx 8
    doTrailingByteSSE2edx 9
    doTrailingByteSSE2ecx 10
    doTrailingByteSSE2edx 11
    doTrailingByteSSE2ecx 12
    doTrailingByteSSE2edx 13

    movzx eax, byte [ebp + 14]
    mov byte [ebx + 14], al

.return:
    pop ebx
    pop backSrc
    pop backDest
    pop ebp
    ret 4

    align 16
.doReverse:
    movzx ebx, byte [backSrc + eax]
    mov byte [backDest + eax], cl

    sub eax, 1
    cmp eax, -1
    je .return

    movzx ebx, byte [backSrc + eax]
    mov byte [backDest + eax], bl

    sub eax, 1
    cmp eax, -1
    jne .doReverse
    jmp .return

.doMovsb:
    add regLength, backSrc

.movsbLoop:
    movsb

    cmp backSrc, regLength
    jne .movsbLoop
    jmp .return

.alreadyAligned:
    mov ebp, backSrc
    mov ebx, backDest
    jmp .endAlign

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





    align 16
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





    align 16
%define backSrc esi
%define regLength eax
actualASM_bcopyAVX2:
    push ebp
    mov ebp, esp
    push edi
    push backSrc
    push ebx
    and esp, -32
    sub esp, 32
    mov backSrc, source

    mov regLength, dword [ebp + 4 + length]
    dec regLength
    mov ecx, destination
    sub ecx, backSrc
    cmp ecx, dword [ebp + 4 + length]
    jnb .doForwards

    mov ebx, dword [ebp + 4 + length]
    lea ecx, [ebx - 32]
    lea edi, [backSrc + ecx]
    mov dword [esp + 28], edi
    lea edi, [destination + ecx]
    mov ebx, dword [ebp + 4 + length]
    add ebx, esi
    cmp edi, ebx
    setnb cl
    mov ebx, dword [ebp + 4 + length]
    add ebx, edx
    cmp dword [esp + 28], ebx
    setnb bl
    or cl, bl
    je .doByteByByte

    cmp eax, 30
    jbe .doByteByByte

    mov ecx, dword [esp + 28]
    mov dword [esp + 28], edi
    mov edi, dword [ebp + 4 + length]
    and edi, -32
    mov ebx, ecx
    sub ebx, edi
    mov edi, ebx
    mov ebx, dword [esp + 28]

.reverseAvxLoop:
    vmovdqu ymm0, yword [ecx]
    vmovdqu yword [ebx], ymm0

    sub ecx, 32
    sub ebx, 32
    cmp edi, ecx
    jne .reverseAvxLoop

    mov ecx, dword [ebp + 4 + length]
    and ecx, -32
    sub eax, ecx
    cmp dword [ebp + 4 + length], ecx
    je .avxReturn

.trailingBytesLoopReverseLoop:
    mov bl, byte [backSrc + eax]
    mov byte [edx + eax], cl

    dec eax
    cmp eax, -1
    jne .trailingBytesLoopReverseLoop

.avxReturn:
    vzeroupper

.return:
    lea esp, [ebp - 12]
    pop ebx
    pop backSrc
    pop edi
    pop ebp
    ret 4

    align 16
.doByteByByte:
    mov cl, byte [esi + eax]
    mov byte [edx + eax], cl

    dec eax
    cmp eax, -1
    je .return

    mov cl, byte [esi + eax]
    mov byte [edx + eax], cl

    dec eax
    cmp eax, -1
    jne .doByteByByte
    jmp .return

.doForwards:
    mov ebx, dword [ebp + 4 + length]
    test ebx, ebx
    je .return

    lea edi, [edx + 32]
    cmp esi, edi
    setnb bl
    lea ecx, [backSrc + 32]
    cmp edx, ecx
    setnb cl
    or bl, cl
    je .doMovsb

    cmp eax, 30
    jbe .doMovsb

    mov eax, esi
    mov edi, edx
    mov ebx, dword [ebp + 4 + length]
    and ebx, -32
    add ebx, backSrc

.avxLoop:
    vmovdqu ymm1, yword [eax]
    vmovdqu yword [edi], ymm1

    add eax, 32
    add edi, 32
    cmp eax, ebx
    jne .avxLoop

    mov ecx, dword [ebp + 4 + length]
    and ecx, -32
    lea edi, [edx + ecx]
    add esi, ecx
    cmp dword [ebp + 4 + length], ecx
    je .avxReturn
    add edx, dword [ebp + 4 + length]

.trailingBytesMovsbLoop:
    movsb

    cmp edx, edi
    jne .trailingBytesMovsbLoop
    jmp .avxReturn

.doMovsb:
    mov eax, dword [ebp + 4 + length]
    add eax, edx
    mov edi, edx

.movsbLoop:
    movsb

    cmp eax, edi
    jne .movsbLoop
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
    cmp eax, AVX2Supported - 1
    jg .notSSSE3
    mov dword [actualASM_bcopyPtr], actualASM_bcopySSSE3
    jmp .doJmp

.notSSSE3:
    mov dword [actualASM_bcopyPtr], actualASM_bcopyAVX2

.doJmp:
    mov dword [esp + 28 + length], ebx
    add esp, 24
    pop ebx
    jmp dword [actualASM_bcopyPtr]
