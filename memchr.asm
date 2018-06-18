; Weird name to avoid linking warning
global @ASM_memchr@12

segment .text align=16
; According to the __fastcall calling convention, first argument goes to ecx and the second to edx

%define buffer ecx
%define loBuffer cl
%define character dl
%define exCharacter edx
%define result eax
%define regCount eax
%define startChar ebp
%define repeatedChar edi
%define temp ebx
%define loTemp bl
%define charPtr ebx
%define temp2 esi
%define count 4
@ASM_memchr@12:
    push startChar
    push repeatedChar
    push temp2
    push charPtr
    mov regCount, [esp + 16 + count]

    test regCount, regCount
    je .returnNULL

    mov startChar, exCharacter
    test loBuffer, 3
    je .isAligned

    cmp character, byte [buffer]
    jne .continueAlignLoop
    jmp .returnBuffer
    align 16
    ; First we align the buffer ptr with the next 4-byte boundary
.alignLoop:
    test loBuffer, 3
    je .isAligned

    cmp byte [ecx], character
    je .returnBuffer
.continueAlignLoop:
    inc buffer

    dec regCount
    jne .alignLoop

.returnNULL:
    xor result, result

.return:
    pop charPtr
    pop temp2
    pop repeatedChar
    pop startChar
    ret 4
    align 16

.returnBuffer:
    mov result, buffer

    pop charPtr
    pop temp2
    pop repeatedChar
    pop startChar
    ret 4
    align 16

.isAligned:
    mov temp, startChar
    movzx temp, loTemp
    mov repeatedChar, temp
    sal repeatedChar, 8
    or repeatedChar, temp

    mov temp, repeatedChar
    sal temp, 16
    or repeatedChar, temp
    ; repeatedChar now has character in every byte

    cmp regCount, 3
    jbe .scanRemainingBytes   ; Loop till regCount smaller than a dword

    mov temp, dword [buffer]
    xor temp, repeatedChar  ; We only have to check for each byte being 0 now

    mov temp2, temp
    sub temp, 0x01010101
    not temp2
    and temp, temp2
    and temp, -2139062144
    je .continueDwordLoop
    jmp .scanRemainingBytes
    align 16

.dwordLoop:
    mov temp, dword [buffer]
    xor temp, repeatedChar

    lea temp2, [temp - 0x01010101]
    not temp
    and temp, temp2
    and temp, -2139062144
    jne .scanRemainingBytes

.continueDwordLoop:
    sub regCount, 4

    add buffer, 4

    cmp regCount, 3
    ja .dwordLoop

    test regCount, regCount
    je .returnNULL

.scanRemainingBytes:
    mov temp, startChar
    cmp loTemp, byte [buffer]
    je .returnBuffer
    lea temp, [buffer + 1]
    add buffer, regCount
    jmp .continueRemainingBytesLoop
    align 16
.scanRemainingBytesLoop:
    inc charPtr
    cmp byte [charPtr - 1], character
    je .return
.continueRemainingBytesLoop:
    mov regCount, charPtr
    cmp buffer, charPtr
    jne .scanRemainingBytesLoop
    jmp .returnNULL
