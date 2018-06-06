global _ASM_getProcessorName

segment .data
    align 16
    nameBuffer times 50h db 0   ; Static buffer for name

segment .text align=16

%define regNameBuffer edi
%define cpuidCheck eax
%define cpuidCheck2 ebx
%define cpuidResult eax
%define cpuidFunc eax
%define result eax
_ASM_getProcessorName:
    push cpuidCheck2
    push regNameBuffer
    mov regNameBuffer, nameBuffer
    ; Detect support of cpuid
    pushfd
    pop cpuidCheck
    xor cpuidCheck, 1 << 21    ; Check if can toggle CPUID bit
    push cpuidCheck
    popfd
    pushfd
    pop cpuidCheck2
    xor cpuidCheck, cpuidCheck2
    and cpuidCheck, 1 << 21
    jnz .noID    ; cpuid not supported
    xor cpuidFunc, cpuidFunc
    cpuid   ; Get number of cpuid functions
    test cpuidResult, cpuidResult
    jnz .canGetName ; Function 1 supported
.noID:
    ; Can't get the processor name (not supported)
    mov dword [regNameBuffer], '8038' ; Write text "80386 or 80486" to name buffer
    mov dword [regNameBuffer + 4], '6 or'
    mov dword [regNameBuffer + 8], ' 804'
    mov dword [regNameBuffer + 12], '86'    ; End with 0
    jmp .return
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.canGetName:
    mov cpuidFunc, 80000000h
    cpuid
    cmp cpuidResult, 80000004h  ; Check for extended vendor string availability
    jb .noExtendedVendorString
    ; Has extended string
    mov cpuidFunc, 80000002h
    cpuid
    mov [regNameBuffer], eax    ; Store 16 of vendor string
    mov [regNameBuffer + 4], ebx
    mov [regNameBuffer + 8], ecx
    mov [regNameBuffer + 12], edx
    mov cpuidFunc, 80000003h
    cpuid
    mov [regNameBuffer + 16], eax    ; Next 16 bytes
    mov [regNameBuffer + 20], ebx
    mov [regNameBuffer + 24], ecx
    mov [regNameBuffer + 28], edx
    mov cpuidFunc, 80000004h
    cpuid
    mov [regNameBuffer + 32], eax    ; Next 16 bytes
    mov [regNameBuffer + 36], ebx
    mov [regNameBuffer + 40], ecx
    mov [regNameBuffer + 44], edx
    jmp .getFamilyAndModel
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.noExtendedVendorString:
    ; No extended vendor string (instead get short vendor string
    xor cpuidFunc, cpuidFunc
    cpuid
    mov [regNameBuffer], ebx    ; Store short vendor string
    mov [regNameBuffer + 4], edx
    mov [regNameBuffer + 8], ecx
    mov byte [regNameBuffer + 12], 0    ; Terminate string
.getFamilyAndModel:
    push regNameBuffer
    xor eax, eax    ; Find 0 terminator
    mov ecx, 30h    ; Max 30 chars searched
    cld ; Go forward
    repne scasb ; Find end of text
    dec regNameBuffer
    mov dword [regNameBuffer], ' Fam'   ; Append " Family "
    mov dword [regNameBuffer + 4], 'ily '
    add regNameBuffer, 8
    mov cpuidFunc, 1
    cpuid   ; Get family and model
    mov ebx, eax
    mov ecx, eax
    shr eax, 8
    and eax, 0Fh     ; Family
    shr ecx, 20
    and ecx, 0FFh    ; Extended family
    add eax, ecx    ; Family + extended family
    call writeHex
    mov dword [regNameBuffer], 'H'  ; Write text "H"
    pop regNameBuffer   ; Restore string address
.return:
    mov result, regNameBuffer   ; Pointer to result
    pop regNameBuffer
    pop cpuidCheck2
    ret
; ------------------------------------------------------------------------------------------------------------------------

%define numberToWrite eax
%define textDestination edi
%define temp ecx
%define loTemp cl
writeHex:   ; Local function : Write 2 hexadecimal digits
    mov temp, numberToWrite
    shr temp, 4
    and temp, 0Fh ; Most significant digit first
    cmp temp, 10
    jnb .fromAtoF
    ; Number is from 0 to 9
    add temp, '0'
    jmp .writeDigit
; ------------------------------------------------------------------------------------------------------------------------
    align 16
.fromAtoF:
    ; Number is from A to F
    add temp, 'A' - 10
.writeDigit:
    mov [textDestination], loTemp  ; Write the digit
    mov temp, numberToWrite
    and temp, 0Fh    ; next digit
    cmp temp, 10
    jnb .fromAtoF2
    ; Number is from 0 to 9
    add temp, '0'
    jmp .writeDigit2
.fromAtoF2:
    ; Number is from A to F
    add temp, 'A' - 10
.writeDigit2:
    mov [textDestination + 1], loTemp   ; Write the digit
    add textDestination, 2  ; Advance string pointer
    ret
