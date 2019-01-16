#include <cstddef>
#include <cstdarg>
#include <cstring>
#include <cmath>
#include "idaStuff.h"

size_t szappend(char *dest, const char *src, size_t location);
void *arrget(void **arr, ssize_t indx);
ssize_t arrcnt(void **arr);
size_t arrlen(void **arr, size_t indx);
void MemCopy(const void *src, void *dst, size_t count);

inline size_t lstrlenA(const char *str)
{
    if (str == NULL)
        return 0;

    return strlen(str);
}

int a2dw(const char *str)
{
	const char *v1;
	size_t i; 
	int result;
	size_t lp;
	int current;
	
	for ( i = lstrlenA(str); i; --i )
	{
		lp = i - 1;
		current = (uint8_t)(*str - 48);
		while (lp)
		{
			current *= 10;
			--lp;
		}
		result += current;
		++str;
	}
	return result;
}

void *arr2mem(void ** arr, void *pmem)
{
	char *dest = (char *)pmem;
	ssize_t acnt = arrcnt(arr);
	
	ssize_t i = 1;
	do
	{
		auto llen = arrlen(arr, i);
		auto arrGot = arrget(arr, i);
		MemCopy(arrGot, dest, llen);
		++i;
		dest += llen;
	} while ( i <= acnt );
	return dest;
}

ssize_t arr2text(void **arr, void *pmem)
{
	ssize_t acnt = arrcnt(arr);
	size_t cloc = 0;
	ssize_t loopCnt = 1;
	do
	{
		auto arrGot = (char *)arrget(arr, loopCnt);
		cloc = szappend((char *)pmem, arrGot, cloc);
		*(uint16_t *)((char *)pmem + cloc) = '\n\r';
		cloc += 2;
		++loopCnt;
	} while ( loopCnt <= acnt );
	return acnt;
}

void **arr_add(void **arr, size_t cnt, size_t plus)
{
	void **result;
	size_t i;
	
	result = &arr[cnt];
	i = -1 * cnt;
	do
	{
		result[i] = (char *)result[i] + plus;
		++i;
	} while ( i * 4 );
	return result;
}

ssize_t arrcnt(void **arr)
{
	return (ssize_t)*arr;
}

void *arrget(void **arr, ssize_t indx)
{
	void *result;

	if ( indx < 1 )
		result = (void *)-1;
	else if ( indx > (ssize_t)*arr )
		result = (void *)-2;
	else
		result = arr[indx];
	return result;
}

size_t arrlen(void **arr, size_t indx)
{
	return *((uint32_t *)arr[indx] - 1);
}

void **arr_mul(void **arr, size_t cnt, int mult)
{
	void **result;
	size_t i;
	
	result = &arr[cnt];
	i = -1 * cnt;
	do
	{
		result[i] = (void *)((uint32_t)result[i] * mult);
		++i;
	} while ( i * 4 );
	return result;
}

void **arr_sub(void **arr, size_t cnt, int mult)
{
	void **result;
	size_t i;
	
	result = &arr[cnt];
	i = -1 * cnt;
	do
	{
		result[i] = (char *)result[i] - mult;
		++i;
	} while ( i * 4 );
	return result;
}

char *arrtotal(void **arr, bool crlf)
{
	char *thisIsStupid;
	char *total; 
	signed int i;
	
	thisIsStupid = (char *)*arr;
	total = NULL;
	i = 1;
	
	do
	{
		total += *((uint32_t *)arr[i++] - 1);
	} while ( i <= (ssize_t)thisIsStupid );
	
	if ( crlf )
		total = &thisIsStupid[(uintptr_t)&total[(uintptr_t)thisIsStupid]];
	return total;
}

int32_t atodw(const char *string)
{
	uint32_t retVal; 
	int32_t weirdThingo;
	uint8_t currentCharacter; 
	const char *ptr;
	
	retVal = 0;
	weirdThingo = 0;
	currentCharacter = *string;
	ptr = string + 1;
	if ( currentCharacter == 2 )
	{
		currentCharacter = *ptr;
		weirdThingo = -1;
		ptr = string + 2;
	}
	while ( currentCharacter )
	{
		currentCharacter = currentCharacter - '0';
		retVal = currentCharacter + 10 * retVal;
		currentCharacter = *ptr++;
	}
	return weirdThingo ^ (retVal + weirdThingo);
}

long atol(const char *str)
{
	bool isNegative;
	unsigned long currentCharacter;
	const char *ptr;
	long result;
	bool isInvalid; 
	long convertedChar;
	
	isNegative = false;
	currentCharacter = *str;
	ptr = str + 1;
	if ( currentCharacter == '-' )
	{
		isNegative = true;
		currentCharacter = *ptr;
		ptr = str + 2;
	}
	result = 0;
	while ( 1 )
	{
		isInvalid = currentCharacter < '0';
		convertedChar = currentCharacter - '0';
		if ( isInvalid )
			break;
		result = convertedChar + 10 * result;
		currentCharacter = *ptr++;
	}
	if ( isNegative )
		return -result;
	return result;
}

