#!/bin/bash

nasm -Wall -f elf64 aes_random_stuff.asm
nasm -Wall -f elf64 arith64.asm
nasm -Wall -f elf64 array.asm
nasm -Wall -f elf64 arrayBitManip.asm
nasm -Wall -f elf64 avx512_random_stuff.asm
nasm -Wall -f elf64 aw-wav.asm
nasm -Wall -f elf64 bithacks.asm
nasm -Wall -f elf64 bmiStuff.asm
nasm -Wall -f elf64 bmi2Stuff.asm
nasm -Wall -f elf64 bswap.asm
nasm -Wall -f elf64 calcPi.asm
nasm -Wall -f elf64 convert.asm
nasm -Wall -f elf64 cute_alloc.asm
nasm -Wall -f elf64 detab.asm
nasm -Wall -f elf64 findFirstSet.asm
nasm -Wall -f elf64 floatShit.asm
nasm -Wall -f elf64 gcd_Lcm.asm
nasm -Wall -f elf64 intDiv.asm
nasm -Wall -f elf64 intSqrt.asm
nasm -Wall -f elf64 intToBase.asm
nasm -Wall -f elf64 isLeapYear.asm
nasm -Wall -f elf64 isPowerOf2.asm
nasm -Wall -f elf64 isPowerOf4.asm
nasm -Wall -f elf64 lcmArray.asm
nasm -Wall -f elf64 m32lib.asm
nasm -Wall -f elf64 mostSignificantBitIndex.asm
nasm -Wall -f elf64 mulDiv.asm
nasm -Wall -f elf64 mulStuff.asm
nasm -Wall -f elf64 my_ia32intrin.asm
nasm -Wall -f elf64 my_mm_malloc.asm
nasm -Wall -f elf64 my_prfchwintrin.asm
nasm -Wall -f elf64 my_string.asm
nasm -Wall -f elf64 nextPowOf2.asm
nasm -Wall -f elf64 oppositeSigns.asm
nasm -Wall -f elf64 rand.asm
nasm -Wall -f elf64 rotate.asm
nasm -Wall -f elf64 sumTo.asm

