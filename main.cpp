#include <iostream>
#include <iomanip>
#include <string>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <cfloat>
#include <climits>
#include <limits>
#include "assemblyFunctions.h"
#include "myRand.h"

using std::cout;
using std::oct;
using std::dec;
using std::cin;
using std::string;
using std::uniform_real_distribution;
using std::random_device;
using std::mt19937;
using std::uniform_int_distribution;
using std::begin;
using std::end;
using std::ref;
using std::seed_seq;
using std::hash;
using std::thread;
using std::make_unique;

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
    string input = "string input";
    const char *inputCStr = input.c_str();
    cout << "First occurence of g in \"" << input << "\" at the "
         << ASM_memchr(inputCStr, 'g', ASM_strlen(inputCStr)) - inputCStr + 1 /* + 1 because we got the number of bytes from the start
                                                                          of myString not including the first one */
         << "th position\n";
}

void testStrlen()
{
    string input = "test string";
    cout << "Length of myString : " << ASM_strlen(input.c_str()) << " bytes\n";
}

void testStrrchr()
{
    string input = "lol random string";
    cout << "Last occurence of i in \"" << input.c_str() << "\" at the " << ASM_strrchr(input.c_str(), 'i') - input.c_str()
         << "th position\n";
}

void testReverseString()
{
    string input = "stressed";
    auto inputCStr = make_unique<char[]>(input.size() + 1);
    strcpy(inputCStr.get(), input.c_str());
    cout << "Before reverseString : " << input << '\n';
    cout << "after reverseString : " << ASM_reverseString(inputCStr.get()) << '\n';
}

void testStrnset()
{
    string input = "IMPORTANT INFORMATION";
    auto inputCStr = make_unique<char []>(input.size() + 1);
    strcpy(inputCStr.get(), input.c_str());
    cout << "Before strnset : " << input << '\n';
    cout << "After strnset : " << ASM_strnset(inputCStr.get(), 'l', 10) << '\n';
}

void testStrset()
{
    string input = "VERY IMPORTANT STUFF";
    auto inputCStr = make_unique<char []>(input.size() + 1);
    strcpy(inputCStr.get(), input.c_str());
    cout << "Before strset : " << input << '\n';
    cout << "After strset : " << ASM_strset(inputCStr.get(), 'a') << '\n';
}

void testAtoi()
{
    string number = "2445";
    cout << "Before conversion : " << number << '\n';
    cout << "After conversion : " << ASM_atoi(number.c_str()) << '\n';
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

struct Person
{
    char name[40];
    int age;
};

Person person = {0}, personCopy = {0};

void testMemcpy()
{
    static const char myname[] = "Gabriel Ravier";

    // Copy string with memcpy
    ASM_memcpy(person.name, myname, sizeof(myname));
    person.age = 46;

    // Copy struct with memcpy
    ASM_memcpy(&personCopy, &person, sizeof(person));

    cout << "personCopy : " << personCopy.name << ", " << personCopy.age << " \n";
}

void testStrtol()
{
    // parsing with error handling
    const char *p = "10 200000000000000000000000000000 30 -40 junk";
    printf("Parsing '%s':\n", p);
    char *end;
    for (long i = strtol(p, &end, 10);
         p != end;
         i = strtol(p, &end, 10))
    {
        printf("'%.*s' -> ", (int)(end-p), p);
        p = end;
        if (errno == ERANGE){
            printf("range error, got ");
            errno = 0;
        }
        printf("%ld\n", i);
    }

    // parsing without error handling
    printf("\"1010\" in binary  --> %ld\n", strtol("1010",NULL,2));
    printf("\"12\" in octal     --> %ld\n", strtol("12",NULL,8));
    printf("\"A\"  in hex       --> %ld\n", strtol("A",NULL,16));
    printf("\"junk\" in base-36 --> %ld\n", strtol("junk",NULL,36));
    printf("\"012\" in auto-detected base  --> %ld\n", strtol("012",NULL,0));
    printf("\"0xA\" in auto-detected base  --> %ld\n", strtol("0xA",NULL,0));
    printf("\"junk\" in auto-detected base -->  %ld\n", strtol("junk",NULL,0));
}

int main(int argc, char *argv[])
{
    cout << "Testing strtol\n";
    testStrtol();
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
