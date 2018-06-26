global @ASM_bitcount@4
extern _getInstructionSet

segment .data align=16

    actualASM_bitcountPtr dd actualASM_bitcountGetPtr

segment .text align=16

%define result eax
%define number ecx
%define temp edx
actualASM_bitcountNoPopcnt:
    mov result, number

    mov temp, result
    shr result, 1   ; Shift depending on the current "fence width" (increases)
    and result, 0x55555555    ; The magic numbers are bitmasks with an ever-widening "fence" of 1 and 0s
    and temp, 0x55555555    ; We end up with odd bits in result and even bits in number
    add result, temp

    ; Unrolled loop so it's quicker (and boring)
    mov temp, result
    shr result, 2
    and result, 0x33333333
    and temp, 0x33333333
    add result, temp

    mov temp, result
    shr result, 4
    add result, temp
    and result, 0x0F0F0F0F

    mov temp, result
    shr result, 8
    add result, temp
    mov temp, result
    shr result, 16  ; Last bitmask is 0x0000FFFF so that works too (and it's quicker)
    add result, temp

    and result, 0x03F   ; We apply the second-to-last bitmask here (it's quicker)
    ret





    align 16
actualASM_bitcountPopcnt:
    popcnt result, number
    ret





    align 16
%define popcntSupported 9
@ASM_bitcount@4:
    jmp dword [actualASM_bitcountPtr]

    align 16
actualASM_bitcountGetPtr:
    sub esp, 28
    mov dword [esp + 12], number

    call _getInstructionSet

    cmp eax, popcntSupported
    mov eax, actualASM_bitcountNoPopcnt
    mov edx, actualASM_bitcountPopcnt
    cmovge eax, edx
    mov dword [actualASM_bitcountPtr], eax

    mov number, dword [esp + 12]
    add esp, 28
    jmp eax

