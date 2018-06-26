#include <cstdlib>

#ifdef __cplusplus
extern "C"
{
#endif
    extern void __cdecl ASM_copyInputToOutput();
    extern void __cdecl ASM_countCharsInInput();
    extern void __cdecl ASM_countLinesWordsCharsInInput();
    extern int __fastcall ASM_pow(int base, unsigned int exponent);
    extern long double __fastcall ASM_fpow(long double base, int exponent);
    extern char *__fastcall ASM_strnset(char *string, char character, int count);
    char *__fastcall ASM_strset(char *string, char character);
    extern char *__fastcall ASM_strrchr(const char *string, char character);
    extern int __fastcall ASM_strlen(const char *string);
    extern char *__fastcall ASM_memchr(const char *buffer, char character, unsigned count);
    extern unsigned int __fastcall ASM_getbits(unsigned int num, unsigned char position, unsigned int numBits);
    extern int __fastcall ASM_bitcount(unsigned int num);
    extern char *__fastcall ASM_reverseString(char *string);
    extern int __fastcall ASM_atoi(const char *string);
    extern unsigned int __fastcall ASM_floorLog2(unsigned int numToFloor);
    extern long double __stdcall ASM_ldsquare(long double num);
    extern float __fastcall ASM_fsquare(float num);
    extern long long int __fastcall ASM_square64(long long int num);
    extern int __fastcall ASM_square(int num);
    extern void *__fastcall ASM_memset(void* buffer, int character, size_t size);
    extern double __cdecl ASM_sinxpnx(double x, int n);
    extern long long ASM_readTSC();
    extern float __fastcall ASM_qRSqrt(float number);
    extern void *__fastcall ASM_memcpy(void *destination, const void *source, size_t length);
    extern int __fastcall ASM_memcmp(const void *str1, const void *str2, size_t maxLen);
    extern char *__fastcall ASM_strcpy(char *destination, const char* source);
    extern int __fastcall ASM_strncmp(const char *s1, const char *s2, size_t maxLen);
    extern char *__fastcall ASM_strncpy(char *destination, const char *source, size_t maxLen);
    extern char *__fastcall ASM_strncat(char *destination, const char *source, size_t maxLen);
    extern size_t __fastcall ASM_strnlen(const char* string, size_t maxLength);
    extern void __fastcall ASM_bcopy(const void *source, void *destination, size_t length);
    extern void *__fastcall ASM_memmove(void *destination, const void *source, size_t length);
    extern int getInstructionSet();
#ifdef __cplusplus
}   // extern "C"
#endif

enum instructionSets
{
    only386 = 0,
    MMXSupported = 1,
    conditionalMovAndFCOMISupported = 2,
    SSESupported = 3,
    SSE2Supported = 4,
    SSE3Supported = 5,
    SSSE3Supported = 6,
    SSE41Supported = 8,
    popcntSupported = 9,
    SSE42Supported = 10,
    AVXSupported = 11,
    PCLMULAndAESSupported = 12,
    AVX2Supported = 13,
    FMA3_F16C_BMI1_BMI2_LZCNTSupported = 14,
    AVX512FSupported = 15,
    AVX512BW_DQ_VLSupported = 16,
};
