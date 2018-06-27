#include <cstdlib>

#ifdef __cplusplus
extern "C"
{
#endif
    void __cdecl ASM_copyInputToOutput();
    void __cdecl ASM_countCharsInInput();
    void __cdecl ASM_countLinesWordsCharsInInput();
    int __fastcall ASM_pow(int base, unsigned int exponent);
    long double __fastcall ASM_fpow(long double base, int exponent);
    char *__fastcall ASM_strnset(char *string, char character, int count);
    char *__fastcall ASM_strset(char *string, char character);
    char *__fastcall ASM_strrchr(const char *string, char character);
    int __fastcall ASM_strlen(const char *string);
    char *__fastcall ASM_memchr(const char *buffer, char character, unsigned count);
    unsigned int __fastcall ASM_getbits(unsigned int num, unsigned char position, unsigned int numBits);
    int __fastcall ASM_bitcount(unsigned int num);
    char *__fastcall ASM_reverseString(char *string);
    int __fastcall ASM_atoi(const char *string);
    unsigned int __fastcall ASM_floorLog2(unsigned int numToFloor);
    long double __stdcall ASM_ldsquare(long double num);
    float __fastcall ASM_fsquare(float num);
    long long int __fastcall ASM_square64(long long int num);
    int __fastcall ASM_square(int num);
    void *__fastcall ASM_memset(void* buffer, int character, size_t size);
    double __cdecl ASM_sinxpnx(double x, int n);
    long long ASM_readTSC();
    float __fastcall ASM_qRSqrt(float number);
    void *__fastcall ASM_memcpy(void *destination, const void *source, size_t length);
    int __fastcall ASM_memcmp(const void *str1, const void *str2, size_t maxLen);
    char *__fastcall ASM_strcpy(char *destination, const char* source);
    int __fastcall ASM_strncmp(const char *s1, const char *s2, size_t maxLen);
    char *__fastcall ASM_strncpy(char *destination, const char *source, size_t maxLen);
    char *__fastcall ASM_strncat(char *destination, const char *source, size_t maxLen);
    size_t __fastcall ASM_strnlen(const char* string, size_t maxLength);
    void __fastcall ASM_bcopy(const void *source, void *destination, size_t length);
    void *__fastcall ASM_memmove(void *destination, const void *source, size_t length);
    char *__fastcall ASM_strchr(const char *s, int c);
    void __fastcall ASM_bzero(void* string, size_t size);
    int __fastcall ASM_strcmp(const char* a, const char* b);
    char *__fastcall ASM_strcat(char* dest, const char* src);
    int __fastcall ASM_isSuffix(const char *string, const char *suffix);
    unsigned long long __fastcall ASM_getFibonacci(unsigned int num);
    int getInstructionSet();
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