constexpr uint32_t bintable[0x200] =
{
	'0000', '0000', '0000', '1000', '0000', '0100', '0000', '1100', '0000', '0010', '0000', '1010', '0000', '0110', '0000', '1110', '0000', '0001', '0000', '1001', '0000', '0101', '0000', '1101', '0000', '0011', '0000', '1011', '0000', '0111', '0000', '1111', '1000', '0000', '1000', '1000', '1000', '0100', '1000', '1100', '1000', '0010', '1000', '1010', '1000', '0110', '1000', '1110', '1000', '0001', '1000', '1001', '1000', '0101', '1000', '1101', '1000', '0011', '1000', '1011', '1000', '0111', '1000', '1111', '0100', '0000', '0100', '1000', '0100', '0100', '0100', '1100', '0100', '0010', '0100', '1010', '0100', '0110', '0100', '1110', '0100', '0001', '0100', '1001', '0100', '0101', '0100', '1101', '0100', '0011', '0100', '1011', '0100', '0111', '0100', '1111', '1100', '0000', '1100', '1000', '1100', '0100', '1100', '1100', '1100', '0010', '1100', '1010', '1100', '0110', '1100', '1110', '1100', '0001', '1100', '1001', '1100', '0101', '1100', '1101', '1100', '0011', '1100', '1011', '1100', '0111', '1100', '1111', '0010', '0000', '0010', '1000', '0010', '0100', '0010', '1100', '0010', '0010', '0010', '1010', '0010', '0110', '0010', '1110', '0010', '0001', '0010', '1001', '0010', '0101', '0010', '1101', '0010', '0011', '0010', '1011', '0010', '0111', '0010', '1111', '1010', '0000', '1010', '1000', '1010', '0100', '1010', '1100', '1010', '0010', '1010', '1010', '1010', '0110', '1010', '1110', '1010', '0001', '1010', '1001', '1010', '0101', '1010', '1101', '1010', '0011', '1010', '1011', '1010', '0111', '1010', '1111', '0110', '0000', '0110', '1000', '0110', '0100', '0110', '1100', '0110', '0010', '0110', '1010', '0110', '0110', '0110', '1110', '0110', '0001', '0110', '1001', '0110', '0101', '0110', '1101', '0110', '0011', '0110', '1011', '0110', '0111', '0110', '1111', '1110', '0000', '1110', '1000', '1110', '0100', '1110', '1100', '1110', '0010', '1110', '1010', '1110', '0110', '1110', '1110', '1110', '0001', '1110', '1001', '1110', '0101', '1110', '1101', '1110', '0011', '1110', '1011', '1110', '0111', '1110', '1111', '0001', '0000', '0001', '1000', '0001', '0100', '0001', '1100', '0001', '0010', '0001', '1010', '0001', '0110', '0001', '1110', '0001', '0001', '0001', '1001', '0001', '0101', '0001', '1101', '0001', '0011', '0001', '1011', '0001', '0111', '0001', '1111', '1001', '0000', '1001', '1000', '1001', '0100', '1001', '1100', '1001', '0010', '1001', '1010', '1001', '0110', '1001', '1110', '1001', '0001', '1001', '1001', '1001', '0101', '1001', '1101', '1001', '0011', '1001', '1011', '1001', '0111', '1001', '1111', '0101', '0000', '0101', '1000', '0101', '0100', '0101', '1100', '0101', '0010', '0101', '1010', '0101', '0110', '0101', '1110', '0101', '0001', '0101', '1001', '0101', '0101', '0101', '1101', '0101', '0011', '0101', '1011', '0101', '0111', '0101', '1111', '1101', '0000', '1101', '1000', '1101', '0100', '1101', '1100', '1101', '0010', '1101', '1010', '1101', '0110', '1101', '1110', '1101', '0001', '1101', '1001', '1101', '0101', '1101', '1101', '1101', '0011', '1101', '1011', '1101', '0111', '1101', '1111', '0011', '0000', '0011', '1000', '0011', '0100', '0011', '1100', '0011', '0010', '0011', '1010', '0011', '0110', '0011', '1110', '0011', '0001', '0011', '1001', '0011', '0101', '0011', '1101', '0011', '0011', '0011', '1011', '0011', '0111', '0011', '1111', '1011', '0000', '1011', '1000', '1011', '0100', '1011', '1100', '1011', '0010', '1011', '1010', '1011', '0110', '1011', '1110', '1011', '0001', '1011', '1001', '1011', '0101', '1011', '1101', '1011', '0011', '1011', '1011', '1011', '0111', '1011', '1111', '0111', '0000', '0111', '1000', '0111', '0100', '0111', '1100', '0111', '0010', '0111', '1010', '0111', '0110', '0111', '1110', '0111', '0001', '0111', '1001', '0111', '0101', '0111', '1101', '0111', '0011', '0111', '1011', '0111', '0111', '0111', '1111', '1111', '0000', '1111', '1000', '1111', '0100', '1111', '1100', '1111', '0010', '1111', '1010', '1111', '0110', '1111', '1110', '1111', '0001', '1111', '1001', '1111', '0101', '1111', '1101', '1111', '0011', '1111', '1011', '1111', '0111', '1111', '1111'
};

int byt2bin_ex(uint8_t var, char *buffer)
{
	int result;
	
	result = var;
	*(uint32_t *)buffer = bintable[2 * var];
	*((uint32_t *)buffer + 1) = bintable[2 * var + 1];
	buffer[8] = 0;
	return result;
}

int BMBinSearch(size_t startpos, uint8_t *src, int srcLength, uint8_t *subStr, int subLength)
{
	ssize_t subLengthMin1;
	uint8_t *currentSubPtr; 
	uint8_t currentBufferOffset;
	uint8_t *i;
	ssize_t weirdThingo;
	uint8_t currentIByte;
	uint8_t currentIByte2;
	ssize_t currentBufferByte;
	ssize_t shiftTable[0x100];
	ssize_t savedSubLengthMin1; 
	
	if ( subLength <= 1 )
		return -2;
	
	memset32(shiftTable, subLength, 0x100u);
	subLengthMin1 = subLength - 1;
	currentSubPtr = subStr;
	currentBufferOffset = 0;
	
	do
	{
		currentBufferOffset = *currentSubPtr++;
		shiftTable[currentBufferOffset] = subLengthMin1--;
	} while ( subLengthMin1 );
	
	subLengthMin1 = subLength - 1;
	savedSubLengthMin1 = subLength - 1;
	i = &src[startpos];
	
	do
	{
		currentIByte = i[subLengthMin1];
		
		if ( currentIByte == subStr[subLengthMin1] )
		{
			--subLengthMin1;
			currentIByte2 = 0;
			
			while ( 1 )
			{
				currentIByte2 = i[subLengthMin1];
				if ( currentIByte2 != subStr[subLengthMin1] )
					break;
				if ( --subLengthMin1 < 0 )
					return i - src;
			}
			
			currentBufferByte = shiftTable[currentIByte2];
			
			if ( subLength != currentBufferByte )
			{
				weirdThingo = subLengthMin1 + currentBufferByte - savedSubLengthMin1;
				if ( weirdThingo < 0 )
					weirdThingo = 1;
addSuffixShift:
				i += weirdThingo;
				subLengthMin1 = savedSubLengthMin1;
				continue;
			}
			i += subLengthMin1 + 1;
		}
		else
		{
			weirdThingo = shiftTable[currentIByte];
			if ( subLength != weirdThingo )
				goto addSuffixShift;
			i += subLengthMin1 + 1;
		}
	} while ( (intptr_t)(&src[srcLength] - subLength) >= (intptr_t)i );
	
	return -1;
}

int8_t *BinSearch(int stpos, uint8_t *src, ssize_t slen, uint8_t *patn, ssize_t plen)
{
	ssize_t slenMinPlen;
	uint8_t *srcSlenMinPlen;
	uint8_t *srcStPosMin1;
	ssize_t i;
	int8_t *result;
	ssize_t plenMin1;
	
	slenMinPlen = slen - plen;
	if ( slen - plen < 0 )
		result = (int8_t *)-2;
	else if ( stpos > slenMinPlen )
		result = (int8_t *)-3;
	else
	{
		srcSlenMinPlen = &src[slenMinPlen];
		plenMin1 = plen - 1;
		srcStPosMin1 = &src[stpos - 1];
		while ( (intptr_t)++srcStPosMin1 <= (intptr_t)srcSlenMinPlen )
		{
			if ( *srcStPosMin1 == *patn )
			{
				i = -1;
				while ( 1 )
				{
					++i;
					if ( srcStPosMin1[i] != patn[i] )
						break;
					if ( i == plenMin1 )
						return (int8_t *)(srcStPosMin1 - src);
				}
			}
		}
		result = (int8_t *)-1;
	}
	return result;
}

constexpr unsigned char Cmpi_tbl[0x100] =
{
	0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
	16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
	32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
	48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
	64, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111,
	112,113,114,115,116,117,118,119,120,121,122, 91, 92, 93, 94, 95,
	96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111,
	112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,
	128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
	144,145,146,147,148,149,150,151,152,153,154,155,156,156,158,159,
	160,161,162,163,164,165,166,167,168,169,170,171,172,173,173,175,
	176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
	192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
	208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
	224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,
	240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,
};

