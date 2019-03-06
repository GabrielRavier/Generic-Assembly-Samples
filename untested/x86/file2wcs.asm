%include "macros.inc"

global _file2wcs
extern _iconv_open
extern _read
extern _iconv
extern ___errno_location
extern _memmove
extern _lseek
extern _iconv_close
extern _error
extern _perror

segment .rodata align=16

    align 16
    wchartStr db "WCHAR_T", 0

    align 16
    convNotAvailMsg db "conversion from '%s' to wchar_t not available", 0

    align 16
    iconvOpenStr db "iconv_open", 0

    align 16
    iconvCloseStr db "iconv_close", 0

segment .text align=16

_file2wcs:
    multipush ebp, ebx, edi, esi
    sub esp, 8204
    mov ebx, [esp + 8236]
    mov ebp, [esp + 8232]
    mov edi, [esp + 8228]

    mov dword [esp], 0 
    mov [esp + 4], ebp

    sub esp, 8
    multipush edi, wchartStr
    call _iconv_open
    add esp, 16

    cmp eax, -1
    je .somethingWentWrong

    mov esi, eax
    test ebx, ebx
    je .noTerminate

    lea ebp, [esp + 12]
    mov [esp + 8], ebp

    sub esp, 4
    multipush ebp, dword [esp + 8236]
    call _read
    add esp, 16

    mov ecx, [esp]
    test eax, eax
    je .fileFinished

    mov edi, esp
    lea ebx, [esp + 8]

.loop:
    add ecx, eax
    mov [esp], ecx

    sub esp, 12
    lea eax, [esp + 8248]
    push eax
    lea eax, [esp + 20]
    multipush eax, edi, ebx, esi
    call _iconv
    add esp, 32

    cmp eax, -1
    jne .everythingWentRight

    call ___errno_location
    cmp dword [eax], 22 ; 22 = EINVAL
    jne .realProblem

    sub esp, 4
    multipush dword [esp + 4], dword [esp + 16], ebp
    call _memmove
    add esp, 16

.everythingWentRight:
    cmp dword [esp + 8236], 0
    je .noTerminate

    mov eax, [esp]
    mov [esp + 8], ebp
    lea ecx, [esp + eax]
    add ecx, 12
    mov edx, 8192
    sub edx, eax
    sub esp, 4
    multipush edx, ecx, dword [esp + 8236]
    call _read
    add esp, 16
    
    mov ecx, [esp]
    test eax, eax
    jne .loop

.fileFinished:
    neg ecx
    sub esp, 4
    multipush 1, ecx, dword [esp + 8236]
    call _lseek
    add esp, 4

    lea eax, [esp + 8248]
    lea ecx, [esp + 16]
    multipush eax, ecx, 0, 0, esi
    call _iconv
    add esp, 32 

    cmp dword [esp + 8236], 4
    jb .noTerminate

.terminate:
    mov eax, [esp + 4]
    mov dword [eax], 0

.noTerminate:
    sub esp, 12
    push esi
    call _iconv_close
    add esp, 16
    test eax, eax
    jne .iconvCloseError

.retWrptrMinOutbuf:
    mov eax, [esp + 4]
    sub eax, [esp + 8232]
    sar eax, 2
    jmp .return

    align 16
.somethingWentWrong:
    call ___errno_location
    cmp dword [eax], 22 ; 22 = EINVAL
    jne .perrorIconvOpen

    multipush edi, convNotAvailMsg, 0, 0
    call _error

.termAndRetMin1:
    add esp, 16
    mov dword [ebp], 0
    mov eax, -1

.return:
    add esp, 8204
    multipop ebp, ebx, edi, esi
    ret

    align 16
.realProblem:
    xor eax, eax
    sub eax, [esp]
    sub esp, 4
    multipush 1, eax, dword [esp + 8236]
    call _lseek
    add esp, 16

    cmp dword [esp + 8236], 4
    jae .terminate
    jmp .noTerminate

    align 16
.iconvCloseError:
    sub esp, 12
    push iconvCloseStr
    call _perror
    add esp, 16
    jmp .retWrptrMinOutbuf

    align 16
.perrorIconvOpen:
    sub esp, 12
    push iconvOpenStr
    call _perror
    jmp .termAndRetMin1