global @ASM_getbits@12

segment text

; Algorithm :   /* getbits:  get numBits bits from position position */
;               unsigned getbits(unsigned num, int position, int numBits)
;               {
;                   return (num >> (position+1-numBits)) & ~(~0 << numBits);
;               }

; Also calling proc is fastcall
%define number ecx
%define position edx
%define loNumber cl
%define result eax
%define numBits 4
%define regNumBits cl
@ASM_getbits@12:
    mov result, number
    lea number, [position + 1]
    sub number, [esp + numBits]
    or position, -1
    shr result, loNumber
    mov regNumBits, byte [esp + numBits]
    shl position, regNumBits
    not position
    and result, position
    ret 4