size_t Cmpi(uint8_t *src, uint8_t *dst)
{
	int i;
	int currentDstByte;
	uint8_t currentCmpiSrcByte;
	
	i = 0;
	while ( 1 )
	{
		currentDstByte = dst[i];
		currentCmpiSrcByte = Cmpi_tbl[src[i++]];
		if ( currentCmpiSrcByte != Cmpi_tbl[currentDstByte] )
			break;
		if ( !currentCmpiSrcByte )
			return 0;
	}
	return i;
}

bool cmpmem(const uint8_t *mem1, const uint8_t *mem2, size_t size)
{
	int i;
	size_t szCpy;
	size_t szInDwords;
	
	i = 0;
	szCpy = size;
	
	if ( size < 4 )
	{
under:
		while ( mem1[i] == mem2[i] )
		{
			++i;
			if ( !--szCpy )
				return 1;
		}
	}
	else
	{
		szInDwords = size >> 2;
		while ( *(uint32_t *)&mem1[i] == *(uint32_t *)&mem2[i] )
		{
			i += 4;
			if ( !--szInDwords )
			{
				szCpy = size & 3;
				if ( size & 3 )
					goto under;
				return 1;
			}
		}
	}
	return 0;
}

void CombSortA(int32_t *arr, ssize_t arraySize)
{
	double funWithFloatingPoint;
	ssize_t i;
	int32_t toBeCompared2;
	int32_t toBeCompared;
	size_t swaps;
	ssize_t arraySizeMin1;
	
	arraySizeMin1 = arraySize - 1;
	
	do
	{
		funWithFloatingPoint = (double)arraySize / 1.3;
		arraySize = (signed int)funWithFloatingPoint - 1;
		if ( (signed int)funWithFloatingPoint == 1 )
			arraySize = 1;
		
		swaps = 0;
		i = 0;
		
		do
		{
			toBeCompared2 = arr[i];
			toBeCompared = arr[arraySize + i];
			if ( toBeCompared2 > toBeCompared )
			{
				arr[arraySize + i] = toBeCompared2;
				arr[i] = toBeCompared;
				++swaps;
			}
			++i;
		} while ( i <= arraySizeMin1 - arraySize );
	} while ( swaps > 0 || arraySize > 1 );
}

void CombSortD(int32_t *arr, ssize_t arraySize)
{
	double funWithFloatingPoint;
	ssize_t i;
	int32_t toBeCompared; 
	int32_t toBeCompared2;
	ssize_t swaps;
	ssize_t arraySizeMin1;
	
	arraySizeMin1 = arraySize - 1;
	
	do
	{
		funWithFloatingPoint = (double)arraySize / 1.3;
		arraySize = (signed int)funWithFloatingPoint - 1;
		if ( (signed int)funWithFloatingPoint == 1 )
			arraySize = 1;
		
		swaps = 0;
		i = 0;
		
		do
		{
			toBeCompared = arr[i];
			toBeCompared2 = arr[arraySize + i];
			if ( toBeCompared < toBeCompared2 )
			{
				arr[arraySize + i] = toBeCompared;
				arr[i] = toBeCompared2;
				++swaps;
			}
			++i;
		} while ( i <= arraySizeMin1 - arraySize );
	} while ( swaps > 0 || arraySize > 1 );
}

int8_t decomment(char *src)
{
	ssize_t arrIter;
	ssize_t i; 
	int8_t result;
	char last;
	
	arrIter = -1;
	
	for ( i = 0; ; i = arrIter )
	{
		do
		{
			do
			{
				++arrIter;
			} while ( src[arrIter] == ' ' );
		} while ( src[arrIter] == '\t' );
		
		if ( !src[arrIter] )
			return 0;
		
		if ( src[arrIter] == '"' )
		{
			while ( src[++arrIter] )
			{
				if ( src[arrIter] == '"' )
					goto storeit;
			}
			return -1;
		}
		
		if ( src[arrIter] == '\'' )
		{
			while ( src[++arrIter] )
			{
				if ( src[arrIter] == '\'' )
					goto storeit;
			}
			return -1;
		}
		
		if ( src[arrIter] == ';' )
			break;
storeit:
		;
	}
	src[i + 1] = 0;
	last = src[i];
	if ( last == ',' )
		result = 1;
	else
		result = last == '\\';
	return result;
}

void dissort(const char **arr, ssize_t cnt)
{
	ssize_t i;
	const char *swapittySwapped;
	ssize_t j;
	const char *arrayiThingo;
	signed int k;
	char comparedThingo;
	
	for ( i = 1; i < cnt; ++i )
	{
		swapittySwapped = arr[i];
		j = i;
		
inner:
		arrayiThingo = arr[j - 1];
		k = -1;
		
		do
		{
			comparedThingo = arrayiThingo[++k];
			
			if ( comparedThingo > swapittySwapped[k] )
				break;
			
			if ( comparedThingo < swapittySwapped[k] )
			{
				arr[j--] = arrayiThingo;
				if ( j )
				goto inner;
				break;
			}
			
		} while ( comparedThingo );
		
		arr[j] = swapittySwapped;
	}
}

void dw2ah(uint32_t value, char *buffer)
{
	char *revBuf;
	uint8_t andedVal;
	uint8_t tmp; 
	uint32_t roredVal;
	
	*((uint16_t *)buffer + 4) = 'H';
	revBuf = buffer + 7;
	do
	{
		andedVal = value & 0xF;
		
		if ( (value & 0xF) >= 0xA )
			tmp = andedVal + '7';
		else
			tmp = andedVal + '0';
		*revBuf-- = tmp;
		roredVal = __ROR4__(value, 4);
		value = roredVal;
	} while ( revBuf >= buffer );
}

void dw2bin_ex(int var, char *buffer)
{
	uint8_t tmp;
	
	tmp = BYTE3(var);
	*(uint64_t *)buffer = *(uint64_t *)&bintable[2 * BYTE3(var)];
	tmp = BYTE2(var);
	*((uint32_t *)buffer + 2) = bintable[2 * tmp];
	*((uint32_t *)buffer + 3) = bintable[2 * tmp + 1];
	tmp = BYTE1(var);
	*((uint32_t *)buffer + 4) = bintable[2 * tmp];
	*((uint32_t *)buffer + 5) = bintable[2 * tmp + 1];
	tmp = var;
	*((uint32_t *)buffer + 6) = bintable[2 * tmp];
	*((uint32_t *)buffer + 7) = bintable[2 * tmp + 1];
	buffer[32] = 0;
}

