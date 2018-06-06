global _ASM_readTSC

segment text

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
