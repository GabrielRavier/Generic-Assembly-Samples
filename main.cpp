/*  Versions :
    1.0.0 : Initial commit
    1.0.1 : Changed declaration of getbits
    1.1.0 : Implemented tests for new function
    1.2.0 : Implemented tests for new functions
    1.3.0 : Implemented tests for fpow
    1.3.1 : Changed name of ASM_countCharsInLine to ASM_countCharsInInput
    1.3.2 : Changed fpow so that it uses long doubles instead of floats
    1.3.3 : Added memset declaration
    1.3.4 : Removed a buncha spaces
    1.4.0 : Implemented tests for sinxpnx
    1.4.1 : Made sinxpnx tests look better
    1.4.2 : Made some tests with new header
    2.0.0 : Made a big overhaul, made most tests use their own functions
    2.0.1 : Made timing test for memset (My implementation faster than glibc's implementation muhahahahaha)
    2.1.0 : Implemented tests for getProcessorName
    2.1.1 : Cleaned up formatting in testing processor name, and removed some useless things
    2.1.2 : Added "Versions" section
	2.2.0 : Remade RNGs and added tests for qRSqrt */

#include <iostream>
#include <iomanip>
#include <string>
#include <cstdio>
#include <cstring>
#include <random>
#include <cstdlib>
#include <ctime>
#include <cfloat>
#include <climits>
#include <limits>
#include <algorithm>
#include <functional>
#include <chrono>
#include <thread>

using std::cout;
using std::oct;
using std::dec;
using std::cin;
using std::string;
using std::uniform_real_distribution;
using std::random_device;
using std::mt19937;
using std::uniform_int_distribution;
using std::generate;
using std::begin;
using std::end;
using std::ref;
using std::seed_seq;
using std::hash;
using std::thread;
using std::make_unique;

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
    extern float __fastcall ASM_fsquare(float num);
    extern long long int __fastcall ASM_square64(long long int num);
    extern int __fastcall ASM_square(int num);
    extern void *__fastcall ASM_memset(void* buffer, int character, size_t size);
    extern double __cdecl ASM_sinxpnx(double x, int n);
    extern long long ASM_readTSC();
    extern char *ASM_getProcessorName();
    extern float __fastcall ASM_qRSqrt(float number);
    extern void *__fastcall ASM_memcpy(void *destination, const void *source, size_t length);
}

template<class T = std::mt19937, size_t N = T::state_size>
auto SeededRandomEngine() -> typename std::enable_if<!!N, T>::type
{
    void *randMalloced = malloc(1);
    seed_seq seeds
    {
        static_cast<long long>(std::chrono::high_resolution_clock::now().time_since_epoch().count()),
        static_cast<long long>(hash<thread::id>()(std::this_thread::get_id())),
        static_cast<long long>(reinterpret_cast<intptr_t>(&seeds)),
        static_cast<long long>(reinterpret_cast<intptr_t>(randMalloced)),
        static_cast<long long>(time(0))
    };
    T seededEngine(seeds);
    return seededEngine;
}

thread_local mt19937 engine(SeededRandomEngine());

// Distribution goes from 0 to TYPE_MAX by default

uniform_int_distribution<unsigned long long> distrInt64;
uniform_int_distribution<int> distrInt;

int random(int low, int high)
{
    return (low + (distrInt(engine) % (high - low + 1)));
}

long long int random(long long int low, long long int high)
{
    return (low + (distrInt64(engine) % (high - low + 1)));
}

double random(double low, double high)
{
    uniform_real_distribution<double> distDbl(low, high);
    return distDbl(engine);
}

long double random(long double low, long double high)
{
    uniform_real_distribution<long double> distLDbl(low, high);
    return distLDbl(engine);
}

float random(float low, float high)
{
    uniform_real_distribution<float> distFlt(low, high);
    return distFlt(engine);
}

void testSinxpnx()
{
    double sinxpnx_x = random(-2000000.0, 2000000.0);
    int sinxpnx_n = random(-2000000, 2000000);
    cout << "sin(" << sinxpnx_x << ") + " << sinxpnx_n << " * " << sinxpnx_x << " = "
         << ASM_sinxpnx(sinxpnx_x, sinxpnx_n) << '\n';
}

void testFpow()
{
    long double fTestNum = random(-2000000.0l, 2000000.0l);
    int testExponent = random(-10, 10);
    cout << fTestNum << " ^ " << testExponent << " = " << ASM_fpow(fTestNum, testExponent) << '\n';
}

void testSquares()
{
    int testInt = random(-2000000, 2000000);
    long long int testInt64 = random(-20000000000LL, 20000000000LL);
    float testFloat = random(0.0f, 200000.0f);
    long double testLDbl = random(0.0l, 3.40282347e+380l);
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
    char startBit = random(1, 31);
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
    auto inputCStr = make_unique<char[]>(input.size() + 1);
    strcpy(inputCStr.get(), input.c_str());
    cout << "input before reverseString : " << input << '\n';
    cout << "after reverseString : " << ASM_reverseString(inputCStr.get()) << '\n';
}

void testStrnset()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    auto inputCStr = make_unique<char []>(input.size() + 1);
    strcpy(inputCStr.get(), input.c_str());
    cout << "input before strnset : " << input << '\n';
    cout << "After strnset : " << ASM_strnset(inputCStr.get(), 'B', 10) << '\n';
}

void testStrset()
{
    cout << "Enter a string : \n";
    string input;
    cin >> input;
    auto inputCStr = make_unique<char []>(input.size() + 1);
    strcpy(inputCStr.get(), input.c_str());
    cout << "input before strset : " << input << '\n';
    cout << "After strset : " << ASM_strset(inputCStr.get(), 'a') << '\n';
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
    cout << "Processor name : " << ASM_getProcessorName() << '\n';
}

void testqRSqrt()
{
    float testFlt = random(1.1f, 100000.0f);
    cout << "1/sqrt("
         << testFlt
         << ") = "
         << ASM_qRSqrt(testFlt)
         << '\n';
}

struct
{
    char name[40];
    int age;
} person, person_copy;

void testMemcpy()
{
    static const char myname[] = "Gabriel Ravier";

    // Copy a string with memcpy
    ASM_memcpy(person.name, myname, sizeof(myname));
    person.age = 46;

    // using memcpy to copy structure:
    ASM_memcpy(&person_copy, &person, sizeof(person) );

    printf("person_copy: %s, %d \n", person_copy.name, person_copy.age);
}

int main(int argc, char *argv[])
{
    cout << "Testing memcpy\n";
    testMemcpy();
    cout << "Testing Q_rsqrt\n";
    testqRSqrt();
    cout << "Testing getProcessorName\n";
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
