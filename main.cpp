#include <iostream>
#include <iomanip>
#include <string>
#include <cstring>
#include <random>
#include <cstdlib>
#include <ctime>
#include <cfloat>
#include <climits>
#include <limits>
#include <x86intrin.h>
#include "Timer.h"

// I somehow end up without those definitions after including climits
#define LONG_LONG_MAX	9223372036854775807LL
#define LONG_LONG_MIN	(-LONG_LONG_MAX-1)

using std::cout;
using std::oct;
using std::dec;
using std::cin;
using std::string;
using std::uniform_real_distribution;
using std::random_device;
using std::mt19937_64;
using std::uniform_int_distribution;

extern "C"
{
    extern void __cdecl ASM_copyInputToOutput();
    extern void __cdecl ASM_countCharsInInput();
    extern void __cdecl ASM_countLinesWordsCharsInInput();
    extern int __fastcall ASM_pow(int base, unsigned int exponent);
    extern long double __fastcall ASM_fpow(long double base, int exponent);
    extern char *__fastcall ASM_strset(char *string, char val);
    extern char *__fastcall ASM_strnset(char *string, char val, int count);
    extern char *__fastcall ASM_strrchr(const char *string, char val);
    extern int __fastcall ASM_strlen(const char *string);
    extern char *__fastcall ASM_memchr(const char *buffer, char character, unsigned count);
    extern unsigned int __fastcall ASM_getbits(unsigned int num, unsigned char position, unsigned int numBits);
    extern int __fastcall ASM_bitcount(unsigned int num);
    extern char *__fastcall ASM_reverseString(char *string);
    extern long long __fastcall ASM_atoi(const char *string);
    extern int __fastcall ASM_floorLog2(int num);
    extern long double __stdcall ASM_ldsquare(long double num);
    extern float __stdcall ASM_fsquare(float num);
    extern long long int __fastcall ASM_square64(long long int num);
    extern int __fastcall ASM_square(int num);
    extern void *__fastcall ASM_memset(void* buffer, int character, size_t size);
    extern double __cdecl ASM_sinxpnx(double x, int n);
    extern long long ASM_readTSC();
    extern char *__fastcall ASM_getProcessorName();
}

random_device randomDevice;     // Get a random seed from the OS entropy device, or whatever
mt19937_64 engine(randomDevice()); // Use the 64-bit Mersenne Twister 19937 generator
                      // and seed it with entropy.

// Define the distribution, by default it goes from 0 to MAX(unsigned long long)
// or what have you.
uniform_int_distribution<unsigned long long> distrInt64;
uniform_int_distribution<int> distrInt;


int random(int low, int high)
{
    return (low + (distrInt(engine) % (int)(high - low + 1)));
}

long long int random(long long int low, long long int high)
{
    return (low + (distrInt64(engine) % (int)(high - low + 1)));
}

void testSinxpnx()
{
    double sinxpnx_x = random(-2000000, 2000000);
    int sinxpnx_n = random(-2000000, 2000000);
    cout << "sin(" << sinxpnx_x << ") + " << sinxpnx_n << " * " << sinxpnx_x << " = "
         << ASM_sinxpnx(sinxpnx_x, sinxpnx_n) << '\n';
}

void testFpow()
{
    long double fTestNum = random(-2000000, 2000000);
    int testExponent = random(-10, 10);
    cout << fTestNum << " ^ " << testExponent << " = " << ASM_fpow(fTestNum, testExponent) << '\n';
}

void testSquares()
{
    int testInt = random(-2000000, 2000000);
    long long int testInt64 = random(-2000000, 2000000);
    float testFloat = random(-2000000, 2000000);
    long double testLDbl = random(-2000000, 2000000);
    cout << "Square of " << testInt << " : " << ASM_square(testInt) << '\n';
    cout << "Square of " << testInt64 << " : " << ASM_square64(testInt64) << '\n';
    cout << "Square of " << testFloat << " : " << ASM_fsquare(testFloat) << '\n';
    cout << "Square of " << testLDbl << " : " << ASM_ldsquare(testLDbl) << '\n';
}

void testFloorLog2()
{
    int input = ASM_pow(2, random(0, 30));
    cout << input << " is the " << ASM_floorLog2(input) << "th power of 2\n";
}

