#include "tests.h"
#include "assemblyFunctions.h"
#include "myRand.h"

#include <iostream>
#include <cstring>
#include <cstdio>
#include <string>
#include <memory>
#include <strings.h>

using std::cout;
using std::string;
using std::make_unique;

void testIsLeapYear()
{
    uint32_t year = random(0, 3000);

    if (ASM_isLeapYear(year))
        cout << year << " is";
    else
        cout << year << " is not";
    cout << " a leap year\n";
}

void testGnomeSort()
{
    static const int arraySize = 10;
    int testArray[arraySize];
    for (int i = 0; i < arraySize; i++)
        testArray[i] = random(1, 10);
    cout << "Array before sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    ASM_gnomeSort(testArray, arraySize);
    cout << "\nArray after sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    cout << '\n';
}

void testCocktailSort()
{
    static const int arraySize = 10;
    int testArray[arraySize];
    for (int i = 0; i < arraySize; i++)
        testArray[i] = random(1, 10);
    cout << "Array before sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    ASM_cocktailSort(testArray, arraySize);
    cout << "\nArray after sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    cout << '\n';
}

void testStrcpy()
{
    char *source = "Take the test.";
    char destination[ASM_strlen(source) + 1]; // +1 to accomodate for the null terminator
    ASM_strcpy(destination, source);
    destination[0] = 'M'; // OK
    printf("source = %s\ndestination = %s\n", source, destination);
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

void testFpow()
{
    long double fTestNum = random(-2000000.0l, 2000000.0l);
    int testExponent = random(-10, 10);
    cout << fTestNum << " ^ " << testExponent << " = " << ASM_fpow(fTestNum, testExponent) << '\n';
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

void testMemcpy()
{
    static const char myname[] = "Gabriel Ravier";

    struct
    {
        char name[512];
        int age;
    } person = {{0}, 0}, personCopy = {{0}, 0};

    // Copy string with memcpy
    ASM_memcpy(person.name, myname, sizeof(myname));
    person.age = 46;

    // Copy struct with memcpy
    ASM_memcpy(&personCopy, &person, sizeof(person));

    cout << "personCopy : " << personCopy.name << ", " << personCopy.age << " \n";
}

static void subtestStrncmp(const char *str1, const char *str2, int size)
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
    ASM_bcopy("world", &buffer[6], 6);
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
    char *foundCharacter;
    printf("Looking for the 's' character in \"%s\"...\n",str);
    foundCharacter = ASM_strchr(str,'s');
    while (foundCharacter != NULL)
    {
        cout << "Found at position " << foundCharacter-str+1 << '\n';
        foundCharacter = ASM_strchr(foundCharacter+1,'s');
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

void testGetGreatestCommonDivider()
{
    unsigned long long randNum1 = random(1LL, LLONG_MAX);
    unsigned long long randNum2 = random(1LL, LLONG_MAX);

    cout << "Greatest common divider of " << randNum1 << " and " << randNum2 << " is : " << ASM_getGreatestCommonDivider(randNum1, randNum2) << '\n';
}

void testIsAlphabetic()
{
    cout << "Printing the alphabet : ";
    for (char i = CHAR_MIN; i < CHAR_MAX; i++)
        if (ASM_isAlphabetic(i))
            putchar(i);
    cout << '\n';
}

void testIsPossibleIdentifier()
{
    cout << "Printing all valid characters in an identifier : ";
    for (char i = CHAR_MIN; i < CHAR_MAX; i++)
        if (ASM_isPossibleIdentifier(i))
            putchar(i);
    cout << '\n';
}

void testBubbleSort()
{
    static const int arraySize = 10;
    int testArray[arraySize];
    for (int i = 0; i < arraySize; i++)
        testArray[i] = random(1, 10);
    cout << "Array before sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    ASM_bubbleSort(testArray, arraySize);
    cout << "\nArray after sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    cout << '\n';
}

void testCombSort()
{
    static const int arraySize = 10;
    int testArray[arraySize];
    for (int i = 0; i < arraySize; i++)
        testArray[i] = random(1, 10);
    cout << "Array before sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    ASM_combSort(testArray, arraySize);
    cout << "\nArray after sort : ";
    for (int i = 0; i < arraySize; i++)
        cout << testArray[i] << ' ';
    cout << '\n';
}
