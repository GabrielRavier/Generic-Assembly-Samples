global @ASM_reverseString@4
extern @ASM_strlen@4
%define ASM_strlen @ASM_strlen@4

segment .text align=16

%define string ecx
%define stringBackup esi
%define strlenRet eax
%define pEnd eax
%define result eax
%define pStart edx
%define currentStartChar cl
%define currentEndChar bl
%define currentEndChar16 bx
@ASM_reverseString@4:
    push stringBackup
    push currentEndChar16
    sub esp, 4

    mov stringBackup, string

    call ASM_strlen
    lea pEnd, [stringBackup - 1 + strlenRet]    ; pEnd = string + strlen(string) - 1;

    cmp stringBackup, pEnd
    jnb .return
    mov pStart, stringBackup

.loop:
    mov currentStartChar, byte [pStart]
    mov currentEndChar, byte [pEnd]

    mov [pStart], currentEndChar
    mov [pEnd], currentStartChar

    inc pStart
    dec pEnd

    cmp pStart, pEnd
    jb .loop

.return:
    mov result, stringBackup
    add esp, 4
    pop currentEndChar16
    pop stringBackup
    ret
