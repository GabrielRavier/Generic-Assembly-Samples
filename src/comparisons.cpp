#include "comparisons.h"
#include "assemblyFunctions.h"

#include <iostream>
#include <cstring>

using std::cout;

volatile int array1[100000] = {0};
volatile int array2[100000] = {0};

void compareMemcpy()
{
    int lol, lol2;
    ASM_memcpy(&lol, &lol2, sizeof(int)); // Initialise dispatcher
    memcpy(&lol, &lol2, sizeof(int)); // Maybe GCC's has one too idk
    auto tempTime = ASM_readTSC();
    for (int i = 0; i < 100000; i++)
        ASM_memcpy((void *)array2, (void *)array1, 100000);
    auto timeForASM = (ASM_readTSC() - tempTime) / 100000;
    cout << "Clocks for ASM (per iteration) : " << timeForASM << '\n';
    tempTime = ASM_readTSC();
    for (int i = 0; i < 100000; i++)
        memcpy((void *)array2, (void *)array1, 100000);
    auto timeForStd = (ASM_readTSC() - tempTime) / 100000;
    cout << "Clocks for std (per iteration) : " << timeForStd << '\n';
}
