global _leftRotate
global _rightRotate 

segment .text align=16

_leftRotate:
	mov eax, [esp + 4]
	mov ecx, [esp + 8]
	
	rol eax, cl
	ret
	
	
	
	
	
	align 16
_rightRotate:
	mov eax, [esp + 4]
	mov ecx, [esp + 8]
	
	ror eax, cl
	ret