void testGetbits()
{
    unsigned int input = random(0, INT_MAX);
    char startBit = random(1, 32);
    char numBits = random(1, 32 - startBit);
    cout << "First " << (int)numBits << " bits from " << (int)startBit << "th bit in " << (int)input << " are equal to : "
         << ASM_getbits(input, startBit, numBits) << '\n';
}

void testBitcount()
{
    unsigned int searchedNum = random(1, INT_MAX);
    cout << "There are " << ASM_bitcount(searchedNum) << " 1 bits in " << searchedNum << '\n';
}

void testMemchr()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    const char *inputCStr = input.c_str();
    cout << "First occurence of g in \"" << input << "\" at the "
         << ASM_memchr(inputCStr, 'g', ASM_strlen(inputCStr)) - inputCStr + 1 /* + 1 because we got the number of bytes from the start
                                                                          of myString not including the first one */
         << "th position\n";
}

void testStrlen()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    cout << "Length of myString : " << ASM_strlen(input.c_str()) << " bytes\n";
}

void testStrrchr()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    cout << "Last occurence of i in \"" << input.c_str() << "\" at the " << ASM_strrchr(input.c_str(), 'i') - input.c_str()
         << "th position\n";
}

void testReverseString()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    char *inputCStr = (char *)malloc(input.size());
    strcpy(inputCStr, input.c_str());
    cout << "input before reverseString : " << inputCStr << '\n';
    cout << "after reverseString : " << ASM_reverseString(inputCStr) << '\n';
    free(inputCStr);
}

void testStrnset()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    char *inputCStr = (char *)malloc(input.size());
    strcpy(inputCStr, input.c_str());
    cout << "input before strnset : " << input << '\n';
    cout << "After strnset : " << ASM_strnset(inputCStr, 'B', 10) << '\n';
    free(inputCStr);
}

void testStrset()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    char *inputCStr = (char *)malloc(input.size());
    strcpy(inputCStr, input.c_str());
    cout << "input before strset : " << input << '\n';
    cout << "After strset : " << ASM_strset(inputCStr, 'a') << '\n';
    free(inputCStr);
}

void testAtoi()
{
    cout << "Enter a number : \n";
    string number = "";
    cin >> number;
    cout << "Converted to an integer : " << ASM_atoi(number.c_str()) << '\n';
}

void testPow()
{
    for (int i = 0; i < 10; i++)
        cout << i << " ^ " << i << " = " << ASM_pow(i, i) << '\n';
}

void testCountLinesWordsCharsInInput()
{
    cout << "Counting characters, lines and words until next backslash\n";
    ASM_countLinesWordsCharsInInput();
}

void testCountCharsInInput()
{
    cout << "Counting characters until next backslash\n";
    ASM_countCharsInInput();
}

void testCopyInputToOutput()
{
    cout << "Copying input to output until next backslash\n";
    ASM_copyInputToOutput();
}

void testGetProcessorName()
{
    cout << "Processor name : " << ASM_getProcessorName();
}

int main(int argc, char *argv[])
{
    engine.seed(time(0));
    srand(time(0));
    cout << "Testing getProcessorName";
    testGetProcessorName();
    cout << "Testing sinxpnx\n";
    testSinxpnx();
    cout << "Testing fpow\n";
    testFpow();
    cout << "Testing squares\n";
    testSquares();
    cout << "Testing floorLog2\n";
    testFloorLog2();
    cout << "Testing getbits\n";
    testGetbits();
    cout << "Testing bitcount\n";
    testBitcount();
    cout << "Testing memchr\n";
    testMemchr();
    cout << "Testing strlen\n";
    testStrlen();
    cout << "Testing strrchr\n";
    testStrrchr();
    cout << "Testing reverseString\n";
    testReverseString();
    cout << "Testing strnset\n";
    testStrnset();
    cout << "Testing strset\n";
    testStrset();
    cout << "Testing atoi\n";
    testAtoi();
    cout << "Testing pow\n";
    testPow();
    cout << "Testing countLinesWordsCharsInInput\n";
    testCountLinesWordsCharsInInput();
    cout << "Testing countCharsInInput\n";
    testCountCharsInInput();
    cout << "Testing copyInputToOutput\n";
    testCopyInputToOutput();
    return 0;
}
