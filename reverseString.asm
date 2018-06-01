global @ASM_reverseString@4
extern @ASM_strlen@4
%define ASM_strlen @ASM_strlen@4

segment text

%define string ecx
%define stringBackup ebx
%define backwards eax   ; Index in the string (goes backwards)
%define forwards edx    ; Index in the string (goes forwards)
%define character cl
%define charBackup si
%define retString eax

@ASM_reverseString@4:
    push charBackup
    push stringBackup
    mov stringBackup, string    ; __fastcall specifies that ecx may be trashed
    call ASM_strlen  ; Argument (string) already in ecx
    dec backwards   ; backwards = ASM_strlen - 1
    test backwards, backwards
    jle .return
    xor forwards, forwards
.loop:
    movzx charBackup, byte [stringBackup + forwards]
    mov character, byte [stringBackup + backwards]
    mov [stringBackup + forwards], character
    mov cx, charBackup  ; same as mov character, charBackup (except that's invalid)
    mov [stringBackup + backwards], character
    inc forwards
    dec backwards
    cmp forwards, backwards
    jl .loop    ; While backwards bigger than forwards
.return:
    mov retString, stringBackup
    pop stringBackup
    pop charBackup
    ret
