global _rotateLeft	; uint32_t rotateLeft(uint32_t value, uint32_t count) 
global _rotateRight	; uint32_t rotateRight(uint32_t value, uint32_t count) 
global _rotateLeft64	; uint64_t rotateLeft64(uint64_t value, uint32_t count) 
global _rotateRight64	; uint64_t rotateRight64(uint64_t value, uint32_t count) 

segment .text align=16

_rotateLeft:
	mov eax, edi
	mov ecx, esi
	rol eax, cl
	ret
	
	
	
	
	
_rotateRight:
	mov eax, edi
	mov ecx, esi
	ror eax, cl
	ret
	
	
	
	
	
_rotateLeft64:
	mov rax, rdi
	mov ecx, esi
	rol rax, cl
	ret
	
	
	
	
	
_rotateRight64:
	mov rax, rdi
	mov ecx, esi
	ror eax, cl
	ret