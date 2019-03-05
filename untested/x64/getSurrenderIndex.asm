%include "macros.inc"

global _getSurrenderIndex

segment .rodata align=16

	align 16
	zeroDot001 dq 0.001

	align 16
	zeroDot2 dq 0.2
	zeroDot4 dq 0.4

	align 16
	zeroDot6 dq 0.6

	align 16
	zeroDot8 dq 0.8

	align 16
	one dq 1.0

	align 16
	oneDot1 dq 1.1

	align 16
	oneDot2 dq 1.2

	align 16
	twoDot59 dq 2.59

segment .text align=16

    align 16
getYardMultiplier:
    movsd xmm0, [rel one]
    test edi, edi
    js .return

    mov eax, 60
    cmp edi, 110
    jle .larger110

.doOneDot2Loop:
    movsd xmm0, [rel twoDot59]
    movsd xmm1, [rel oneDot2]
    xor ecx, ecx

.oneDot2Loop:
    inc ecx
    mulsd xmm0, xmm1
    cmp ecx, eax
    jl .oneDot2Loop
    jmp .return

    align 16
.larger110:
    cmp edi, 41
    jl .return

    cmp edi, 50
    jg .check

    movsd xmm0, [rel one]
    movsd xmm1, [rel oneDot1]
    sub edi, 40

.oneDot1Loop:
    mulsd xmm0, xmm1
    dec edi
    jne .oneDot1Loop

.return:
    ret

    align 16
.check:
    sub edi, 50
    mov eax, edi
    jg .doOneDot2Loop

    movsd xmm0, [twoDot59]
    ret





    align 16
getFirstDownMultiplier:
    movsd xmm0, [rel one]
    test edi, edi
    js .return

    cmp edi, 110
    jle .skip

    movsd xmm0, [zeroDot2]
    ret

    align 16
.skip:
    cmp edi, 2
    jl .return

    cmp edi, 4
    jge .skip2

    movsd xmm0, [rel zeroDot8]
    ret

    align 16
.skip2:
    cmp edi, 7
    jge .skip3

    movsd xmm0, [rel zeroDot6]
    ret

    align 16
.skip3:
    xor eax, eax
    cmp edi, 10
    setl al

    movsd xmm0, [zeroDot2 + rax * 8]

.return:
    ret





getScoreDiffMultiplier:
    test edi, edi
    jg .ret1
    je .ret2

    xor eax, eax
    cmp edi, -8
    setge al

    add eax, 3
    ret

    align 16
.ret1:
    mov eax, 1
    ret

    align 16
.ret2:
    mov eax, 2
    ret





getClockMultiplier:
    movsd xmm0, [rel one]
    test edi, edi
    jg .return

    test esi, esi
    js .return

    cvtsi2sd xmm1, esi
    mulsd xmm1, [rel zeroDot001]
    movapd xmm0, xmm1
    mulsd xmm0, xmm1
    mulsd xmm0, xmm1
    addsd xmm0, [rel one]

.return:
    ret





_getSurrenderIndex:
    push rbp
    push rbx
    sub rsp, 24
    mov rbx, rdi
    
    mov edi, [rdi]
    call getYardMultiplier

    mov edi, [rbx + 4]
    movsd [rsp + 16], xmm0
    mov edi, ebp
    call getScoreDiffMultiplier

    mov esi, [rbx + 12]
    mov edi, ebp

    cvtsi2sd xmm0, rax
    mulsd xmm0, [rsp + 8]
    movsd [rsp + 8], xmm0
    call getClockMultiplier

    mulsd xmm0, [rsp + 8]
    mulsd xmm0, [rsp + 16]

    add rsp, 24
    pop rbx
    pop rbp
    ret