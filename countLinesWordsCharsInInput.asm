; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Added separators
; 1.0.2 : Changed segment to .text and aligned function
; 1.0.3 : Added "Versions" section
; 1.0.4 : Separated code sections
; 2.0.0 : Essentially remade whole implementation

global _ASM_countLinesWordsCharsInInput
extern _getchar
extern _printf

segment .data

    align 16
    format db `%d lines, %d words, %d characters\n`, 0

segment .text align=16

%define charCount ebx
%define lineCount edi
%define currentChar eax
%define isInWord si
%define wordCount ebp

_ASM_countLinesWordsCharsInInput:
    push wordCount
    push lineCount
    push isInWord
    push charCount
    sub esp, 28
    xor wordCount, wordCount
    xor lineCount, lineCount
    xor isInWord, isInWord
    xor charCount, charCount
.loop:
    call _getchar
    cmp eax, `\\`
    je .stopCount
.checkChars:
    inc charCount
    cmp currentChar, `\n`
    je .newLine
    cmp currentChar, ` `
    je .newWord
    cmp currentChar, `\t`
    je .newWord
    test isInWord, isInWord
    jne .loop
    inc wordCount
    inc isInWord
    call _getchar
    cmp currentChar, `\\`
    jne .checkChars
.stopCount:
    mov dword [esp + 12], charCount ; Push the arguments manually
    mov dword [esp + 8], wordCount
    mov dword [esp + 4], lineCount
    mov dword [esp], format
    call _printf
    add esp, 28
    pop charCount
    pop isInWord
    pop lineCount
    pop wordCount
    jmp _getchar
    align 16
.newLine:
    inc lineCount
.newWord:
    xor isInWord, isInWord
    jmp .loop
