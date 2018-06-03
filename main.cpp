#include <iostream>
#include <iomanip>
#include <string>

using std::cout;
using std::oct;
using std::dec;
using std::cin;
using std::string;

extern "C"
{
    extern void __cdecl ASM_copyInputToOutput();
    extern void __cdecl ASM_countCharsInLine();
    extern void __cdecl ASM_countLinesWordsCharsInInput();
    extern int __fastcall ASM_pow(int number, int power);
    extern char * __fastcall ASM_strset(char *string, char val);
    extern char * __fastcall ASM_strnset(char *string, char val, int count);
    extern char * __fastcall ASM_strrchr(char *string, char val);
    extern int __fastcall ASM_strlen(char *string);
    extern char * __fastcall ASM_memchr(char *buffer, char character, unsigned count);
    extern unsigned int __fastcall ASM_getbits(unsigned int num, unsigned char position, unsigned int numBits);
    extern int __fastcall ASM_bitcount(unsigned int num);
    extern char * __fastcall ASM_reverseString(char *string);
    extern long long __fastcall ASM_atoi(const char *string);
    extern int __fastcall ASM_floorLog2(int num);
    extern long double __stdcall ASM_ldsquare(long double num);
    extern float __stdcall ASM_fsquare(float num);
    extern long long int __fastcall ASM_square64(long long int num);
    extern int __fastcall ASM_square(int num);
}

int main(int argc, char *argv[])
{
    cout << "Square of " << 8934 << " : " << ASM_square(8934) << '\n';
    const long long int sample64 = 6736847109;
    cout << "Square of " << sample64 << " : " << ASM_square64(sample64) << '\n';
    const float fSample = 4837.1838;
    cout << "Square of " << fSample << " : " << ASM_fsquare(fSample) << '\n';
    const long double ldSample = 28574638.29735498;
    cout << "Square of " << ldSample << " : " << ASM_ldsquare(ldSample) << '\n';
    cout << "Enter a power of 2 : \n";
    int powerOf2 = 0;
    cin >> powerOf2;
    cout << "This is the " << ASM_floorLog2(powerOf2) << "th power of 2\n";
    const unsigned int searchedNum = 888293849;
    cout << "First 5 bits from 24th bit in " << searchedNum << " are equal to : "
         << ASM_getbits(searchedNum, 24, 5) << '\n';
    cout << "There are " << ASM_bitcount(searchedNum) << " 1 bits in " << searchedNum << '\n';
    char myString[] = "something something";
    cout << "First occurence of g in \"" << myString << "\" at the "
         << ASM_memchr(myString, 'g', sizeof(myString)) - myString + 1 /* + 1 because we got the number of bytes from the start
                                                                          of myString not including the first one */
         << "th position\n";
    cout << "Length of myString : " << ASM_strlen(myString) << " bytes\n";
    cout << "Last occurence of i in \"" << myString << "\" at the " << ASM_strrchr(myString, 'i') - myString << "th position\n";
    cout << "myString before reverseString : " << myString << '\n';
    cout << "after reverseString : " << ASM_reverseString(myString) << '\n';
    cout << "myString before strnset : " << myString << '\n';
    cout << "After strnset : " << ASM_strnset(myString, 'B', 10) << '\n';
    cout << "myString before strset : " << myString << '\n';
    cout << "After strset : " << ASM_strset(myString, 'a') << '\n';
    cout << "Enter a number : \n";
    string number = "";
    cin >> number;
    cout << "Converted to a string : " << ASM_atoi(number.c_str()) << '\n';
    cout << "Testing pow function\n";
    for (int i = 0; i < 10; i++)
        cout << i << " ^ " << i << " = " << ASM_pow(i, i) << '\n';
    cout << "Counting characters, lines and words until next backslash \n";
    ASM_countLinesWordsCharsInInput();
    cout << "Counting characters until next backslash\n";
    ASM_countCharsInLine();
    cout << "Copying input to output until next backslash\n";
    ASM_copyInputToOutput();
    return 0;
}
