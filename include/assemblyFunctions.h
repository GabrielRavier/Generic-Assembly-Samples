#include <cstdlib>

#define restrict __restrict

#ifdef __cplusplus
extern "C"
{
#endif
int __fastcall ASM_pow(int base, unsigned int exponent);
long double __fastcall ASM_fpow(long double base, int exponent);
char *__fastcall ASM_strrchr(const char *string, char character);
size_t __fastcall ASM_strlen(const char *string);
char *__fastcall ASM_memchr(const char *buffer, char character, unsigned count);
unsigned int __fastcall ASM_getbits(unsigned int num, unsigned char position, unsigned int numBits);
int __fastcall ASM_bitcount(unsigned int num);
char *__fastcall ASM_reverseString(char *string);
int __fastcall ASM_atoi(const char *string);
unsigned int __fastcall ASM_floorLog2(unsigned int numToFloor);
void *__fastcall ASM_memset(void* buffer, int character, size_t size);
void *__fastcall ASM_memcpy(void *restrict destination, const void *restrict source, size_t length);
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
unsigned long long __fastcall ASM_getGreatestCommonDivider(unsigned long long num1, unsigned long long num2);
bool __fastcall ASM_isAlphabetic(const char c);
bool __fastcall ASM_isPossibleIdentifier(const char c);
void __fastcall ASM_bubbleSort(int *array, const size_t arraySize);
void __fastcall ASM_combSort(int *array, const size_t arraySize);
void __fastcall ASM_cocktailSort(int *array, const size_t arraySize);
void __fastcall ASM_gnomeSort(int *array, const size_t arraySize);
void __fastcall ASM_oddEvenSort(int *array, const size_t arraySize);
long long ASM_readTSC();
int getInstructionSet();
#ifdef __cplusplus
}   // extern "C"
#endif

enum instructionSets // Return values for the getInstructionSet function
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
