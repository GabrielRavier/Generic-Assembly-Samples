; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Corrected typo
; 1.0.2 : Changed segment to .text and aligned function
; 1.0.3 : Added spacing for code sections
; 1.0.4 : Added "Versions" section

global _ASM_readTSC

segment .text align=16

%define loResult eax
%define hiResult edx
_ASM_readTSC:
    push ebx    ; Modified by cpuid

    xor loResult, loResult
    cpuid   ; Serialize

    rdtsc   ; Read time stamp counter

    push loResult
    push hiResult
    xor loResult, loResult
    cpuid   ; Serialize
    pop hiResult
    pop loResult

    pop ebx
    ret
