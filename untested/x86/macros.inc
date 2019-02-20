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
%macro multipush 2-*

	%rep %0	; Repeat number of arguments times
		push %1	; Push next argument
		%rotate 1	; Rotate all arguments to the left
	%endrep
	
%endmacro

; Pop to multiple (from right to left)
%macro multipop 2-*

	%rep %0	; Repeat number of arguments times
		%rotate -1	; Rotate all arguments to the right
		push %1	; pop next argument
	%endrep

%endmacro

%macro zero 1
	xor %1, %1
%endmacro

; Zero multiple things
%macro multizero 2-*

	%rep %0
		zero %1
		%rotate 1
	%endrep

%endmacro

%endif