constexpr uint16_t hex_table[0x100] =
{
 '00', '10', '20', '30', '40', '50', '60', '70', '80', '90', 'A0', 'B0', 'C0', 'D0', 'E0', 'F0', '01', '11', '21', '31', '41', '51', '61', '71', '81', '91', 'A1', 'B1', 'C1', 'D1', 'E1', 'F1', '02', '12', '22', '32', '42', '52', '62', '72', '82', '92', 'A2', 'B2', 'C2', 'D2', 'E2', 'F2', '03', '13', '23', '33', '43', '53', '63', '73', '83', '93', 'A3', 'B3', 'C3', 'D3', 'E3', 'F3', '04', '14', '24', '34', '44', '54', '64', '74', '84', '94', 'A4', 'B4', 'C4', 'D4', 'E4', 'F4', '05', '15', '25', '35', '45', '55', '65', '75', '85', '95', 'A5', 'B5', 'C5', 'D5', 'E5', 'F5', '06', '16', '26', '36', '46', '56', '66', '76', '86', '96', 'A6', 'B6', 'C6', 'D6', 'E6', 'F6', '07', '17', '27', '37', '47', '57', '67', '77', '87', '97', 'A7', 'B7', 'C7', 'D7', 'E7', 'F7', '08', '18', '28', '38', '48', '58', '68', '78', '88', '98', 'A8', 'B8', 'C8', 'D8', 'E8', 'F8', '09', '19', '29', '39', '49', '59', '69', '79', '89', '99', 'A9', 'B9', 'C9', 'D9', 'E9', 'F9', '0A', '1A', '2A', '3A', '4A', '5A', '6A', '7A', '8A', '9A', 'AA', 'BA', 'CA', 'DA', 'EA', 'FA', '0B', '1B', '2B', '3B', '4B', '5B', '6B', '7B', '8B', '9B', 'AB', 'BB', 'CB', 'DB', 'EB', 'FB', '0C', '1C', '2C', '3C', '4C', '5C', '6C', '7C', '8C', '9C', 'AC', 'BC', 'CC', 'DC', 'EC', 'FC', '0D', '1D', '2D', '3D', '4D', '5D', '6D', '7D', '8D', '9D', 'AD', 'BD', 'CD', 'DD', 'ED', 'FD', '0E', '1E', '2E', '3E', '4E', '5E', '6E', '7E', '8E', '9E', 'AE', 'BE', 'CE', 'DE', 'EE', 'FE', '0F', '1F', '2F', '3F', '4F', '5F', '6F', '7F', '8F', '9F', 'AF', 'BF', 'CF', 'DF', 'EF', 'FF'
};

void dw2hex_ex(uint32_t src, char *buf)
{
	uint32_t tmp;
	
	tmp = *(uint32_t *)&hex_table[(uint8_t)src] << 16;
	LOWORD(tmp) = hex_table[BYTE1(src)];
	*((uint32_t *)buf + 1) = tmp;
	tmp = *(uint32_t *)&hex_table[BYTE2(src)] << 16;
	LOWORD(tmp) = hex_table[BYTE3(src)];
	*(uint32_t *)buf = tmp;
	buf[8] = 0;
}

void dwtoa(int32_t value, char *buffer)
{
	char *origBuffer;
	int32_t tmpVal;
	
	if ( !value )
	{
		buffer[0] = '0';
		buffer[1] = '\0';
	}
	else
	{
		if ( value < 0 )
		{
			*buffer = '-';
			value = -value;
			++buffer;
		}
		
		origBuffer = buffer;
		
		while ( value )
		{
			tmpVal = value;
			value /= 10;
			*buffer++ = tmpVal - 10 * value + '0';
		}
		
		*buffer = 0;
		
		while ( origBuffer < buffer )
		{
			--buffer;
			LOBYTE(value) = *origBuffer;
			BYTE1(value) = *buffer;
			*buffer = *origBuffer;
			*origBuffer++ = BYTE1(value);
		}
	}
}

int get_line_count(char *mem, size_t blen)
{
	signed int i;
	int result;
	
	if ( *(uint16_t *)&mem[blen - 2] != '\n\r' )
	{
		*(uint16_t *)&mem[blen] = '\n\r';
		mem[blen + 2] = 0;
	}
	
	i = -1;
	result = 0;
	
	while ( mem[++i] )
	{
		if ( mem[i] == '\n' )
			++result;
	}
	
	return result;
}

size_t get_ml(const char *src, char *dst, size_t rpos)
{
	const char *srcPlusRpos;
	size_t i;
	size_t k;
	size_t l;
	char tmpChar; 
	size_t j;
	char tmpChar2;
	char tmpChar3;
	size_t result;
	size_t bsflag;
	
	bsflag = 0;
	srcPlusRpos = &src[rpos];
	i = 0;
	k = 0;
	l = 0;
	
leadTrim:
	while ( 1 )
	{
		tmpChar = srcPlusRpos[i++];
		if ( !tmpChar )
			break;
		if ( tmpChar > ' ' )
		{
			if ( tmpChar == ';' )
			{
				while ( 1 )
				{
					tmpChar2 = srcPlusRpos[i++];
					if ( !tmpChar2 )
						break;
					if ( tmpChar2 == '\n' )
						goto leadTrim;
				}
			}
			else
			{
				j = i - 1;
				
				while ( 1 )
				{
					do
					{
mainText:	
						tmpChar2 = srcPlusRpos[j++];
						if ( !tmpChar2 )
							goto setEnd;
					} while ( tmpChar2 == '\r' );
					
					if ( tmpChar2 == '\n' )
					{
testTail:	
						if ( srcPlusRpos[l - 1] == ',' )
							goto fTrim;
						
						if ( srcPlusRpos[l - 1] == '\\' )
						{
							dst[bsflag] = ' ';
							bsflag = 0;
							goto fTrim;
						}
						
						result = rpos + j;
						goto lastByte;
					}
					
					if ( tmpChar2 == ';' )
						break;
					
					if ( tmpChar2 == '"' )
					{
						dst[k++] = '"';
						while ( 1 )
						{
							tmpChar3 = srcPlusRpos[j++];
							dst[k++] = tmpChar3;
							
							if ( !tmpChar3 || tmpChar3 == '\n' )
								goto qtError;
							
							if ( tmpChar3 == '"' )
							{
fTrim:
								while ( 1 )
								{
									tmpChar3 = srcPlusRpos[j++];
									
									if ( !tmpChar3 )
										goto setEnd;
									
									if ( tmpChar3 > ' ' )
									{
										--j;
										goto mainText;
									}
								}
							}
						}
					}
					if ( tmpChar2 == '\'' )
					{
						dst[k++] = '\'';
						
						while ( 1 )
						{
							tmpChar3 = srcPlusRpos[j++];
							dst[k++] = tmpChar3;
							
							if ( !tmpChar3 || tmpChar3 == '\n' )
								break;
							
							if ( tmpChar3 == '\'' )
								goto fTrim;
						}
qtError:		
						result = -1;
						goto lastByte;
					}
					if ( tmpChar2 > ' ' )
					{
						l = j;
						bsflag = k;
					}
					dst[k++] = tmpChar2;
				}
				--j;
				while ( srcPlusRpos[++j] )
				{
					if ( srcPlusRpos[j] == '\n' )
						goto testTail;
				}
			}
			break;
		}
	}
	
setEnd:
	result = 0;
	
lastByte:
	dst[k] = 0;
	return result;
}

signed int GetPercent(signed int source, signed int percent)
{
	return (signed int)((long double)percent * 0.0099999999999999999998 * (long double)source);
}

