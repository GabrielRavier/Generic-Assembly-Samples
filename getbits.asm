; Versions :
; 1.0.0 : Initial commit
; 1.1.0 : Changed a few things, made implementation faster
; 1.1.1 : Changed segment to .text and aligned function
; 1.1.2 : Added "Versions" section
; 1.1.3 : Added missing word in comment ("Discard" to "Discard position")

global @ASM_getbits@12

segment .text align=16

; Algorithm :   /* getbits:  get numBits bits from position position */
;               unsigned getbits(unsigned num, int position, int numBits)
;               {
;                   return (num >> (position+1-numBits)) & ~(~0 << numBits);
;               }

; Also calling proc is fastcall
%define regNumBits dl
%define result eax
%define number ecx
%define position edx
%define numBits 4
%define temp ecx
%define loTemp cl
%define temp2 edx
@ASM_getbits@12:
    mov result, number
    sub regNumBits, byte [esp + numBits]
    lea temp, [position + 1]  ; Discard number
    shr result, loTemp
    mov temp2, -1   ; Discard position
    mov loTemp, byte [esp + numBits]
    sal temp2, loTemp
    not temp2
    and result, temp2
    ret 4

