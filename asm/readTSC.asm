;          RDTSC32.ASM
;
; Original Author:           Agner Fog
; Date created:     2003
; Last modified:    2018-06-28, by Gabriel Ravier
; Description:
;
; Copyright (c) 2018 GNU General Public License www.gnu.org/licenses
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global _ASM_readTSC

segment .text align=16

; This function returns the value of the time stamp counter, which counts
; clock cycles. To count how many clock cycles a piece of code takes, call
; Rdtsc before and after the code to measure and calculate the difference.

; The number of clock cycles taken by the ReadTSC function itself is approximately:
; Core 2:   730
; Pentium 4:  700
; Pentium II and Pentium III: 225
; AMD Athlon 64, Opteron: 126
; Does not work on 80386 and 80486.

; Note that clock counts may not be fully reproducible on Intel Core and
; Core 2 processors because the clock frequency can change. More reliable
; instruction timings are obtained with the performance monitor counter
; for "core clock cycles". This requires a kernel mode driver as the one
; included with www.agner.org/optimize/testp.zip.

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