void GetPathOnly(const char *src, char *dst)
{
	size_t i;
	char *dstCopy;
	size_t whereDoWePutTheZero;
	char currentChar;
	
	i = 0;
	dstCopy = dst;
	whereDoWePutTheZero = 0;
	
	while ( 1 )
	{
		currentChar = *src++;
		++i;
		
		if ( !currentChar )
			break;
		
		if ( currentChar == '\\' )
			whereDoWePutTheZero = i;
		
		*dstCopy++ = currentChar;
	}
	
	dst[whereDoWePutTheZero] = '\0';
}

int htodw(const char *str)
{
	const char *endStrPtr;
	size_t minStrlen;
	int retVal;
	char part2;
	int i;
	char currentChar;
	char tmpVal;
	
	endStrPtr = str;
	do
		currentChar = *endStrPtr++;
	while ( currentChar );
	
	minStrlen = str - endStrPtr;
	retVal = 0;
	part2 = 0;
	
	for ( i = ~minStrlen; i; --i )
	{
		currentChar = *str;
		
		if ( *str < 'A' )
			tmpVal = currentChar - '0';
		else
		{
			part2 = ' ' * ((currentChar < 'W') + part2);
			tmpVal = part2 + currentChar - 'W';
		}
		
		retVal += (tmpVal & 0xF) << 4 * (i - 1);
		++str;
	}
	
	return retVal;
}

ssize_t InString(ssize_t startPos, const char *source, const char *pattern)
{
	ssize_t patternLen;
	ssize_t result;
	const char *sourcePlusSourceLenMinPatternLenPlus1; 
	ssize_t startPosMin1MinSourceLenMinPatternLenPlus1;
	ssize_t patternLenCpy;
	ssize_t sourceLen;
	ssize_t sourceLenMinPatternLenPlus1;
	ssize_t startPosMin1;
	
	sourceLen = strlen(source);
	patternLen = strlen(pattern);
	
	if ( startPos >= 1 )
	{
		startPosMin1 = startPos - 1;
		
		if ( patternLen < sourceLen )
		{
			sourceLenMinPatternLenPlus1 = sourceLen - patternLen + 1;
			
			if ( sourceLenMinPatternLenPlus1 > startPosMin1 )
			{
				sourcePlusSourceLenMinPatternLenPlus1 = &source[sourceLenMinPatternLenPlus1];
				startPosMin1MinSourceLenMinPatternLenPlus1 = startPosMin1 - sourceLenMinPatternLenPlus1;
scanLoop:
				while ( *pattern != sourcePlusSourceLenMinPatternLenPlus1[startPosMin1MinSourceLenMinPatternLenPlus1] )
				{
					if ( ++startPosMin1MinSourceLenMinPatternLenPlus1 >= 0 )
						return 0;
				}
				
				patternLenCpy = patternLen;
				
				do
				{
					if (*(&sourcePlusSourceLenMinPatternLenPlus1[patternLenCpy - 1] + startPosMin1MinSourceLenMinPatternLenPlus1) != pattern[patternLenCpy -  1])
					{
						++startPosMin1MinSourceLenMinPatternLenPlus1;
						goto scanLoop;
					}
				--patternLenCpy;
				} while ( patternLenCpy );
				
				result = sourceLenMinPatternLenPlus1 + startPosMin1MinSourceLenMinPatternLenPlus1 + 1;
			}
			else
				result = -2;
		}
		else
			result = -1;
	}
	else
		result = -2;
	
	return result;
}

int32_t IntDiv(int32_t numerator, int32_t dividend)
{
	return (int32_t)((double)numerator / (double)dividend);
}

int32_t IntMul(int32_t multiplicand, int32_t multiplier)
{
	return (int32_t)((double)multiplicand * (double)multiplier);
}

int32_t IntSqrt(int32_t x)
{
	return (int32_t)sqrt((double)x);
}

int isalpha(char ch)
{	
	if ( ch < 'A' || ch > 'z' )
		return 0;
	if ( ch <= 'Z' )
		return 1;
	if ( ch < 'a' )
		return 0;
	else
		return 2;
}

int isalphanum(char ch)
{
	if ( ch < '0' )
		return 0;
	if ( ch <= '9' )
		return 1;
	if ( ch < 'A' )
		return 0;
	if ( ch > 'Z' )
	{
		if ( ch >= 'a' && ch <= 'z' )
			return 3;
		return 0;
	}
	return 2;
}

bool islower(char ch)
{
	return ch >= 'a' && ch <= 'z';
}

bool isnumber(char ch)
{
	return ch >= '0' && ch <= '9';
}

bool isupper(char ch)
{
	return ch >= 'A' && ch <= 'Z';
}

size_t lfcnt(char *str)
{
	size_t result = 0;
	--str;
	while ( *++str )
	{
		if ( *str == '\n' )
			++result;
	}
	return result;
}

void MemCopy(const void *src, void *dst, size_t count)
{
	memcpy(dst, src, count);
}

void memfill(void *buffer, size_t cnt, int fill)
{
	uint32_t *buf32;
	size_t i;
	size_t loopCnt; 
	size_t smallCnt;
	
	buf32 = (uint32_t *)buffer;
	
	for ( i = cnt >> 5; i; --i )
	{
		*buf32 = fill;
		buf32[1] = fill;
		buf32[2] = fill;
		buf32[3] = fill;
		buf32[4] = fill;
		buf32[5] = fill;
		buf32[6] = fill;
		buf32[7] = fill;
		buf32 += 8;
	}
	
	smallCnt = cnt & 0x1F;
	if ( smallCnt )
	{
		loopCnt = smallCnt >> 2;
		do
		{
			*buf32 = fill;
			++buf32;
			--loopCnt;
		} while ( loopCnt );
	}
}

int NameFromPath(const char *src, char *dst)
{
	size_t j;  
	ssize_t i; 
	const char *srcPtr; 
	ssize_t k;
	char currentChar; 
	signed int result;
	
	j = (size_t)src;
	i = -1;
	
	while ( src[++i] )
	{
		if ( src[i] == '\\' )
			j = i;
	}
	
	if ( j == (size_t)src )
		result = -1;
	else
	{
		srcPtr = &src[j + 1];
		k = -1;
		
		do
		{
			currentChar = srcPtr[++k];
			dst[k] = currentChar;
		} while ( currentChar );
		
		result = 0;
	}
	return result;
}

int nrandom_seed = 12345678;

uint32_t nrandom(uint32_t base)
{
	uint32_t tmp;
	
	tmp = nrandom_seed;
	if ( nrandom_seed & 0x80000000 )
		tmp = nrandom_seed + 0x7FFFFFFF;
	nrandom_seed = 16807 * (tmp % 127773) - 2836 * (tmp / 127773);
	return (16807 * (tmp % 127773) - 2836 * (tmp / 127773)) % base;
}

void nseed(uint32_t seed)
{
	nrandom_seed = seed;
}

constexpr bool ctbl[256] =
{
	true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, true, false, true, false, false, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
};


