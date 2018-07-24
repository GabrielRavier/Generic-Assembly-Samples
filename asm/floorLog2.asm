global @ASM_floorLog2@4
extern _getInstructionSet

segment .data align=16

    actualASM_floorLog2Ptr dd actualASM_floorLog2GetPtr

segment .text align=16

%define number ecx
%define result eax
%define loRetVal al
actualASM_floorLog2NoBMI2:
    push ebx
    mov edx, number

    mov result, number
    shr result, 16
    neg result
    shr result, 27
    and result, 16

    mov cl, loRetVal
    shr edx, cl

    mov ebx, edx
    shr ebx, 8
    neg ebx
    shr ebx, 28
    and ebx, 8

    or result, ebx
    mov cl, bl
    shr edx, cl

    mov ecx, edx
    shr ecx, 4
    neg ecx
    shr ecx, 29
    and ecx, 4

    or eax, ecx
    shr edx, cl

    mov ecx, edx
    shr ecx, 2
    neg ecx
    shr ecx, 30
    and ecx, 2

    shr edx, cl
    shr edx, 1
    or result, ecx
    or result, edx

    pop ebx
    ret





    align 16
actualASM_floorLog2BMI2:
    push ebx

    mov eax, number
    shr eax, 16
    neg eax
    shr eax, 27
    and eax, 16

    shrx ebx, number, eax

    mov ecx, ebx
    shr ecx, 8
    neg ecx
    shr ecx, 28
    and ecx, 8

    or eax, ecx
    shrx edx, ebx, ecx

    mov ecx, edx
    shr ecx, 4
    neg ecx
    shr ecx, 29
    and ecx, 4

    or eax, ecx
    mov ebx, eax
    shrx ecx, edx, ecx

    mov edx, ecx
    shr edx, 2
    neg edx
    shr edx, 30
    and edx, 2

    shrx ecx, ecx, edx

    mov result, ecx
    shr result, 1
    or ebx, edx
    or result, ebx

    pop ebx
    ret





    align 16
%define FMA3_F16C_BMI1_BMI2_LZCNTSupported 14
@ASM_floorLog2@4:
    jmp dword [actualASM_floorLog2Ptr]

    align 16
actualASM_floorLog2GetPtr:
    sub esp, 28
    mov dword [esp + 12], number

    call _getInstructionSet

    cmp eax, FMA3_F16C_BMI1_BMI2_LZCNTSupported
    mov eax, actualASM_floorLog2NoBMI2
    mov edx, actualASM_floorLog2BMI2
    cmovge eax, edx
    mov dword [actualASM_floorLog2Ptr], eax

    mov number, dword [esp + 12]
    add esp, 28
    jmp eax
