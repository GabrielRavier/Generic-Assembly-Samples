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

void testStrcpy()
{
    char *src = "Take the test.";
    char dst[strlen(src) + 1]; // +1 to accomodate for the null terminator
    strcpy(dst, src);
    dst[0] = 'M'; // OK
    printf("src = %s\ndst = %s\n", src, dst);
}

void testMemcmp()
{
    char str[8];

    ASM_strcpy(str, "3141");

    cout << "memcmp(str, str+2, 0) = " << ASM_memcmp(str, str+2, 0) << " (should be 0)\n";
    cout << "memcmp(str+1, str+3, 0) = " << ASM_memcmp(str+1, str+3, 0) << " (should be 0)\n";
    cout << "memcmp(str+1, str+3, 1) = " << ASM_memcmp(str+1, str+3, 1) << " (should be 0)\n";
    cout << "memcmp(str, str+2, 1) = " << ASM_memcmp(str, str+2, 1) << " (should be less than 0)\n";
    cout << "memcmp(str+2, str, 1) = " << ASM_memcmp(str+2, str, 1) << " (should be more than 0)\n";
    cout << "memcmp(\"abcd\", \"efgh\", 4) = " << ASM_memcmp ("abcd", "efgh", 4) << " (should be less than 0)\n";
    cout << "memcmp(\"abcd\", \"abcd\", 4) = " << ASM_memcmp ("abcd", "abcd", 4) << " (should be 0)\n";
    cout << "memcmp(\"efgh\", \"abcd\", 4) = " << ASM_memcmp ("efgh", "abcd", 4) << " (should be more than 0)\n";
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
    ASM_strcpy(inputCStr.get(), input.c_str());
    cout << "Before reverseString : " << input << '\n';
    cout << "after reverseString : " << ASM_reverseString(inputCStr.get()) << '\n';
}

void testStrnset()
{
    string input = "IMPORTANT INFORMATION";
    auto inputCStr = make_unique<char []>(input.size() + 1);
    ASM_strcpy(inputCStr.get(), input.c_str());
    cout << "Before strnset : " << input << '\n';
    cout << "After strnset : " << ASM_strnset(inputCStr.get(), 'l', 10) << '\n';
}