int parse_line(const char *src, char **array)
{
	char *firstArrayMember;
	char currentChar;
	int argCounter; 
	char currentChar2;
	
	firstArrayMember = *array;
	currentChar = 0;
	argCounter = 0;
	
	do
	{
badChar:
		currentChar = *src++;
		if ( !currentChar )
		{
gaOut:
			*firstArrayMember = 0;
			*array[1] = 0;
			return argCounter;
		}
	} while ( ctbl[currentChar] != 1 );
	
	++argCounter;
	
	while ( currentChar != '[' )
	{
		if ( currentChar == '"' )
		{
			*firstArrayMember++ = '"';
			while ( 1 )
			{
				currentChar2 = *src++;
				if ( !currentChar2 )
					return argCounter;
				*firstArrayMember++ = currentChar2;
				if ( currentChar2 == '"' )
					goto reIndex;
			}
		}
		
		*firstArrayMember++ = currentChar;
		currentChar = *src++;
		
		if ( !currentChar )
			goto gaOut;
		if ( !ctbl[currentChar] )
			goto reIndex;
	}
	
wsqb:
	*firstArrayMember++ = currentChar;
	if ( currentChar == ']' )
	{
reIndex:
		*firstArrayMember = 0;
		++array;
		firstArrayMember = *array;
		goto badChar;
	}
	
	while ( 1 )
	{
		currentChar = *src++;
		if ( !currentChar )
			return argCounter;
		if ( currentChar != ' ' )
			goto wsqb;
	}
}

size_t partial(size_t starat, const char *src, const char *pattern)
{
	const char *patMin1;
	const char *afterFillerChars;
	ssize_t i;
	char currentChar;
	const char *exitOffset;
	size_t patternLength;
	size_t srcLength;
	size_t fillerChars;
	const char *src2;
	
	src2 = &src[starat];
	patternLength = strlen(pattern);
	srcLength = strlen(src2);
	patMin1 = pattern - 1;
	
	for ( fillerChars = 0; *++patMin1 == '*'; ++fillerChars )
		;
	
	afterFillerChars = &src2[fillerChars - 1];
	exitOffset = &afterFillerChars[fillerChars] + srcLength - patternLength;
	
mainLoop:
	while ( *++afterFillerChars != *patMin1 )
	{
		if ( (intptr_t)afterFillerChars > (intptr_t)exitOffset )
			return -1;
	}
	
	i = -1;
	
	while ( ++i <= (ssize_t)(patternLength - fillerChars - 1) )
	{
		currentChar = patMin1[i];
		if ( currentChar != '*' && currentChar != afterFillerChars[i] )
			goto mainLoop;
	}
	
	return starat + afterFillerChars - src2 - fillerChars;
}

void RolData(uint8_t *src, size_t srcLength, uint8_t *key, size_t keyLength)
{
	uint8_t currentByte;
	uint8_t currentKeyByte;
	uint8_t bvar;
	uint8_t *pcnt;
	
	pcnt = key;
	bvar = *key;
	do
	{
		currentByte = __ROL1__(*src, bvar);
		currentKeyByte = *++pcnt;
		if ( pcnt == &key[keyLength] )
		{
			pcnt = key;
			currentKeyByte = *key;
		}
		bvar = currentKeyByte;
		*src++ = currentByte;
		--srcLength;
	} while ( srcLength );
}

void RorData(uint8_t *src, size_t srcLength, uint8_t *key, size_t keyLength)
{
	uint8_t currentByte;
	uint8_t currentKeyByte;
	uint8_t bvar;
	uint8_t *pcnt;
	
	pcnt = key;
	bvar = *key;
	do
	{
		currentByte = __ROR1__(*src, bvar);
		currentKeyByte = *++pcnt;
		if ( pcnt == &key[keyLength] )
		{
			pcnt = key;
			currentKeyByte = *key;
		}
		bvar = currentKeyByte;
		*src++ = currentByte;
		--srcLength;
	} while ( srcLength );
}

int SBMBinSearch(size_t startpos, char *src, ssize_t srcLength, const char *subStr, ssize_t subStrLength)
{
	int result;
	ssize_t subStrLenMin1;
	const char *subStrCpy;
	char currentChar;
	ssize_t subStrLenMin1v2; 
	char currentChar3;
	char *srcPlusStartPos;
	ssize_t shiftTableThingo;
	char currentChar2;
	ssize_t shiftTable[256]; 
	
	if ( subStrLength > 1 )
	{
		memset32(shiftTable, subStrLength, 0x100u);
		subStrLenMin1 = subStrLength - 1;
		subStrCpy = subStr;
		currentChar = 0;
		
		do
		{
			currentChar = *subStrCpy++;
			shiftTable[currentChar] = subStrLenMin1--;
		} while ( subStrLenMin1 );
		
		subStrLenMin1v2 = subStrLength - 1;
		currentChar3 = 0;
		srcPlusStartPos = &src[startpos];
cmpLoop:
		while ( 1 )
		{
			currentChar3 = srcPlusStartPos[subStrLenMin1];
			if ( currentChar3 != subStr[subStrLenMin1] )
				break;
			if ( --subStrLenMin1 < 0 )
				return srcPlusStartPos - src;
		}
		shiftTableThingo = shiftTable[currentChar3] + subStrLenMin1 - subStrLenMin1v2;
		if ( shiftTableThingo < 0 )
			shiftTableThingo = 1;
		for ( srcPlusStartPos += shiftTableThingo; (intptr_t)(&src[srcLength] - subStrLength) >= (intptr_t)srcPlusStartPos; srcPlusStartPos += shiftTable[currentChar2] )
		{
			currentChar2 = srcPlusStartPos[subStrLenMin1v2];
			if ( currentChar2 == subStr[subStrLenMin1v2] )
			{
				subStrLenMin1 = subStrLength - 2;
				currentChar3 = 0;
				goto cmpLoop;
			}
		}
		result = -1;
	}
	else
		result = -2;
	return result;
}

void StripRangeI(const char *source, char *destination, char startByte, char endByte)
{
	char currentChar;
	
lpSt:
	while ( 1 )
	{
		currentChar = *source++;
		
		if ( !currentChar )
			break;
		
		if ( currentChar == startByte )
		{
			while ( 1 )
			{
				currentChar = *source++;
				if ( !currentChar )
					goto end;
				if ( currentChar == endByte )
					goto lpSt;
			}
		}
		
		*destination++ = currentChar;
	}
end:
	*destination = currentChar;
}

void StripLF(char *src)
{
	--src;
	while ( *++src )
	{
		if ( *src == '\r' )
		{
			*src = '\0';
			return;
		}
	}
}

void StripRangeX(const char *source, char *destination, char startByte, char endByte)
{
	char currentChar;
	char *destPlus1;
	char currentChar2;
	
srxSt:
	while ( 1 )
	{
		currentChar = *source++;
		if ( !currentChar )
			break;
		
		if ( currentChar == startByte )
		{
			*destination = currentChar;
			destPlus1 = destination + 1;
			
			while ( 1 )
			{
				currentChar2 = *source++;
				if ( !currentChar2 )
					return;
				
				if ( currentChar2 == endByte )
				{
					*destPlus1 = currentChar2;
					destination = destPlus1 + 1;
					goto srxSt;
				}
			}
		}
		
		*destination++ = currentChar;
	}
}

