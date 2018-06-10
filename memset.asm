; Versions :
; 0.0.1 : Initial commit (implementation not done)
; 0.5.0 : Made initial implementation (that doesn't work)
; 1.0.0 : Made some small changes and changed ret to ret 4 (now implementation works)
; 1.0.1 : Commented return value
; 1.0.2 : Changed segment to .text and aligned function
; 1.0.3 : Added "Versions" section

global @ASM_memset@12

segment .text align=16

%define buffer ecx
%define character edx
%define loCharacter dl
%define size 4
%define regSize esi
%define xmmTemp xmm0
%define sizeCopy ecx
%define bufferCopy eax
%define sizeCopy2 edi
%define bufferCopy2 ebx
%define characterCopy 16


; This implementation looks horrible (uses xmm for faster moving, then does loop unrolling for the remaining bytes (less than 16)
@ASM_memset@12:
    push sizeCopy2
    push regSize
    push bufferCopy2
    sub esp, 16
    mov bufferCopy, buffer
    mov sizeCopy, dword [esp + 28 + size]
    test sizeCopy, sizeCopy
    je .return
    lea regSize, [sizeCopy - 1]
    cmp regSize, 14
    jbe .doLessThan16   ; If there are less than 15 bytes remaining, xmm is useless
    mov dword [esp + 28 - characterCopy], character
    mov sizeCopy2, sizeCopy
    mov bufferCopy2, bufferCopy
    and sizeCopy2, -16
    add sizeCopy2, bufferCopy
    movd xmmTemp, dword [esp + 28 - characterCopy]  ; Here starts the SSE fuckery
    punpcklbw xmmTemp, xmmTemp
    punpcklwd xmmTemp, xmmTemp
    pshufd xmmTemp, xmmTemp, 0
.xmmLoop:
    movups oword [bufferCopy2], xmmTemp
    add bufferCopy2, 16
    cmp bufferCopy2, sizeCopy2
    jne .xmmLoop
    mov sizeCopy2, regSize
    and sizeCopy2, -16
    sub regSize, sizeCopy2
    lea bufferCopy2, [bufferCopy + sizeCopy2]
    cmp sizeCopy, sizeCopy2
    je .return
.doRemaining16Bytes:
    mov byte [bufferCopy2], loCharacter
    cmp regSize, 1
    je .return
    mov byte [bufferCopy2 + 1], loCharacter
    cmp regSize, 2
    je .return
    mov byte [bufferCopy2 + 2], loCharacter
    cmp regSize, 3
    je .return
    mov byte [bufferCopy2 + 3], loCharacter
    cmp regSize, 4
    je .return
    mov byte [bufferCopy2 + 4], loCharacter
    cmp regSize, 5
    je .return
    mov byte [bufferCopy2 + 5], loCharacter
    cmp regSize, 6
    je .return
    mov byte [bufferCopy2 + 6], loCharacter
    cmp regSize, 7
    je .return
    mov byte [bufferCopy2 + 7], loCharacter
    cmp regSize, 8
    je .return
    mov byte [bufferCopy2 + 8], loCharacter
    cmp regSize, 9
    je .return
    mov byte [bufferCopy2 + 9], loCharacter
    cmp regSize, 10
    je .return
    mov byte [bufferCopy2 + 10], loCharacter
    cmp regSize, 11
    je .return
    mov byte [bufferCopy2 + 11], loCharacter
    cmp regSize, 12
    je .return
    mov byte [bufferCopy2 + 12], loCharacter
    cmp regSize, 13
    je .return
    mov byte [bufferCopy2 + 13], loCharacter
    cmp regSize, 14
    je .return
    mov byte [bufferCopy2 + 14], loCharacter
.return:
    add esp, 16 ; Btw bufferCopy (it is unchanged) is our return value (lol I did that by total accident)
    pop bufferCopy2
    pop regSize
    pop sizeCopy2
    ret 4
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.doLessThan16:
    mov bufferCopy2, bufferCopy
    jmp .doRemaining16Bytes
