global @ASM_floorLog2@4
extern _instructionSet

segment .text align=16

%define number ecx
%define result eax
%define loRetVal al
actualASM_floorLog2386:
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


%define FMA3_F16C_BMI1_BMI2_LZCNTSupported 14
@ASM_floorLog2@4:
    cmp dword [_instructionSet], FMA3_F16C_BMI1_BMI2_LZCNTSupported - 1
    jg .do386
    jmp actualASM_floorLog2BMI2
    align 16
.do386:
    jmp actualASM_floorLog2386