void testStrset()
{
    string input = "VERY IMPORTANT STUFF";
    auto inputCStr = make_unique<char []>(input.size() + 1);
    ASM_strcpy(inputCStr.get(), input.c_str());
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
    char name[512];
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

void subtestStrncmp(const char *str1, const char *str2, int size)
{
    int retstrncmp = ASM_strncmp(str1, str2, size);
    if (!retstrncmp)
        cout << "First " << size << " chars of [" << str1 << "] equal [" << str2 << "]\n";
    else if (retstrncmp < 0)
        cout << "First " << size << " chars of [" << str1 << "] are smaller than [" << str2 << "]\n";
    else if (retstrncmp > 0)
        cout << "First " << size << " chars of [" << str1 << "] are bigger than [" << str2 << "]\n";
}

void testStrncmp()
{
    const char *testStr = "Hello World!";
    subtestStrncmp(testStr, "Hello!", 5);
    subtestStrncmp(testStr, "Hello", 10);
    subtestStrncmp(testStr, "Hello there", 10);
    subtestStrncmp("Hello, everybody!" + 12, "Hello, somebody!" + 11, 5);
}

void testStrncpy()
{
    char str1[]= "To be or not to be";
    char str2[40];
    char str3[40];

    // Copy to sized buffer (overflow safe)
    ASM_strncpy(str2, str1, sizeof(str2));

    // Copy only 5 characters
    ASM_strncpy(str3, str2, 5);
    str3[5] = '\0';   // Manually add NULL terminator

    puts(str1);
    puts(str2);
    puts(str3);
}

void testStrncat()
{
    char str1[20];
    char str2[20];
    ASM_strcpy(str1, "To be ");
    ASM_strcpy(str2, "or not to be");
    ASM_strncat(str1, str2, 6);
    puts(str1);
}

void testMemmove()
{
    char str[] = "memmove can be very useful......";
    ASM_memmove(str+20,str+15,11);
    puts(str);
}

void testBcopy()
{
    char buffer[80];
    ASM_bcopy("Hello ", buffer, 6);
    ASM_bcopy("world",  &buffer[6], 6);
    printf("%s\n", buffer);
}

void testMemset()
{
    char str[] = "totally not almost (haha lol dat's not funny at all WAHAHAHAHAHAHAHAHAHA) every programmer should know memset!";
    ASM_memset(str, '-', 74); // Add '-'s until the start of "programmer"
    ASM_memset(str + 73, ' ', 1); // Append a space before "programmer"
    puts(str);
}

void testStrchr()
{
    char str[] = "\n\nThis is a very long sample string that I made for fun.\n"
                 "NOTE : This note has been added for the exclusive purpose of making this string longer\n\n";
    char *pch;
    printf("Looking for the 's' character in \"%s\"...\n",str);
    pch = ASM_strchr(str,'s');
    while (pch != NULL)
    {
        printf("found at %d\n",pch-str+1);
        pch = ASM_strchr(pch+1,'s');
    }
}

void testStrcmp()
{
    char str1[20];
    char str2[20];
    int result;

    //Assigning the value to the string str1
    ASM_strcpy(str1, "hello");

    //Assigning the value to the string str2
    ASM_strcpy(str2, "hEllo");

    result = ASM_strcmp(str1, str2);

    if(result > 0)
        printf("ASCII value of first unmatched character of str1 is greater than str2");
    else if(result < 0)
        printf("ASCII value of first unmatched character of str1 is less than str2");
    else
        printf("Both the strings str1 and str2 are equal");
    cout << "\nShould have outputted : \"ASCII value of first unmatched character of str1 is greater than str2\"\n";
}

void testStrcat()
{
    char str[80];
    ASM_strcpy(str,"These ");
    ASM_strcat(str,"strings ");
    ASM_strcat(str,"are ");
    ASM_strcat(str,"concatenated.");
    puts(str);
}

void testIsSuffix()
{
    const char *findIn = "something blargo";
    const char *shouldntBeFound = "WAIT THIS IS BIGGER THAN something blargo";
    const char *shouldntBeFound2 = "balrog";
    const char *shouldBeFound = "blargo";
    const char *shouldBeFound2 = "something blargo";
    if (ASM_isSuffix(findIn, shouldntBeFound))
        cout << "FAIL : \"" << shouldntBeFound << "\" is NOT a suffix of \"" << findIn << "\".\n";
    else
        cout << "Test 1 succeeded\n";
    if (ASM_isSuffix(findIn, shouldntBeFound2))
        cout << "FAIL : \"" << shouldntBeFound2 << "\" is NOT a suffix of \"" << findIn << "\".\n";
    else
        cout << "Test 2 succeeded\n";
    if (!ASM_isSuffix(findIn, shouldBeFound))
        cout << "FAIL : \"" << shouldBeFound << "\" IS a suffix of \"" << findIn << "\".\n";
    else
        cout << "Test 3 succeeded\n";
    if (!ASM_isSuffix(findIn, shouldBeFound2))
        cout << "FAIL : \"" << shouldBeFound2 << "\" IS a suffix of \"" << findIn << "\".\n";
    else
        cout << "Test 4 succeeded\n";
}

void testGetFibonnaci()
{
    int num = random(1, 93); // 94th number of Fibonacci too big for unsigned long long
    cout << num << "th number of Fibonacci = " << ASM_getFibonacci(num) << '\n';
}

int main(int argc, char *argv[])
{
    system("pause");
    cout << "\nTesting getFibonnaci\n";
    testGetFibonnaci();
    cout << "\nTesting isSuffix\n";
    testIsSuffix();
    cout << "\nTesting strcat\n";
    testStrcat();
    cout << "\nTesting strcmp\n";
    testStrcmp();
    cout << "\nTesting strchr\n";
    testStrchr();
    cout << "\nTesting memset\n";
    testMemset();
    cout << "\nTesting bcopy\n";
    testBcopy();
    cout << "\nTesting memmove\n";
    testMemmove();
    cout << "\nTesting strncat\n";
    testStrncat();
    cout << "\nTesting strncpy\n";
    testStrncpy();
    cout << "\nTesting strncmp\n";
    testStrncmp();
    cout << "\nTesting strcpy\n";
    testStrcpy();
    cout << "\nTesting memcmp\n";
    testMemcmp();
    cout << "\nTesting memcpy\n";
    testMemcpy();
    cout << "\nTesting Q_rsqrt\n";
    testqRSqrt();
    cout << "\nTesting sinxpnx\n";
    testSinxpnx();
    cout << "\nTesting fpow\n";
    testFpow();
    cout << "\nTesting squares\n";
    testSquares();
    cout << "\nTesting floorLog2\n";
    testFloorLog2();
    cout << "\nTesting getbits\n";
    testGetbits();
    cout << "\nTesting bitcount\n";
    testBitcount();
    cout << "\nTesting memchr\n";
    testMemchr();
    cout << "\nTesting strlen\n";
    testStrlen();
    cout << "\nTesting strrchr\n";
    testStrrchr();
    cout << "\nTesting reverseString\n";
    testReverseString();
    cout << "\nTesting strnset\n";
    testStrnset();
    cout << "\nTesting strset\n";
    testStrset();
    cout << "\nTesting atoi\n";
    testAtoi();
    cout << "\nTesting pow\n";
    testPow();
    cout << "\nTesting countLinesWordsCharsInInput\n";
    testCountLinesWordsCharsInInput();
    cout << "\nTesting countCharsInInput\n";
    testCountCharsInInput();
    cout << "\nTesting copyInputToOutput\n";
    testCopyInputToOutput();
    return 0;
}
