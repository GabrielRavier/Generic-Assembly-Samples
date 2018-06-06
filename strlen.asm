global @ASM_strlen@4

segment text

%define string ecx  ; char *, string
%define loString cl
%define result eax  ; length of string
%define xmmZero xmm1
%define xmmRead xmm0
%define foundBits edx
%define backupString ebx
@ASM_strlen@4:
    push backupString
    mov backupString, string
    mov result, string  ; Copy pointer
    pxor xmmZero, xmmZero

    and string, 0x0F    ; Check for misalignment
    and result, -0x10   ; Align pointer

    movdqa xmmRead, [result]    ; Read from preceding boundary
    pcmpeqb xmmRead, xmmZero    ; Compare 16 bits with 0
    pmovmskb foundBits, xmmRead ; Get one bit for each byte result

    shr foundBits, loString ; Shift out false bits
    shl foundBits, loString ; Shift back again
    bsf foundBits, foundBits    ; Find first set bit
    jnz .found

.mainLoop:
    add result, 16

    movdqa xmmRead, [result]    ; Read 16 aligned bytes
    pcmpeqb xmmRead, xmmZero    ; Compare the 16 bytes with 0
    pmovmskb foundBits, xmmRead ; Get one bit for each byte results

    ; No need to shift out false bits
    bsf foundBits, foundBits
    jz .mainLoop

.found:
    ; Terminator found, compute string length
    sub eax, backupString  ; Substract start address
    add result, foundBits   ; Add byte index
    pop backupString
    ret
