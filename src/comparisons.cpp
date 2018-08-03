#include "comparisons.h"
#include "assemblyFunctions.h"

#include <iostream>
#include <cstring>

using std::cout;

constexpr int sizeForArrays = 100000;
constexpr int compareIterations = 100000;

volatile char array1[sizeForArrays] = {0};
volatile char array2[sizeForArrays] = {0};

void compareMemcpy()
{
    int lol, lol2;
    ASM_memcpy(&lol, &lol2, sizeof(int)); // Initialise dispatcher
    memcpy(&lol, &lol2, sizeof(int)); // Maybe GCC's has one too idk
    auto tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterations; i++)
        ASM_memcpy((void *)array2, (void *)array1, sizeForArrays);
    auto timeForASM = (ASM_readTSC() - tempTime) / compareIterations;
    cout << "Clocks for ASM (per iteration) : " << timeForASM << '\n';
    tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterations; i++)
        memcpy((void *)array2, (void *)array1, sizeForArrays);
    auto timeForStd = (ASM_readTSC() - tempTime) / compareIterations;
    cout << "Clocks for std (per iteration) : " << timeForStd << '\n';
}

void compareMemmove()
{
    int lol, lol2;
    ASM_memmove(&lol, &lol2, sizeof(int)); // Initialise dispatcher
    memmove(&lol, &lol2, sizeof(int)); // Maybe GCC's has one too idk
    auto tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterations; i++)
        ASM_memmove((void *)array2, (void *)array1, sizeForArrays);
    auto timeForASM = (ASM_readTSC() - tempTime) / compareIterations;
    cout << "Clocks for ASM (per iteration) : " << timeForASM << '\n';
    tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterations; i++)
        ASM_memmove((void *)array2, (void *)array1, sizeForArrays);
    auto timeForStd = (ASM_readTSC() - tempTime) / compareIterations;
    cout << "Clocks for std (per iteration) : " << timeForStd << '\n';
}

