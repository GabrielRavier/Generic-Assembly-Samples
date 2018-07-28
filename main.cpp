#include "assemblyFunctions.h"
#include "tests.h"
#include "comparisons.h"

#include <iostream>
#include <cstring>

using std::cout;

int main(int argc, char *argv[])
{
    cout << "\nTesting gnomeSort\n";
    testGnomeSort();
    cout << "\nTesting cocktailSort\n";
    testCocktailSort();
    cout << "\nTesting combSort\n";
    testCombSort();
    cout << "\nTesting bubbleSort\n";
    testBubbleSort();
    system("pause");
    cout << "\nTesting isPossibleIdentifier\n";
    testIsPossibleIdentifier();
    cout << "\nTesting isAlphabetic\n";
    testIsAlphabetic();
    cout << "\nTesting getGreatestCommonDivider\n";
    testGetGreatestCommonDivider();
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
    cout << "\nTesting fpow\n";
    testFpow();
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
    cout << "\nComparing memcpy\n";
    compareMemcpy();
    return 0;
}