size_t szappend(char *dest, const char *src, size_t location)
{
	signed int i;
	int currentCharacter;
	
	i = -1;
	do
	{
		currentCharacter = src[++i];
		*(&dest[location] + i) = currentCharacter;
	} while ( currentCharacter );
	return location + i;
}

ssize_t szCmp(const char *str1, const char *str2)
{
	ssize_t result;
	
	result = -1;
	while ( 1 )
	{
		++result;
		if ( str1[result] != str2[result] )
			break;
		if ( !str1[result] )
			return result;
		++result;
		if ( str1[result] != str2[result] )
			break;
		if ( !str1[result] )
			return result;
		++result;
		if ( str1[result] != str2[result] )
			break;
		if ( !str1[result] )
			return result;
		++result;
		if ( str1[result] != str2[result] )
			break;
		if ( !str1[result] )
			return result;
	}
	return 0;
}

constexpr unsigned char szCmpi_tbl[256] =
{
 '\0', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\a', '\b', '\t', '\n', '\v', '\f', '\r', '\x0E', '\x0F', '\x10', '\x11', '\x12', '\x13', '\x14', '\x15', '\x16', '\x17', '\x18', '\x19', '\x1A', '\x1B', '\x1C', '\x1D', '\x1E', '\x1F', ' ', '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '.', '-', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '[', '\\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 173, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255
};

size_t szCmpi(const char *str1, const char *str2, size_t len)
{
	size_t result;
	int currentCharStr1;
	int currentCharStr2;
	
	result = 0;
	while ( 1 )
	{
		currentCharStr1 = str1[result];
		currentCharStr2 = str2[result++];
		if ( szCmpi_tbl[currentCharStr1] != szCmpi_tbl[currentCharStr2] )
			break;
		if ( result >= len )
			return 0;
	}
	return result;
}

ssize_t szCopy(const char *src, char *dest)
{
	ssize_t result; 
	int currentChar;
	
	result = -1;
	do
	{
		currentChar = src[++result];
		dest[result] = currentChar;
	} while ( currentChar );
	return result;
}

char *szLeft(const char *src, char *dest, size_t length)
{
	char *destination;
	size_t i;
	
	destination = &dest[length];
	i = -length;
	do
	{
		destination[i] = *(&src[length] + i);
		++i;
	} while ( i );
	*destination = '\0';
	return dest;
}

size_t szLen(const char *str)
{
	const char *string;
	
	string = str - 4;
	while ( 1 )
	{
		string += 4;
		if ( !*string )
			break;
		if ( !string[1] )
			return string - str + 1;
		if ( !string[2] )
			return string - str + 2;
		if ( !string[3] )
			return string - str + 3;
	}
	return string - str;
}

char * szLower(char *str)
{
	char *string;
	
	string = str - 1;
	while ( *++string )
	{
		if ( *string >= 'A' && *string <= 'Z' )
			*string += 32;
	}
	return str;
}

size_t szLtrim(char *src, char *dest)
{
	size_t i;
	size_t result;
	char currentCharacter;
	
	i = 0;
	--src;
	do
	{
		do
			++src;
		while ( *src == ' ' );
	} while ( *src == '\t' );
	
	if ( *src )
	{
		do
		{
			currentCharacter = src[i];
			dest[i++] = currentCharacter;
		} while ( currentCharacter );
		result = i - 1;
	}
	else
	{
		result = 0;
		*dest = 0;
	}
	return result;
}

char *szMid(const char *src, char *dst, size_t stp, size_t length)
{
	char *result;
	size_t revLength;
	
	result = &dst[length];
	revLength = -length;
	
	do
	{
		result[revLength] = *(&src[stp] + length + revLength);
		++revLength;
	} while ( revLength );
	
	*result = '\0';
	return result;
}

char *szMonoSpace(char *src)
{
	char *sourceMin1; // ecx@1
	char *source; // edx@1
	int currentCharacter; // eax@3 MAPDST
	
	sourceMin1 = src - 1;
	source = src;
	
	do
	{
		do
ftrim:
			currentCharacter = *++sourceMin1;
		while ( currentCharacter == ' ' );
	}
	while ( currentCharacter == '\t' );
	
	--sourceMin1;
	
	do
	{
		currentCharacter = *++sourceMin1;
		if ( currentCharacter == ' ' || currentCharacter == '\t' )
		{
			*source++ = ' ';
			goto ftrim;
		}
		*source++ = currentCharacter;
	} while ( currentCharacter );
	
	if ( *(source - 2) == ' ' )
		*(source - 2) = 0;
	return src;
}

char *szMultiCat(size_t paramCount, char *buf, ...)
{
	size_t i;
	char *buffer;
	char *currentParam;
	char currentChar;
	va_list va;
	
	va_start(va, buf);
	i = 0;
	buffer = buf - 1;
	
	do
	{
		if ( !*++buffer )
			break;
		++buffer;
	} while ( *buffer );
	
	do
	{
		--buffer;
		currentParam = ((char **)va)[i];
		
		do
		{
			++buffer;
			currentChar = *currentParam;
			*buffer = currentChar;
			++currentParam;
			if ( !currentChar )
				break;
			
			++buffer;
			currentChar = *currentParam;
			*buffer = currentChar;
			++currentParam;
		} while ( currentChar );
		
		++i;
		
	} while ( i != paramCount );
	
	return buf;
}

char *szRemove(const char *src, char *dest, const char *remove)
{
	char firstRemChar;
	char *destination;
	size_t i;
	
	firstRemChar = *remove;
	destination = dest;
	--src;
	
	while ( 1 )
	{
		++src;
		
scanLoop:
		if ( *src == firstRemChar )
		{
			
			i = 0;
			
			while ( src[i] == remove[i] )
			{
				if ( remove[++i] )
				{
					if ( src[i] != remove[i] )
						break;
					
					if ( remove[++i] )
					{
						if ( src[i] != remove[i] )
							break;
					
						if ( remove[++i] )
						{
							if ( src[i] != remove[i] )
								break;
							if ( remove[++i] )
								continue;
						}
					}
				}
				
				src += i;
				goto scanLoop;
			}
		}
		*destination = *src;
		
		if ( !*destination )
			return dest;
		
		++destination;
	}
}

void szRep(const char *src, char *dest, const char *txt1, const char *txt2)
{
	size_t srcLen;
	ssize_t i;
	char currentChar;
	const char *lastCharacter;
	
	srcLen = strlen(src);
	lastCharacter = &(src--)[srcLen - strlen(txt1) + 1];
	
rpst:
	while ( (intptr_t)lastCharacter > (intptr_t)++src )
	{
		if ( *src == *txt1 )
		{
			i = -1;
			while ( 1 )
			{
				++i;
				currentChar = *txt1;
				if ( !*txt1 )
					break;
				
				++txt1;
				
				if ( src[i] != currentChar )
				{
					*dest++ = *src;
					goto rpst;
				}
			}
			
			--i;
			
			while ( 1 )
			{
				currentChar = *txt2;
				if ( !*txt2 )
					break;
				++txt2;
				*dest++ = currentChar;
			}
			
			src += i;
		}
		else
			*dest++ = *src;
	}
	
	i = -1;
	do
	{
		currentChar = src[++i];
		dest[i] = currentChar;
	} while ( currentChar );
}

