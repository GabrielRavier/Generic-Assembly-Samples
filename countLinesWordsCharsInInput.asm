; Versions :
; 1.0.0 : Initial commit
; 1.0.1 : Added separators
; 1.0.2 : Changed segment to .text and aligned function
; 1.0.3 : Added "Versions" section
; 1.0.4 : Separated code sections

global _ASM_countLinesWordsCharsInInput
extern _getchar
extern _printf

segment .data

    align 16
    format db `%d lines, %d words, %d characters\n`, 0

segment .text align=16

%define charCount edx   ; int
%define lineCount esi   ; int
%define currentChar eax ; int
%define isInWord bl     ; bool
%define wordCount edi   ; int
; edx = charCount
; esi = lineCount
; eax = currentChar
; bl = isInWord
; edi = wordCount
_ASM_countLinesWordsCharsInInput:
    push ebp
    mov ebp, esp
    push wordCount
    push lineCount
    push ebx    ; isInWord
    sub esp, 28

    xor charCount, charCount
    xor wordCount, wordCount
    xor lineCount, lineCount
    xor isInWord, isInWord

.startLoop:
    mov dword [ebp - 28], charCount
    call _getchar
    mov charCount, dword [ebp - 28]

    cmp currentChar, `\\`   ; Stop at backslash
    je short .printAndReturn    ; Just to be sure return isn't too far

    inc charCount
    cmp currentChar, `\n`   ; newline more likely
    jne .checkOutWordChars

    inc lineCount
.isNotInWord:
    xor isInWord, isInWord
    jmp .startLoop
; ------------------------------------------------------------------------------------------------------------------------
    align 16

.checkOutWordChars:
    cmp currentChar, ` `
    je .isNotInWord

    cmp currentChar, `\t`
    je .isNotInWord

    test isInWord, isInWord
    jne .startLoop

    inc wordCount
    inc isInWord
    jmp .startLoop
; ------------------------------------------------------------------------------------------------------------------------
    align 16

.printAndReturn:
    push charCount
    push wordCount
    push lineCount
    push format
    call _printf

    call _getchar   ; Catch newline
    sub esp, 12

    pop ebx  ; isInWord
    pop lineCount
    pop wordCount
    pop ebp
    ret
