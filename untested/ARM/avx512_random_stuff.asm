
    code32

    format  ELF
    public _ternlogd_scalar
    public _ternlogq_scalar
    public _pmadd52luq_scalar

section '.text' executable align 16

_ternlogd_scalar:
	push {r4, r5, lr}
	mov r5, r0
	mov lr, #0
	mov r0, lr
	
.loop:
	lsr r4, r5, lr
	
	lsl r4, #1
	and r4, #2
	
	lsr ip, r1, lr
	and ip, #3
	orr r4, ip, r4
	
	lsr ip, r2, lr
	and ip, #1
	orr ip, r4, lsl #1
	
	lsr ip, r3, ip
	and ip, #1
	orr r0, ip, lsl lr
	add lr, #1
	
	cmp lr, #32
	bne .loop
	
	pop {r4, r5, pc}
	
	
	
	
	
	
_ternlogq_scalar:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	mov r8, r0
	mov r7, r1
	ldr r10, [sp, #36]
	add r6, sp, #40
	ldm r6, {r6, r9}
	mov lr, #0
	
	mov r0, lr
	mov r1, lr
	
.loop:
	rsb r5, lr, #32
	sub r4, lr, #32
	lsr fp, r8, lr
	orr fp, r7, lsl r5
	orr fp, r7, lsr r4
	
	lsl fp, #1
	and fp, #2
	
	lsr ip, r2, lr
	orr ip, r3, lsl r5
	orr ip, r3, lsr r4
	and ip, #3
	orr fp, ip, fp
	
	lsr ip, r10, lr
	orr ip, r6, lsl r5
	orr ip, r6, lsr r4
	and ip, #1
	orr ip, fp, lsl #1
	
	lsr ip, r9, ip
	and ip, #1
	lsl r4, ip, r4
	orr r4, ip, lsr r5
	orr r0, ip, lsl lr
	orr r1, r4, r1
	add lr, #1
	
	cmp lr, #64
	bne .loop
	
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
	
	
	
	
	
_pmadd52luq_scalar:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub sp, #12
	mov fp, r2
	ldr r7, [sp, #48]
	
	mov r6, #0x100000
	sub r6, #1
	and r3, r6
	
	ldr r8, [sp, #52]
	and r8, r6
	
	mov r9, #0x10000
	sub r9, #1
	and r2, r9
	and ip, r7, r9
	mul r4, ip, r2
	
	lsr lr, fp, #16
	str lr, [sp, #4]
	mul lr, ip, lr
	add lr, r4, lsr #16
	
	and r4, r9
	
	add r4, lr, lsl #16
	
	lsr r10, r7, #16
	mul r5, r10, r2
	add r5, r4, lsr #16
	
	and r4, r9
	
	ldr ip, [sp, #4]
	mul ip, r10, ip
	add ip, lr, lsr #16
	add ip, r5, lsr #16
	
	mla r2, r8, fp, ip
	mla ip, r7, r3, r2
	
	add r2, r4, r5, lsl #16
	and ip, r6
	
	adds r0, r2, r0
	adc r1, ip, r1
	add sp, #12
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}