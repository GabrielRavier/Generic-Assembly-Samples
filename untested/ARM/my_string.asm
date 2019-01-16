
    code32

    format  ELF
	public _bcopy
	public _bzero
	public _memccpy
	public _memchr
	public _memcmp
	public _memcpy
	public _memfrob
	public _memmem
	public _mempcpy
	public _memrchr
	public _memset
	public _stpcpy
	public _stpncpy
	public _strcasecmp
	public _strcasestr
	public _strcat
	public _strchr
	public _strchrnul
	public _strcmp
	public _strcpy
	public _strcspn
	public _strdup
	public _strlen
	public _strncasecmp
	public _strncat
	public _strncmp
	public _strncpy
	public _strndup
	public _strnlen
	public _strpbrk
	public _strrchr
	public _strsep
	public _strspn
	public _strstr
	public _swab
	
	extrn _malloc
	
section '.text' executable align 16

_bcopy:
	mov r3, r1
	mov r1, r0
	mov r0, r3
	b _memmove
	
	
	
	
	
_bzero:
	mov r2, r1
	mov r1, #0
	b _memset
	
	
	
	
	
_memccpy:
	push {r4, r5, r6, r7, r8, lr}
	mov r7, r0
	mov r4, r1
	mov r1, r2
	mov r5, r3
	
	mov r2, r3
	mov r0, r4
	bl _memchr
	subs r6, r0, #0
	beq .null
	
	rsb r2, r4, #1
	add r2, r6, r2
	mov r1, r4
	mov r0, r7
	pop {r4, r5, r6, r7, r8, lr}
	b _mempcpy
	
.null:
	mov r2, r5
	mov r1, r4
	mov r0, r7
	bl _memcpy
	
	mov r0, r6
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
_memchr:
	cmp r2, #0
	beq .n0
	
	and r1, #0xFF
	ldrb r3, [r0]
	cmp r3, r1
	bxeq lr
	
	add r3, r0, #1
	add r2, r0, r2
	b .startLoop
	
.loop:
	add r3, #1
	ldrb ip, [r0]
	cmp ip, r1
	bxeq lr
	
.startLoop:
	mov r0, r3
	cmp r3, r2
	bne .loop
	
.n0:
	mov r0, #0
	bx lr

	
	
	
	
_memcmp:
	sub ip, r2, #1
	cmp r2, #0
	beq .ret0
	
	ldrb r3, [r0]
	ldrb r2, [r1]
	
	cmp r2, r3
	addeq ip, r1, ip
	beq .startLoop
	b .retP1MinP2
	
