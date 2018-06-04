global @ASM_strlen@4

segment text

%define string ecx  ; char *, string
%define result eax  ; length of string
%define scasbValue al
%define scasbAddress edi
%define scasbLimit ecx

@ASM_strlen@4:
    push scasbAddress   ; GCC expects us to preserve edi
    mov scasbAddress, string
    xor scasbLimit, scasbLimit
    not scasbLimit  ; scasbLimit = -1
    xor scasbValue, scasbValue  ; Search for 0
    cld ; Clear direction flag so that repne scasb goes forward
    repne scasb ; scasbLimit = -stringLength - 2
    not scasbLimit ; scasbLimit = stringLength + 1
    lea result, [scasbLimit - 1]
    pop scasbAddress
    ret