char *szRev(const char *src, char *dest)
{
	ssize_t i;
	char currentChar; 
	char *destination;
	char *source;
	
	i = 0;
	do
	{
		currentChar = src[i];
		dest[i++] = currentChar;
	} while ( currentChar );
	
	destination = &dest[--i - 1];
	i = -((size_t)i >> 1);
	source = &dest[-i];
	do
	{
		currentChar = source[i];
		source[i] = *destination;
		*destination-- = currentChar;
		++i;
	} while ( i );
	
	return dest;
}

char *szRight(const char *src, char *dst, int len)
{
	const char *source;
	ssize_t i;
	char currentChar;
	
	source = &src[strlen(src) - len];
	i = -1;
	
	do
	{
		currentChar = source[++i];
		dst[i] = currentChar;
	} while ( currentChar );
	
	return dst;
}

size_t szRtrim(const char *src, char *dest)
{
	size_t i; // edx@0
	const char *source; // esi@1
	size_t result; // eax@5
	size_t j; // ecx@6
	char currentChar; // al@7
	
	source = src - 1;
	do
	{
		do
			++source;
		while ( *source == ' ' );
	} while ( *source == '\t' );
	
	if ( *source )
	{
		i = 0;
		j = 0;
		
		while ( 1 )
		{
			currentChar = src[j];
			dest[j++] = currentChar;
			if ( !currentChar )
				break;
			if ( (unsigned char)currentChar >= 0x21 )
				i = j;
		}
		
		dest[i] = '\0';
		result = i;
	}
	else
	{
		result = 0;
		*dest = '\0';
	}
	
	return result;
}

size_t szTrim(char *src)
{
	size_t i;
	size_t j;
	const char *source;
	size_t result;
	char currentChar;
	
	source = src - 1;
	do
	{
		do
		++source;
		while ( *source == ' ' );
	} while ( *source == '\t' );
	if ( *source )
	{
		while ( 1 )
		{
			i = 0;
			j = 0;
			currentChar = source[j];
			src[j++] = currentChar;
			if ( !currentChar )
				break;
			if ( (unsigned char)currentChar >= 0x21 )
				i = j;
		}
		src[i] = 0;
		result = i;
	}
	else
	{
		result = 0;
		*src = 0;
	}
	return result;
}

char *szUpper(char *src)
{
	char *source = src - 1;
	while (*++source)
		if (*source >= 'a' && *source <= 'z')
			*source += 0x20;
	return src;
}

const char *tstline(const char *str)
{
	--str;
	
	do
		do
			++str;
		while (*str == ' ');
	while (*str == '\t');
		
	if (*str < 0x20)
		return nullptr;
	else
		return str;
}

size_t ucappend(wchar_t *dest, const wchar_t *src, size_t cloc)
{
	size_t i = 0;
	wchar_t currentChar;
	do
	{
		currentChar = src[i];
		*(wchar_t *)((char *)dest + cloc + i * sizeof(wchar_t)) = currentChar;
		++i;
	} while (currentChar);
	
	return cloc + i * sizeof(wchar_t) - sizeof(wchar_t);
}

wchar_t ucCatStr(wchar_t *dest, const wchar_t *src)
{
	--dest;
	do
		++dest;
	while (*dest);
	
	wchar_t currentChar;
	do
	{
		currentChar = *src;
		*dest = *src;
		++src;
		++dest;
	} while (currentChar);
	
	return currentChar;
}

size_t ucCmp(const wchar_t *str1, const wchar_t *str2)
{
	ssize_t i = -1;
	
	while (1)
	{
		++i;
		wchar_t currentChar = str1[i];
		if (currentChar != str2[i])
			return 0;
		if (!currentChar)
			return ((size_t)i * 2) >> 1;
	}
}

wchar_t ucCopy(const wchar_t *src, wchar_t *dest)
{
	ssize_t i = -1;
	
	do
	{
		++i;
		dest[i] = src[i];
	} while (src[i]);
}

void ucLeft(const wchar_t *src, wchar_t *dest, size_t stop)
{
	size_t i = 0;
	do
	{
		dest[i] = src[i];
		i++;
	} while (i != stop);
	
	dest[i] = 0;
}

size_t ucLen(const wchar_t *src)
{
	size_t i = 0;
	while (src[i])
		++i;
	
	return i;
}

wchar_t *ucMultiCat(size_t paramCount, wchar_t *buffer, ...)
{
	va_list va;
	va_start(va, buffer);
	
	auto dest = buffer;
	do
		++dest;
	while (*dest);
	
	size_t i = 0;
	do
	{
		--dest;
		auto src = ((wchar_t **)va)[i];
		
		wchar_t currentChar;
		do
		{
			++dest;
			currentChar = *src;
			*dest = *src;
			++src;
		} while (currentChar);
		++i;
	} while (i != paramCount);
	
	return buffer;
}

// atodw_ex, a2wc, AboutBox, AboutBoxProc, acisort, aissort, Alloc, GetAppPath, GetAppPathW, arralloc, arrbin, arrealloc, realloc_string_array, arrextnd, arrfile, arrfree, arrset, arrtrunc, arrtxt, extend_string_array, AsciiDump, StringTable, asqsort, assort, PowerOf10, StrToFloat, byte_count, BrowseForFolder, cbBrowse, bin2byte_ex, bin2he, BitmapFromFile, BitmapFromMemory, BitmapFromResource, create_array, BmpButton, BmpButnProc, bstsorta, bstsortd, ccsorta, ccsortd, circle, ArgCl, ArgClC, ClearScreen, CloseMMF, ColorDialog, CreateMMF, cstsorta, cstsortd, DisplayBmp, dcisort, DisplayIcon, dsqsort, dssort, dw2a, dw2hex, exist, existW, filesize, filesizeW, FontDialog, FloatToBCD, FloatToStr, FloatToBCD2, FloatToStr2, Frame3D, FrameGrp, FrameWindow, Free, FrameCtrl, GetClipboardText, GetCL, getcl_ex, GetErrDescription, UnKnown, GetFile, GetFileProc, ListProc, GetIP, GetIPProc, GetTextInput, GetTextProc, hex2bin, HexDump, hex_table, hexflip32, IPtoString, line, LoadList, locate, load_drives, ltoa, ltok, NameFromPathW, OpenFileDialog, PageSetupDialog, GetPathOnlyW, PrintDialog, nrQsortA, nrQsortD, qssorta, qssortd, read_disk_file, read_disk_fileW, readline, Read_File_In, ofCallback, Write_To_Disk, sfCallback, RetFontHandle, ret_key, RichEd1, RichEd2, run_synch_process_ex, run_synch_process, SaveFileDialog, SetBMcolor, SetClipboardText, shell, shell_ex, ssorta, ssortd, StdErr, StdErrW, StdIn, StdInW, StdOut, StdOutW, StrLen, szCatStr, szCmp, szWcnt, ucArgByNum, ucCmdTail, ucFind, ucGetCl, ucgetline, ucLower, ucLtrim either use complicated Win32 API functions or weird ASM shit, so they aren't portably implementable. Those after ucMid will be done later.