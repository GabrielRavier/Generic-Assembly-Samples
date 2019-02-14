%ifndef MACROS_INC
%define MACROS_INC

; bool value definitions
%define false 0
%define true 1
%define FALSE false
%define TRUE true

%define nullptr 0
%define NULL nullptr

; Push multiple values (from left to right)
%macro multipush 1-*

	%rep %0	; Repeat number of arguments times
		push %1	; Push next argument
		%rotate 1	; Rotate all arguments to the left
	%endrep
	
%endmacro

; Pop to multiple registers (from right to left)
%macro multipop 1-*

	%rep %0	; Repeat number of arguments times
		%rotate -1	; Rotate all arguments to the right
		push %1	; pop next argument
	%endrep

%endmacro
	
%endif