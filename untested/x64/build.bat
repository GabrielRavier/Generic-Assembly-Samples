echo off
nasm -f elf64 arith64.asm
rem arith64.asm is not updated
nasm -f elf64 array.asm
nasm -f elf64 arrayBitManip.asm
nasm -f elf64 aw-ima.asm
nasm -f elf64 aw-wav.asm
nasm -f elf64 bithacks.asm
nasm -f elf64 bmiStuff.asm
nasm -f elf64 bmi2Stuff.asm
nasm -f elf64 bswap.asm
nasm -f elf64 convert.asm
nasm -f elf64 debugBreak.asm
nasm -f elf64 detab.asm
nasm -f elf64 findFirstSet.asm
nasm -f elf64 floatShit.asm
rem floatShit.asm is not updated
nasm -f elf64 gcd_Lcm.asm
nasm -f elf64 intDiv.asm
nasm -f elf64 intSqrt.asm
nasm -f elf64 intToBase.asm
nasm -f elf64 isCpuidAvailable.asm
nasm -f elf64 isLeapYear.asm
nasm -f elf64 isPowerOf2.asm
nasm -f elf64 isPowerOf4.asm
nasm -f elf64 lcmArray.asm
nasm -f elf64 mostSignificantBitIndex.asm
nasm -f elf64 mulDiv.asm
nasm -f elf64 mulStuff.asm
nasm -f elf64 nextPowOf2.asm
nasm -f elf64 oppositeSigns.asm
nasm -f elf64 rand.asm
nasm -f elf64 rotate.asm
nasm -f elf64 string.asm
pause