.loop:
	ldrb r3, [r0, #1]!
	ldrb r2, [r1, #1]!
	cmp r3, r2
	bne .retP1MinP2
	
.startLoop:
	cmp r1, ip
	bne .loop
	
.ret0:
	mov r0, #0
	bx lr
	
.retP1MinP2:
	sub r0, r3, r2
	bx lr
	
	
	
	
	
_memcpy:
	cmp r2, #0
	bxeq lr
	
	push {r4, r5, lr}
	sub r5, r2, #1
	orr r3, r0, r1
	and r3, #3
	
	cmp r5, #7
	movls ip, #0
	movhi ip, #1
	
	cmp r3, #0
	movne ip, #0
	
	cmp ip, #0
	beq .startSmallLoop
	
	sub ip, r1, #4
	bic r4, r2, #3
	add r4, r0, r4
	mov r3, r0
	
.loop:
	ldr lr, [ip, #4]!
	str lr, [r3], #4
	
	cmp r3, r4
	bne .loop
	
	bic r3, r2, #3
	add ip, r0, r3
	add lr, r1, r3
	sub r5, r3
	cmp r2, r3
	popeq {r4, r5, pc}
	
	ldrb r2, [r1, r3]
	strb r2, [r0, r3]
	
	cmp r5, #0
	popeq {r4, r5, pc}
	
	ldrb r3, [lr, #1]
	strb r3, [ip, #1]
	
	cmp r5, #1
	ldrbne r3, [lr, #2]
	strbne r3, [ip, #2]
	pop {r4, r5, pc}
	
.startSmallLoop:
	add r2, r0, r2
	mov r3, r0
	
.smallLoop:
	ldrb ip, [r1], #1
	strb ip, [r3], #1
	
	cmp r3, r2
	bne .smallLoop
	
	pop {r4, r5, pc}
	
	
	
	
	
_memfrob:
	cmp r1, #0
	bxeq lr
	
	add r1, r0, r1
	mov r3, r0
	
.loop:
	ldrb r2, [r3], #1
	eor r2, #42
	strb r2, [r3, #-1]
	
	cmp r3, r1
	bne .loop
	
	bx lr
	
	
	
	
	
_memmem:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub sp, #12
	
	rsbs r4, r3, #1
	movcc r4, #0
	cmp r3, r1
	orrhi r4, #1
	cmp r1, #0
	moveq r4, #0
	cmp r4, #0
	bne .ret0
	
	ldrb ip, [r2]
	str ip, [sp, #4]
	cmp r3, #1
	bls .degenerateCase
	
	mov r7, r0
	mov r6, r3
	
	ldrb r8, [r2, #1]
	
	cmp ip, r8
	movne r3, #2
	moveq r3, #1
	str r3, [sp]
	movne fp, #1
	moveq fp, #2
	
	sub r10, r6, #2
	add r9, r2, #2
	
	sub r6, r1, r6
	b .startLoop
	
.loop:
	cmp r6, r4
	bcc .ret0
	
.startLoop:
	add r5, r7, r4
	ldrb r2, [r5, #1]
	cmp r2, r8
	addne r4, fp
	bne .loop
	
	add r1, r4, #2
	mov r2, r10
	add r1, r7, r1
	mov r0, r9
	bl _memcmp
	
	cmp r0, #0
	bne .notEqual
	
	ldrb r2, [r5]
	ldr r3, [sp, #4]
	cmp r2, r3
	beq .retR5
	
.notEqual:
	ldr r3, [sp]
	add r4, r3
	
	cmp r6, r4
	bcs .startLoop
	
.ret0:
	mov r0, #0

.return:
	add sp, #12
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
.retR5:
	mov r0, r5
	b .return
	
.degenerateCase:
	mov r2, r1
	ldr r1, [sp, #4]
	add sp, #12
	pop {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	b _memchr
	
	
	
	
	
_memmove:
	cmp r0, r1
	beq .retR1
	bls .less
	
	cmp r2, #0
	beq .retR1
	
	str lr, [sp, #-4]!
	sub r3, r0, #1
	add r2, r1, r2
	mov ip, r1
	
.forwardsLoop:
	ldrb lr, [r3, #1]!
	strb lr, [ip], #1
	
	cmp ip, r2
	bne .forwardsLoop
	
	mov r0, r1
	ldr pc, [sp], #4
	
.less:
	sub ip, r2, #1
	add ip, r1, ip
	
	cmp r2, #0
	beq .retR1
	
	add r2, r0, r2
	sub r0, r1, #1
	
.backwardsLoop:
	ldrb r3, [r2, #-1]!
	strb r3, [ip], #-1
	cmp r0, ip
	bne .backwardsLoop
	
.retR1:
	mov r0, r1
	bx lr
	
	
	
	
	
_mempcpy:
	push {r4, lr}
	mov r4, r2
	
	bl _memcpy
	
	add r0, r4
	pop {r4, pc}
	
	
	
	
	
_memrchr:
	subs r3, r2, #1
	bmi .ret0
	
	str lr, [sp, #-4]!
	
	add ip, r0, r3
	and r1, #0xFF
	ldrb lr, [r0, r3]
	cmp lr, r1
	beq .retIp
	
	sub r2, #2
	add r2, r0, r2
	b .startLoop
	
.loop:
	mov ip, r2
	sub r2, #1
	ldrb r0, [ip]
	cmp r0, r1
	beq .retIp
	
.startLoop:
	subs r3, #1
	bcs .loop
	
	mov ip, #0
	
.retIp:
	mov r0, ip
	ldr pc, [sp], #4
	
.ret0:
	mov r0, #0
	bx lr
	
	
	
	
	
_memset:
	cmp r2, #0
	bxeq lr
	
	and r1, #0xFF
	add r2, r0, r2
	mov r3, r0
	
.loop:
	strb r1, [r3], #1
	cmp r3, r2
	bne .loop
	
	bx lr
	
	
	
	
	
_stpcpy:
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r5, r1
	
	mov r0, r1
	bl _strlen
	mov r4, r0
	
	add r2, r0, #1
	mov r1, r5
	mov r0, r6
	bl _memcpy
	
	add r0, r4
	pop {r4, r5, r6, pc}
	
	
	
	
	
_stpncpy:
	push {r4, r5, r6, r7, r8, lr}
	mov r4, r0
	mov r7, r1
	mov r6, r2
	
	mov r1, r2
	mov r0, r7
	bl _strnlen
	mov r5, r0
	
	mov r2, r0
	mov r1, r7
	mov r0, r4
	bl _memcpy
	
	add r0, r4, r5
	
	cmp r6, r5
	popeq {r4, r5, r6, r7, r8, pc}
	
	sub r2, r6, r5
	mov r1, #0
	pop {r4, r5, r6, r7, r8, lr}
	b _memset
	
	
	
	
	
_strcasecmp:
	cmp r0, r1
	beq .ret0
	
	str lr, [sp, #-4]!
	sub ip, r0, #1
	
.loop:
	ldrb r2, [ip, #1]!
	mov r3, r2
	
	sub r0, r2, #65
	cmp r0, #25
	addls r3, r2, #32
	
	ldrb r0, [r1], #1
	sub lr, r0, #65
	cmp lr, #25
	addls r0, #32
	
	subs r0, r3, r0
	ldrne pc, [sp], #4
	
	cmp r2, #0
	bne .loop
	
	ldr pc, [sp], #4
	
.ret0:
	mov r0, #0
	bx lr
	
	
	
	
	
	
_strcasestr:
	push {r4, r5, r6, r7, r8, lr}
	mov r5, r0
	
	ldrb r6, [r1]
	cmp r6, #0
	beq .retR5
	
	sub r3, r6, #65
	cmp r3, #25
	addls r6, #32
	andls r6, #0xFF
	
	add r7, r1, #1
	
	mov r0, r7
	bl _strlen
	mov r8, r0
	b .startLoop
	
.loop:
	mov r5, r4
	
.startLoop:
	mov r4, r5
	ldrb r3, [r4], #1
	cmp r3, #0
	beq .retNullptr
	
	sub r2, r3, #65
	cmp r2, #25
	addls r3, #32
	andls r3, #0xFF
	
	cmp r6, r3
	bne .loop
	
	mov r2, r8
	mov r1, r7
	mov r0, r4
	bl _strncasecmp
	
	cmp r0, #0
	bne .loop
	
.retR5:
	mov r0, r5
	pop {r4, r5, r6, r7, r8, pc}
	
.retNullptr:
	mov r0, r3
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
_strcat:
	push {r4, r5, r6, lr}
	mov r4, r0
	mov r5, r1
	
	bl _strlen
	mov r1, r5
	add r0, r4, r0
	bl _strcpy
	
	mov r0, r4
	pop {r4, r5, r6, pc}
	
	
	
	
	
_strchr:
	and r1, #0xFF
	b .startLoop
	
.loop:
	cmp r2, #0
	beq .ret0
	
.startLoop:
	mov r3, r0

	ldrb r2, [r0]
	add r0, #1
	cmp r2, r1
	bne .loop
	
	mov r0, r3
	bx lr
	
.ret0:
	mov r0, r2
	bx lr
	
	
	
	
	
_strchrnul:
	and r1, #0xFF
	
	ldrb r3, [r0]
	cmp r1, r3
	cmpne r3, #0
	bxeq lr
	
.loop:
	ldrb r3, [r0, #1]!
	cmp r3, r1
	cmpne r3, #0
	bne .loop
	
	bx lr
	
	
	
	
	
_strcmp:
	ldrb r3, [r0], #1
	ldrb r2, [r1], #1
	
	cmp r3, #0
	beq .endOfStr
	
	cmp r3, r2
	beq _strcmp
	
	sub r0, r3, r2
	bx lr
	
.endOfStr:
	rsb r0, r2, #0
	bx lr
	
	
	
	
	
_strcpy:
	push {r4, r5, r6, lr}
	mov r5, r0
	mov r4, r1
	
	mov r0, r1
	bl _strlen
	
	add r2, r0, #1
	mov r1, r4
	mov r0, r5
	pop {r4, r5, r6, lr}
	b _memcpy
	
	
	
	
	
_strcspn:
	push {r4, r5, r6, lr}
	mov r6, r1
	
	ldrb r1, [r0]
	cmp r1, #0
	beq .retR1
	
	mov r4, r0
	mov r5, #0
	b .startLoop
	
.loop:
	add r5, #1
	ldrb r1, [r4, #1]!
	cmp r1, #0
	beq .retR5
	
.startLoop:
	mov r0, r6
	bl _strchr
	
	cmp r0, #0
	beq .loop
	
.retR5:
	mov r0, r5
	pop {r4, r5, r6, pc}
	
.retR1:
	mov r0, r1
	pop {r4, r5, r6, pc}
	
	
	
	
	
_strdup:
	push {r4, r5, r6, lr}
	mov r5, r0
	
	bl _strlen
	add r4, r0, #1
	
	mov r0, r4
	bl _malloc
	
	cmp r0, #0
	popeq {r4, r5, r6, pc}
	
	mov r2, r4
	mov r1, r5
	pop {r4, r5, r6, lr}
	b _memcpy
	
	
	
	
	
_strlen:
	ldrb r3, [r0]
	cmp r3, #0
	beq .retR3
	
	mov r3, r0
	
.loop:
	ldrb r2, [r3, #1]!
	cmp r2, #0
	bne .loop
	
	sub r0, r3, r0
	bx lr
	
.retR3:
	mov r0, r3
	bx lr
	
	
	
	
	
_strncasecmp:
	cmp r2, #0
	cmpne r0, r1
	beq .ret0
	
	push {r4, r5, lr}
	sub r4, r0, #1
	b .startLoop
	
.loop:
	cmp lr, #0
	beq .retR3
	
	mvn ip, r4
	add ip, r2
	cmn r0, ip
	beq .retR3
	
.startLoop:
	ldrb lr, [r4, #1]!
	mov ip, lr
	sub r3, lr, #65
	cmp r3, #25
	addls ip, lr, #32

	ldrb r3, [r1], #1
	sub r5, r3, #65
	cmp r5, #25
	addls r3, #32
	
	subs r3, ip, r3
	beq .loop
	
.retR3:
	mov r0, r3
	pop {r4, r5, pc}
	
.ret0:
	mov r0, #0
	bx lr
	
	
	
	
	
_strncat:
	push {r4, r5, r6, r7, r8, lr}
	mov r4, r0
	mov r6, r1
	mov r7, r2
	
	bl _strlen
	add r5, r4, r0
	
	mov r1, r7
	mov r0, r6
	bl _strnlen
	mov r2, r0
	
	mov r3, #0
	strb r3, [r5, r0]
	
	mov r1, r6
	mov r0, r5
	bl _memcpy
	
	mov r0, r4
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
_strncmp:
	cmp r2, #0
	beq .retR2
	
	push {r4, lr}
	
	ldrb lr, [r0]
	ldrb r3, [r1]
	cmp lr, r3
	bne .notEqual
	
	cmp r2, #1
	cmpne lr, #0
	beq .ret0
	
	mov r4, r0
	
.loop:
	ldrb lr, [r4, #1]!
	ldrb r3, [r4, #1]!
	cmp lr, r3
	bne .notEqual
	
	mvn ip, r4
	add ip, r2
	cmn r0, ip
	moveq r3, #1
	movne r3, #0
	cmp lr, #0
	moveq r3, #1
	cmp r3, #0
	beq .loop
	
.ret0:
	mov r0, #0
	pop {r4, pc}
	
.retR2:
	mov r0, r2
	bx lr
	
.notEqual:
	cmp lr, r3
	bcc .retMin1
	
	movhi r0, #1
	movls r0, #0
	pop {r4, pc}
	
.retMin1:
	mvn r0, #0
	pop {r4, pc}
	
	
	
	
	
_strncpy:
	push {r4, r5, r6, r7, r8, lr}
	mov r7, r0
	mov r6, r1
	mov r5, r2
	
	mov r1, r2
	mov r0, r6
	bl _strnlen
	mov r4, r0
	
	cmp r5, r0
	
	subne r2, r5, r0
	movne r1, #0
	addne r0, r7, r0
	blne _memset
	
	mov r2, r4
	mov r1, r6
	mov r0, r7
	pop {r4, r5, r6, r7, r8, lr}
	b _memcpy
	
	
	
	
	
_strndup:
	push {r4, r5, r6, lr}
	mov r5, r0
	
	bl _strnlen
	mov r4, r0
	
	add r0, #1
	bl _malloc
	
	subs r3, r0, #0
	popeq {r4, r5, r6, pc}
	
	mov r2, #0
	strb r2, [r3, r4]
	
	mov r2, r4
	mov r1, r5
	pop {r4, r5, r6, lr}
	b _memcpy
	
	
	
	
	
_strnlen:
	push {r4, lr}
	mov r4, r1
	
	bl _strlen
	
	cmp r0, r4
	movcs r0, r4
	pop {r4, pc}
	
	
	
	
	
_strpbrk:
	push {r4, lr}
	mov r4, r0
	
	bl _strcspn
	
	ldrb r3, [r4, r0]
	cmp r3, #0
	
	addne r0, r4, r0
	moveq r0, #0
	pop {r4, pc}
	
	
	
	
	
_strrchr:
	push {r4, r5, r6, lr}
	mov r4, r0
	and r5, r1, #255
	cmp r5, #0
	movne r6, #0
	bne .startLoop
	
	b .stupidCase
	
.loop:
	add r4, r0, #1
	mov r6, r0
  
.startLoop:
	mov r1, r5
	mov r0, r4
	bl _strchr
	
	cmp r0, #0
	bne .loop
	
	mov r0, r6
	pop {r4, r5, r6, pc}
	
.stupidCase:
	bl _strlen
	add r6, r4, r0
	
	mov r0, r6
	pop {r4, r5, r6, pc}
	
	
	
	
	
_strsep:
	push {r4, r5, r6, lr}
	
	ldr r4, [r0]
	
	cmp r4, #0
	beq .retR4
	
	mov r5, r0
	mov r0, r4
	bl _strcspn
	add r2, r4, r0
	
	ldrb r3, [r4, r0]
	cmp r3, #0
	
	movne r3, #0
	strbne r3, [r4, r0]
	addne r2, r2, #1
	
	strne r2, [r5]
	
	streq r3, [r5]
	
.retR4:
	mov r0, r4
	pop {r4, r5, r6, pc}
	
	
	
	
	
_strspn:
	push {r4, r5, r6, lr}
	mov r6, r1
	
	ldrb r1, [r0]
	cmp r1, #0
	beq .retR1
	mov r4, r0
	
	mov r5, #0
	b .startLoop
  
.loop:
	add r5, #1
	
	ldrb r1, [r4, #1]!
	cmp r1, #0
	beq .retR5
	
.startLoop:
	mov r0, r6
	bl _strchr
	
	cmp r0, #0
	bne .loop
	
.retR5:
	mov r0, r5
	pop {r4, r5, r6, pc}
	
.retR1:
	mov r0, r1
	pop {r4, r5, r6, pc}
	
	
	
	
	
_strstr:
	push {r4, r5, r6, r7, r8, lr}
	mov r4, r0
	mov r6, r1
	
	mov r0, r1
	bl _strlen
	mov r7, r0
	b .startLoop
	
.loop:
	mov r2, r7
	mov r1, r6
	mov r0, r5
	bl _memcmp
	cmp r0, #0
	beq .retR5
.startLoop:
	mov r5, r4
	
	add r4, #1
	ldrb r3, [r5]
	cmp r3, #0
	bne .loop
	
	mov r5, r3
	
.retR5:
	mov r0, r5
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
_swab:
	bic r2, r2, #1
	
	cmp r2, #1
	bxle lr
	
	add r3, r0, r2
	add r1, r2
	
.loop:
	ldrb ip, [r3, #-1] 
	ldrb r2, [r3, #-2]!
	
	strb ip, [r1, #-2]
	strb r2, [r1, #-1]
	
	sub r1, r1, #2
	cmp r0, r3
	bne .loop
	
	bx lr
	