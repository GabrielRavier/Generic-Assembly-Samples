; Versions :
; 1.0.0 : Initial commit
; 2.0.0 : Made implementation using other faster functions
; 2.0.1 : Changed segment to .text and aligned function
; 2.0.2 : Added "Versions" section
; 2.1.0 : Made implementation directly jump to memset since that's faster (we return its result so it works)
; 2.1.1 : Made local implementation (doesn't crash on Cygwin)

global @ASM_strset@8

segment .text align=16

%define string ecx  ; char *, string to modify
%define character edx      ; char, value to fill string with
%define result eax   ; char *, string, now filled with character
%define backCharacter esi
%define loBackCharacter si
%define backString ebx
%define scasbAddr edi
%define scasbChar eax
%define scasbLimit ecx
%define stosbChar ax
%define stosbAddr edi

@ASM_strset@8:
    mov backCharacter, character
    mov backString, string
    mov scasbAddr, string
    xor scasbChar, scasbChar    ; Searching for null terminator
    xor scasbLimit, scasbLimit
    not scasbLimit
    cld ; Scan right
    repne scasb
    not scasbLimit
    dec scasbLimit  ; scasbLimit = strlen(string)
    mov stosbChar, loBackCharacter
;   mov stosbAddr, backString   ; edi already equal to string
    rep stosb
    mov result, backString  ; Return value = string address
    ret
