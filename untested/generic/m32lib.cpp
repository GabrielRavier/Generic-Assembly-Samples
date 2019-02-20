#include <cstddef>
#include <cstdarg>
#include <cstring>
#include <cmath>
#include <cwchar>
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
	int result;
	
	for ( size_t i = lstrlenA(str); i; --i )
	{
		auto lp = i - 1;
		int current = (uint8_t)(*str - 48);
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
	void **result = &arr[cnt];
	for (size_t i = -1 * cnt; i * 4; ++i)
		result[i] = (void *)((uintptr_t)result[i] + plus);
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
	return *((uintptr_t *)arr[indx] - 1);
}

void **arr_mul(void **arr, size_t cnt, int mult)
{
	void **result = &arr[cnt];
	for (size_t i = -1 * cnt; i * 4; ++i)
		result[i] = (void *)((uintptr_t)result[i] * mult);
	return result;
}

void **arr_sub(void **arr, size_t cnt, int sub)
{
	void **result = &arr[cnt];
	for (size_t i = -1 * cnt; i * 4; ++i)
		result[i] = (void *)((uintptr_t)result[i] - sub);
	return result;
}

char *arrtotal(void **arr, bool crlf)
{
	char *thisIsStupid = (char *)*arr;
	char *total = NULL;
	ssize_t i = 1;
	
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
	uint32_t retVal = 0;
	int32_t weirdThingo = 0;
	uint8_t currentCharacter = *string;
	const char *ptr = string + 1;
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
	bool isNegative = false;
	unsigned long currentCharacter = *str;
	const char *ptr = str + 1;
	if ( currentCharacter == '-' )
	{
		isNegative = true;
		currentCharacter = *ptr;
		ptr = str + 2;
	}
	long result = 0;
	while ( 1 )
	{
		bool isInvalid = currentCharacter < '0';
		long convertedChar = currentCharacter - '0';
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

uint8_t byt2bin_ex(uint8_t var, char *buffer)
{
	*(uint32_t *)buffer = bintable[2 * var];
	*((uint32_t *)buffer + 1) = bintable[2 * var + 1];
	buffer[8] = 0;
	return var;
}

ptrdiff_t BMBinSearch(size_t startpos, uint8_t *src, ssize_t srcLength, uint8_t *subStr, ssize_t subLength)
{
	ssize_t shiftTable[0x100];
	
	if ( subLength <= 1 )
		return -2;
	
	memsetType(shiftTable, subLength, _countof(shiftTable));
	ssize_t subLengthMin1 = subLength - 1;
	uint8_t *currentSubPtr = subStr;
	uint8_t currentBufferOffset = 0;
	
	do
	{
		currentBufferOffset = *currentSubPtr++;
		shiftTable[currentBufferOffset] = subLengthMin1--;
	} while ( subLengthMin1 );
	
	subLengthMin1 = subLength - 1;
	ssize_t savedSubLengthMin1 = subLength - 1;
	uint8_t *i = &src[startpos];
	
	ssize_t weirdThingo;
	do
	{
		uint8_t currentIByte = i[subLengthMin1];
		uint8_t currentIByte2 = 0;
		ssize_t currentBufferByte = shiftTable[currentIByte2];
			
		if ( currentIByte == subStr[subLengthMin1] )
		{
			--subLengthMin1;
			
			while ( 1 )
			{
				currentIByte2 = i[subLengthMin1];
				if ( currentIByte2 != subStr[subLengthMin1] )
					break;
				if ( --subLengthMin1 < 0 )
					return i - src;
			}
			
			
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

uint8_t *BinSearch(int stpos, uint8_t *src, ssize_t slen, uint8_t *patn, ssize_t plen)
{
	ssize_t slenMinPlen = slen - plen;
	uint8_t *result;
	if ( slen - plen < 0 )
		result = (uint8_t *)-2;
	else if ( stpos > slenMinPlen )
		result = (uint8_t *)-3;
	else
	{
		uint8_t *srcSlenMinPlen = &src[slenMinPlen];
		ssize_t plenMin1 = plen - 1;
		uint8_t *srcStPosMin1 = &src[stpos - 1];
		while ( (intptr_t)++srcStPosMin1 <= (intptr_t)srcSlenMinPlen )
		{
			if ( *srcStPosMin1 == *patn )
			{
				ssize_t i = -1;
				while ( 1 )
				{
					++i;
					if ( srcStPosMin1[i] != patn[i] )
						break;
					if ( i == plenMin1 )
						return (uint8_t *)(srcStPosMin1 - src);
				}
			}
		}
		result = (uint8_t *)-1;
	}
	return result;
}

constexpr uint8_t Cmpi_tbl[0x100] =
{
	0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122, 91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127, 128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143, 144,145,146,147,148,149,150,151,152,153,154,155,156,156,158,159, 160,161,162,163,164,165,166,167,168,169,170,171,172,173,173,175, 176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191, 192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207, 208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223, 224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239, 240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,
};

size_t Cmpi(uint8_t *src,uint8_t *dst)
{
	int i = 0;
	while ( 1 )
	{
		uint8_t currentDstByte = dst[i];
		uint8_t currentCmpiSrcByte = Cmpi_tbl[src[i++]];
		if ( currentCmpiSrcByte != Cmpi_tbl[currentDstByte] )
			break;
		if ( !currentCmpiSrcByte )
			return 0;
	}
	return i;
}

void CombSortA(int32_t *arr, ssize_t arraySize)
{
	ssize_t arraySizeMin1  = arraySize - 1;
	size_t swaps;
	do
	{
		double funWithFloatingPoint = (double)arraySize / 1.3;
		arraySize = (signed int)funWithFloatingPoint - 1;
		if ( (signed int)funWithFloatingPoint == 1 )
			arraySize = 1;
		
		swaps = 0;
		ssize_t i = 0;
		
		do
		{
			int32_t toBeCompared2 = arr[i];
			int32_t toBeCompared = arr[arraySize + i];
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
	ssize_t arraySizeMin1 = arraySize - 1;
	
	ssize_t swaps;
	do
	{
		double funWithFloatingPoint = (double)arraySize / 1.3;
		arraySize = (signed int)funWithFloatingPoint - 1;
		if ( (signed int)funWithFloatingPoint == 1 )
			arraySize = 1;
		
		swaps = 0;
		ssize_t i = 0;
		
		do
		{
			int32_t toBeCompared = arr[i];
			int32_t toBeCompared2 = arr[arraySize + i];
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
	ssize_t i;	
	ssize_t arrIter = -1;
	
	for (i = 0; ; i = arrIter )
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
	char last = src[i];
	
	int8_t result;
	if ( last == ',' )
		result = 1;
	else
		result = last == '\\';
	return result;
}

void dissort(const char **arr, ssize_t cnt)
{
	for ( ssize_t i = 1; i < cnt; ++i )
	{
		const char *swapittySwapped = arr[i];
		ssize_t j = i;
		
inner:
		const char *arrayiThingo = arr[j - 1];
		ssize_t k = -1;
		
		char comparedThingo;
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
	*((uint16_t *)buffer + 4) = 'H';
	char *revBuf = buffer + 7;
	do
	{
		uint8_t andedVal = value & 0xF;
		
		uint8_t tmp;
		if ( (value & 0xF) >= 0xA )
			tmp = andedVal + '7';
		else
			tmp = andedVal + '0';
		*revBuf-- = tmp;
		value = __ROR4__(value, 4);
	} while ( revBuf >= buffer );
}

void dw2bin_ex(int var, char *buffer)
{	
	uint8_t tmp = BYTE3(var);
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
	uint32_t tmp = *(uint32_t *)&hex_table[(uint8_t)src] << 16;
	LOWORD(tmp) = hex_table[BYTE1(src)];
	*((uint32_t *)buf + 1) = tmp;
	tmp = *(uint32_t *)&hex_table[BYTE2(src)] << 16;
	LOWORD(tmp) = hex_table[BYTE3(src)];
	*(uint32_t *)buf = tmp;
	buf[8] = 0;
}

void dwtoa(int32_t value, char *buffer)
{
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
		
		char *origBuffer = buffer;
		
		while ( value )
		{
			int32_t tmpVal = value;
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

size_t get_line_count(char *mem, size_t blen)
{	
	if ( *(uint16_t *)&mem[blen - 2] != '\n\r' )
	{
		*(uint16_t *)&mem[blen] = '\n\r';
		mem[blen + 2] = 0;
	}
	
	ssize_t i = -1;
	size_t result = 0;
	
	while ( mem[++i] )
	{
		if ( mem[i] == '\n' )
			++result;
	}
	
	return result;
}

size_t get_ml(const char *src, char *dst, size_t rpos)
{
	size_t bsflag = 0;
	const char *srcPlusRpos = &src[rpos];
	size_t i = 0;
	size_t k = 0;
	size_t l = 0;
	size_t result;
	char tmpChar;
	
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
					tmpChar = srcPlusRpos[i++];
					if ( !tmpChar )
						break;
					if ( tmpChar == '\n' )
						goto leadTrim;
				}
			}
			else
			{
				size_t j = i - 1;
				
				while ( 1 )
				{
					do
					{
mainText:	
						tmpChar = srcPlusRpos[j++];
						if ( !tmpChar )
							goto setEnd;
					} while ( tmpChar == '\r' );
					
					if ( tmpChar == '\n' )
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
					
					if ( tmpChar == ';' )
						break;
					
					if ( tmpChar == '"' )
					{
						dst[k++] = '"';
						while ( 1 )
						{
							tmpChar = srcPlusRpos[j++];
							dst[k++] = tmpChar;
							
							if ( !tmpChar || tmpChar == '\n' )
								goto qtError;
							
							if ( tmpChar == '"' )
							{
fTrim:
								while ( 1 )
								{
									tmpChar = srcPlusRpos[j++];
									
									if ( !tmpChar )
										goto setEnd;
									
									if ( tmpChar > ' ' )
									{
										--j;
										goto mainText;
									}
								}
							}
						}
					}
					if ( tmpChar == '\'' )
					{
						dst[k++] = '\'';
						
						while ( 1 )
						{
							tmpChar = srcPlusRpos[j++];
							dst[k++] = tmpChar;
							
							if ( !tmpChar || tmpChar == '\n' )
								break;
							
							if ( tmpChar == '\'' )
								goto fTrim;
						}
qtError:		
						result = -1;
						goto lastByte;
					}
					if ( tmpChar > ' ' )
					{
						l = j;
						bsflag = k;
					}
					dst[k++] = tmpChar;
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
	return (signed int)((double)percent * 0.0099999999999999999998 * (double)source);
}

void GetPathOnly(const char *src, char *dst)
{
	size_t i = 0;
	char *dstCopy = dst;
	size_t whereDoWePutTheZero = 0;
	
	while ( 1 )
	{
		char currentChar = *src++;
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
	const char *endStrPtr = str;
	while (*endStrPtr++)
		;
	
	size_t minStrlen = str - endStrPtr;
	int retVal = 0;
	char part2 = 0;
	
	for ( int i = ~minStrlen; i; --i )
	{
		char currentChar = *str;
		
		char tmpVal;
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
	ssize_t result;
	
	ssize_t sourceLen = strlen(source);
	ssize_t patternLen = strlen(pattern);
	
	if ( startPos >= 1 )
	{
		ssize_t startPosMin1 = startPos - 1;
		
		if ( patternLen < sourceLen )
		{
			ssize_t sourceLenMinPatternLenPlus1 = sourceLen - patternLen + 1;
			
			if ( sourceLenMinPatternLenPlus1 > startPosMin1 )
			{
				const char *sourcePlusSourceLenMinPatternLenPlus1 = &source[sourceLenMinPatternLenPlus1];
				ssize_t startPosMin1MinSourceLenMinPatternLenPlus1 = startPosMin1 - sourceLenMinPatternLenPlus1;
scanLoop:
				while ( *pattern != sourcePlusSourceLenMinPatternLenPlus1[startPosMin1MinSourceLenMinPatternLenPlus1] )
				{
					if ( ++startPosMin1MinSourceLenMinPatternLenPlus1 >= 0 )
						return 0;
				}
				
				ssize_t patternLenCpy = patternLen;
				
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
	--str;
	size_t result = 0;
	while ( *++str )
	{
		if ( *str == '\n' )
			++result;
	}
	return result;
}

void MemCopy(const void *src, void *dst, size_t count)
{
	qmemcpy(dst, src, count);
}

void memfill(void *buffer, size_t cnt, int fill)
{
	memset(buffer, fill, cnt);
}

int NameFromPath(const char *src, char *dst)
{
	size_t j = (size_t)src;
	ssize_t i = -1;
	
	while ( src[++i] )
	{
		if ( src[i] == '\\' )
			j = i;
	}
	
	int result;
	if ( j == (size_t)src )
		result = -1;
	else
	{
		const char *srcPtr = &src[j + 1];
		strcpy(dst, srcPtr);
		result = 0;
	}
	return result;
}

int nrandom_seed = 12345678;

uint32_t nrandom(uint32_t base)
{
	uint32_t tmp = nrandom_seed;
	if ( nrandom_seed < 0 )
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
	char *firstArrayMember = *array;
	char currentChar = 0;
	int argCounter = 0;
	
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
				char currentChar2 = *src++;
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
	const char *src2 = &src[starat];
	size_t patternLength = strlen(pattern);
	size_t srcLength = strlen(src2);
	const char *patMin1 = pattern - 1;
	
	size_t fillerChars;
	for ( fillerChars = 0; *++patMin1 == '*'; ++fillerChars )
		;
	
	const char *afterFillerChars = &src2[fillerChars - 1];
	const char *exitOffset = &afterFillerChars[fillerChars] + srcLength - patternLength;
	
mainLoop:
	while ( *++afterFillerChars != *patMin1 )
	{
		if ( (intptr_t)afterFillerChars > (intptr_t)exitOffset )
			return -1;
	}
	
	ssize_t i = -1;
	
	while ( ++i <= (ssize_t)(patternLength - fillerChars - 1) )
	{
		char currentChar = patMin1[i];
		if ( currentChar != '*' && currentChar != afterFillerChars[i] )
			goto mainLoop;
	}
	
	return starat + afterFillerChars - src2 - fillerChars;
}

void RolData(uint8_t *src, size_t srcLength, uint8_t *key, size_t keyLength)
{
	uint8_t *pcnt = key;
	uint8_t bvar = *key;
	do
	{
		uint8_t currentByte = __ROL1__(*src, bvar);
		uint8_t currentKeyByte = *++pcnt;
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
	uint8_t *pcnt = key;
	uint8_t bvar = *key;
	do
	{
		uint8_t currentByte = __ROR1__(*src, bvar);
		uint8_t currentKeyByte = *++pcnt;
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

ptrdiff_t SBMBinSearch(size_t startpos, char *src, ssize_t srcLength, const char *subStr, ssize_t subStrLength)
{
	ptrdiff_t result;
	if ( subStrLength > 1 )
	{
		ssize_t shiftTable[256]; 
		memsetType(shiftTable, subStrLength, _countof(shiftTable));
		ssize_t subStrLenMin1 = subStrLength - 1;
		const char *subStrCpy = subStr;
		char currentChar = 0;
		
		do
		{
			currentChar = *subStrCpy++;
			shiftTable[currentChar] = subStrLenMin1--;
		} while ( subStrLenMin1 );
		
		ssize_t subStrLenMin1v2 = subStrLength - 1;
		char currentChar3 = 0;
		char *srcPlusStartPos = &src[startpos];
cmpLoop:
		while ( 1 )
		{
			currentChar3 = srcPlusStartPos[subStrLenMin1];
			if ( currentChar3 != subStr[subStrLenMin1] )
				break;
			if ( --subStrLenMin1 < 0 )
				return srcPlusStartPos - src;
		}
		ssize_t shiftTableThingo = shiftTable[currentChar3] + subStrLenMin1 - subStrLenMin1v2;
		if ( shiftTableThingo < 0 )
			shiftTableThingo = 1;
		
		char currentChar2;
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

void StripRangeI(const char *source, char *destination, char startByte, char endByte)
{
lpSt:
	while ( 1 )
	{
		char currentChar = *source++;
		
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
	*destination = '\0';
}

void StripRangeX(const char *source, char *destination, char startByte, char endByte)
{	
srxSt:
	while ( 1 )
	{
		char currentChar = *source++;
		if ( !currentChar )
			break;
		
		if ( currentChar == startByte )
		{
			*destination = currentChar;
			char *destPlus1 = destination + 1;
			
			while ( 1 )
			{
				char currentChar2 = *source++;
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
	ssize_t i = -1;
	int currentCharacter;
	do
	{
		currentCharacter = src[++i];
		*(&dest[location] + i) = currentCharacter;
	} while ( currentCharacter );
	return location + i;
}

ssize_t szCmp(const char *str1, const char *str2)
{
	ssize_t result = -1;
	while ( 1 )
	{
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
	size_t result = 0;
	while ( 1 )
	{
		char currentCharStr1 = str1[result];
		char currentCharStr2 = str2[result++];
		if ( szCmpi_tbl[currentCharStr1] != szCmpi_tbl[currentCharStr2] )
			break;
		if ( result >= len )
			return 0;
	}
	return result;
}

size_t szCopy(const char *src, char *dest)
{
	strcpy(dest, src);
	return strlen(src);
}

char *szLeft(const char *src, char *dest, size_t length)
{
	char *destination = &dest[length];
	size_t i = -length;
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
	return strlen(str);
}

char *szLower(char *str)
{
	char *string = str - 1;
	while ( *++string )
	{
		if ( *string >= 'A' && *string <= 'Z' )
			*string += 32;
	}
	return str;
}

size_t szLtrim(char *src, char *dest)
{	
	size_t i = 0;
	--src;
	do
	{
		do
			++src;
		while ( *src == ' ' );
	} while ( *src == '\t' );
	
	size_t result;
	if ( *src )
	{
		strcpy(dest, src);
		result = strlen(src) - 1;
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
	char *result = &dst[length];
	ssize_t revLength = -length;
	
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
	char *sourceMin1 = src - 1;
	char *source = src;
	
	int currentCharacter;
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
	va_list va;
	va_start(va, buf);
	
	size_t i = 0;
	
	do
	{
		char *currentParam = ((char **)va)[i];
		strcat(buf, currentParam);
		++i;
	} while ( i != paramCount );
	
	return buf;
}

char *szRemove(const char *src, char *dest, const char *remove)
{
	char firstRemChar = *remove;
	char *destination = dest;
	--src;
	
	while ( 1 )
	{
		++src;
		
scanLoop:
		if ( *src == firstRemChar )
		{
			size_t i = 0;
			
			while ( src[i] == remove[i] )
			{
				if ( remove[++i] )
					continue;
				
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
	size_t srcLen = strlen(src);
	const char *lastCharacter = &(src--)[srcLen - strlen(txt1) + 1];

rpst:
	ssize_t i;
	char currentChar;
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
	strcpy(dest, src);
}

char *szRev(const char *src, char *dest)
{	
	strcpy(dest, src);
	
	ssize_t i = strlen(dest);
	char *destination = &dest[--i - 1];
	i = -((size_t)i >> 1);
	char *source = &dest[-i];
	do
	{
		char currentChar = source[i];
		source[i] = *destination;
		*destination-- = currentChar;
		++i;
	} while ( i );
	
	return dest;
}

char *szRight(const char *src, char *dst, size_t len)
{
	strcpy(dst, &src[strlen(src) - len]);
	return dst;
}

size_t szRtrim(const char *src, char *dest)
{
	const char *source = src - 1;
	do
	{
		do
			++source;
		while ( *source == ' ' );
	} while ( *source == '\t' );
	
	if ( *source )
	{
		size_t i = 0;
		size_t j = 0;
		
		while ( 1 )
		{
			char currentChar = src[j];
			dest[j++] = currentChar;
			if ( !currentChar )
				break;
			if ( (unsigned char)currentChar >= 0x21 )
				i = j;
		}
		
		dest[i] = '\0';
		return i;
	}
	else
	{
		*dest = '\0';
		return 0;
	}
}

size_t szTrim(char *src)
{
	const char *source = src - 1;
	do
	{
		do
			++source;
		while ( *source == ' ' );
	} while ( *source == '\t' );
	
	if ( *source )
	{
		size_t i;
		size_t j;
		while ( 1 )
		{
			i = 0;
			j = 0;
			char currentChar = source[j];
			src[j++] = currentChar;
			if ( !currentChar )
				break;
			if ( (unsigned char)currentChar >= 0x21 )
				i = j;
		}
		src[i] = '\0';
		return i;
	}
	else
	{
		*src = '\0';
		return 0;
	}
}

char *szUpper(char *src)
{
	char *source = src - 1;
	while (*++source)
		if (islower(*source))
			*source = toupper(*source);
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
	wcscat(dest, src);
	
	return 0;
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
			return ((size_t)i * sizeof(wchar_t)) / sizeof(wchar_t);
	}
}

void ucCopy(const wchar_t *src, wchar_t *dest)
{
	wcscpy(dest, src);
}

void ucLeft(const wchar_t *src, wchar_t *dest, size_t stop)
{
	wmemcpy(dest, src, stop);
	dest[stop] = 0;
}

size_t ucLen(const wchar_t *src)
{
	return wcslen(src);
}

wchar_t *ucMultiCat(size_t paramCount, wchar_t *buffer, ...)
{
	va_list va;
	va_start(va, buffer);
	
	size_t i = 0;
	do
	{
		auto src = ((wchar_t **)va)[i];
		
		wcscat(buffer, src);
		++i;
	} while (i != paramCount);
	
	return buffer;
}

// atodw_ex, a2wc, AboutBox, AboutBoxProc, acisort, aissort, Alloc, GetAppPath, GetAppPathW, arralloc, arrbin, arrealloc, realloc_string_array, arrextnd, arrfile, arrfree, arrset, arrtrunc, arrtxt, extend_string_array, AsciiDump, StringTable, asqsort, assort, PowerOf10, StrToFloat, byte_count, BrowseForFolder, cbBrowse, bin2byte_ex, bin2he, BitmapFromFile, BitmapFromMemory, BitmapFromResource, create_array, BmpButton, BmpButnProc, bstsorta, bstsortd, ccsorta, ccsortd, circle, ArgCl, ArgClC, ClearScreen, CloseMMF, ColorDialog, CreateMMF, cstsorta, cstsortd, DisplayBmp, dcisort, DisplayIcon, dsqsort, dssort, dw2a, dw2hex, exist, existW, filesize, filesizeW, FontDialog, FloatToBCD, FloatToStr, FloatToBCD2, FloatToStr2, Frame3D, FrameGrp, FrameWindow, Free, FrameCtrl, GetClipboardText, GetCL, getcl_ex, GetErrDescription, UnKnown, GetFile, GetFileProc, ListProc, GetIP, GetIPProc, GetTextInput, GetTextProc, hex2bin, HexDump, hex_table, hexflip32, IPtoString, line, LoadList, locate, load_drives, ltoa, ltok, NameFromPathW, OpenFileDialog, PageSetupDialog, GetPathOnlyW, PrintDialog, nrQsortA, nrQsortD, qssorta, qssortd, read_disk_file, read_disk_fileW, readline, Read_File_In, ofCallback, Write_To_Disk, sfCallback, RetFontHandle, ret_key, RichEd1, RichEd2, run_synch_process_ex, run_synch_process, SaveFileDialog, SetBMcolor, SetClipboardText, shell, shell_ex, ssorta, ssortd, StdErr, StdErrW, StdIn, StdInW, StdOut, StdOutW, StrLen, szCatStr, szCmp, szWcnt, ucArgByNum, ucCmdTail, ucFind, ucGetCl, ucgetline, ucLower, ucLtrim either use complicated Win32 API functions or weird ASM shit, so they aren't portably implementable. Those after ucMid will be done later.