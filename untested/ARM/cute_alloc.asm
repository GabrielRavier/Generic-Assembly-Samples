
    code32

    format  ELF
    public _ca_stack_create
    public _ca_stack_alloc
    public _ca_stack_free
    public _ca_stack_bytes_left
    public _ca_frame_create
    public _ca_frame_alloc
    public _ca_frame_free
    public _ca_alloc_head
    public _ca_leak_check_alloc
    public _ca_leak_check_calloc
    public _ca_leak_check_free
    public _CUTE_ALLOC_CHECK_FOR_LEAKS
    public _CUTE_ALLOC_BYTES_IN_USE
	
	extrn _malloc
	extrn _memset
	extrn _free
	extrn _printf
	extrn _puts
	
section '.rodata' align 16

	leakedMsg db 'LEAKED %llu bytes from file "%s" at line %d from address %p.', 12, 0
	
	
	successMsg db 'SUCCESS: No memory leaks detected.', 0
	
	
	warnMsg db 'WARNING: Memory leaks detected (see above).', 0
	
section '.data' writeable align 16
	
	ca_alloc_head_init dw 0

	ca_alloc_head_info db 20 dup 0
	
section '.text' executable align 16

_ca_stack_create:
	cmp r1, #11
	
	movhi r3, #0
	strhi r3, [r0, #12]
	
	addhi r3, r0, #16
	strhi r3, [r0]
	
	subhi r1, #16
	strhi r1, [r0, #4]
	strhi r1, [r0, #8]
	
	movls r0, #0
	bx lr
	
	
	
	
	
	
_ca_stack_alloc:
	mov r3, r0
	
	ldr r2, [r0, #8]
	sub r2, #4
	cmp r2, r1
	bcc .ret0
	
	ldr r0, [r0]
	str r1, [r0, r1]
	
	add r2, r1, #4
	add r2, r0, r2
	str r2, [r3]
	
	rsb r1, #-0x1000000
	add r1, #0xFF0000
	add r1, #0xFF00
	add r1, #0xFC
	ldr r2, [r3, #8]
	add r1, r2, r1
	str r1, [r3, #8]
	bx lr
	
.ret0:	
	mov r0, #0
	bx lr
	
	
	
	
	
	
_ca_stack_free:
	cmp r1, #0
	beq .ret0
	
	ldr r3, [r0]
	ldr r2, [r3, #-4]
	
	sub r3, r2
	sub r3, #4
	
	cmp r1, r3
	beq .continue
	
.ret0:	
	mov r0, #0
	bx lr
	
	
.continue:
	str r1, [r0]
	ldr r3, [r0, #8]
	add r3, #4
	add r3, r2
	str r3, [r0, #8]
	
	mov r0, #1
	bx lr
	
	
	
	
	
	
_ca_stack_bytes_left:
	ldr r0, [r0, #8]
	bx lr
	
	
	
	
	
	
_ca_frame_create:
	add r2, r0, #16
	str r2, [r0]
	
	str r2, [r0, #4]
	
	sub r1, #16
	str r1, [r0, #12]
	str r1, [r0, #8]
	bx lr
	
	
	
	
	
	
_ca_frame_alloc:
	mov r3, r0
	
	ldr r2, [r0, #12]
	cmp r2, r1
	
	ldrcs r0, [r0, #4]
	addcs ip, r0, r1
	strcs ip, [r3, #4]
	subcs r2, r1
	strcs r2, [r3, #12]
	
	movcc r0, #0
	bx lr
	
	
	
	
	
	
_ca_frame_free:
	ldr r3, [r0]
	str r3, [r0, #4]
	
	ldr r3, [r0, #8]
	str r3, [r0, #12]
	
	bx lr
	
	
	
	
	
	
_ca_alloc_head:
	ldr r3, [.addrInit]
	ldr r2, [r3]
	cmp r2, #0
	
	addeq r2, r3, #4
	streq r2, [r3, #16]
	streq r2, [r3, #20]
	
	moveq r2, #1
	streq r2, [r3]
	
	ldr r0, [.addrInfo]
	bx lr
	
.addrInit:
	dw ca_alloc_head_init
	
.addrInfo:
	dw ca_alloc_head_info
	
	
	
	
	
	
_ca_leak_check_alloc:
	push {r4, r5, r6, r7, r8, lr}
	mov r5, r0
	mov r7, r1
	mov r6, r2
	
	add r0, #20
	bl _malloc
	
	subs r4, r0, #0
	beq .ret0
	
	str r7, [r4]
	stmib r4, {r5, r6}
	
	bl _ca_alloc_head
	
	str r0, [r4, #16]
	ldr r3, [r0, #12]
	str r3, [r4, #12]
	ldr r3, [r0, #12]
	str r4, [r3, #16]
	str r4, [r0, #12]
	
	add r0, r4, #20
	pop {r4, r5, r6, r7, r8, pc}
	
.ret0:
	mov r0, r4
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
	
_ca_leak_check_calloc:
	push {r4, lr}
	mov ip, r2
	
	mul r4, r1, r0
	
	mov r2, r3
	mov r1, ip
	mov r0, r4
	bl _ca_leak_check_alloc
	
	mov r2, r4
	mov r1, #0
	bl _memset
	
	pop {r4, pc}
	
	
	
	
	
	
_ca_leak_check_free:
	cmp r0, #0
	bxeq lr
	
	ldr r2, [r0, #-4]
	ldr r3, [r0, #-8]
	str r3, [r2, #12]
	str r2, [r3, #16]
	
	sub r0, #20
	b _free
	
	
	
	
	
	
_CUTE_ALLOC_CHECK_FOR_LEAKS:
	push {r4, r5, r6, lr}
	sub sp, #8
	
	bl _ca_alloc_head
	
	ldr r4, [r0, #12]
	
	cmp r0, r4
	beq .success
	
	mov r5, r0
	ldr r6, [.oLeakedMsg]
	
.loop:
	ldr r3, [r4, #8]
	ldr r2, [r4]
	ldr r1, [r4, #4]
	add r0, r4, #20
	str r0, [sp]
	mov r0, r6
	bl _printf
	
	ldr r4, [r4, #12]
	
	cmp r5, r4
	bne .loop
	
	ldr r0, [.oWarnMsg]
	bl _puts
	
	mov r0, #1
	
	add sp, #8
	pop {r4, r5, r6, pc}
	
	
.success:
	ldr r0, [.oSuccessMsg]
	bl _puts
	mov r0, #0
	
	add sp, #8
	pop {r4, r5, r6, pc}
	
.oLeakedMsg:
	dw leakedMsg
	
.oSuccessMsg:
	dw successMsg
	
.oWarnMsg:
	dw warnMsg
	
	
	
	
	
	
_CUTE_ALLOC_BYTES_IN_USE:
	push {r4, lr}
	
	bl _ca_alloc_head
	
	ldr r3, [r0, #12]
	
	mov r2, #0
	cmp r0, r3
	beq .return
	
.loop:
	ldr r1, [r3, #4]
	add r2, r1
	ldr r3, [r3, #12]
	cmp r0, r3
	bne .loop
	
.return:
	mov r0, r2
	pop {r4, pc}