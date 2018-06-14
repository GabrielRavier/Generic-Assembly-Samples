global @ASM_memcpy@12

segment .text align=16

%define destination ecx
%define source edx
%define regLength eax
%define oldDest edi
%define oldSrc esi
%define backDest ebx
%define result eax
%define length 4
@ASM_memcpy@12:
    push oldDest
    push oldSrc
    push backDest

    mov oldDest, destination
    mov backDest, destination
    mov oldSrc, source
    mov regLength, [esp + 12 + length]

    cld ; So we don't have to do it later]

    cmp regLength, 7
    jbe .copyEndBytesAndRet

    neg destination
    and destination, 3
    sub regLength, destination
;   cld ; Already done
    rep movsb   ; Addresses already in esi and edi

    mov destination, regLength
    sub destination, 32
    js .lessThan20

    mov source, [oldDest]

.loop:
    mov regLength, [oldSrc]
    mov source, [oldSrc + 4]
    mov [oldDest], regLength
    mov [oldDest + 4], source

    mov regLength, [oldSrc + 8]
    mov source, [oldSrc + 12]
    mov [oldDest + 8], regLength
    mov [oldDest + 12], source

    mov regLength, [oldSrc + 16]
    mov source, [oldSrc + 20]
    mov [oldDest + 16], regLength
    mov [oldDest + 20], source

    mov regLength, [oldSrc + 24]
    mov source, [oldSrc + 28]
    mov [oldDest + 24], regLength
    mov [oldDest + 28], source

    add oldSrc, 32
    add oldDest, 32
    sub destination, 32
    jns .loop

.lessThan20:
    add destination, 32
    mov regLength, destination

.copyEndBytesAndRet:
    mov destination, regLength
;   cld ; already done
    rep movsb

    mov result, backDest
    pop backDest
    pop oldSrc
    pop oldDest
    ret 4
