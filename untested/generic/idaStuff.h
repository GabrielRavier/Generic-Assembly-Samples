#include <cstdint>
#include <cmath>
#include <climits>
#ifdef _MSC_VER
#include <intrin.h>
#endif

#ifndef M_PI
	#define M_PI 3.14159265358979323846264338327950288
#endif

#define attrConst __attribute__((const));
#define attrPure __attribute__((pure));

#if defined(__GNUC__)
	typedef          long long ll;
	typedef unsigned long long ull;
	#define __int64 long long
	#define __int16 short
	#define __int8  char
	#define MAKELL(num) num ## LL
	#define FMT_64 "ll"
#elif defined(_MSC_VER)
	typedef          __int64 ll;
	typedef unsigned __int64 ull;
	#define MAKELL(num) num ## i64
	#define FMT_64 "I64"
#elif defined (__BORLANDC__)
	typedef          __int64 ll;
	typedef unsigned __int64 ull;
	#define MAKELL(num) num ## i64
	#define FMT_64 "L"
#else
	#error "unknown compiler"
#endif
typedef unsigned int uint;
typedef unsigned char uchar;
typedef unsigned short ushort;
typedef unsigned long ulong;

typedef int8_t int8;
typedef int8_t sint8;
typedef uint8_t uint8;
typedef int16_t int16;
typedef int16_t sint16;
typedef uint16_t uint16;
typedef int32_t int32;
typedef int32_t sint32;
typedef uint32_t uint32;
typedef int64_t int64;
typedef int64_t sint64;
typedef uint64_t uint64;

// Partially defined types. They are used when the decompiler does not know
// anything about the type except its size.
#define _BYTE  uint8
#define _WORD  uint16
#define _DWORD uint32
#define _QWORD uint64
#if !defined(_MSC_VER)
	#define _LONGLONG __int128
#endif

// Non-standard boolean types. They are used when the decompiler can not use
// the standard "bool" type because of the size mistmatch but the possible
// values are only 0 and 1. See also 'BOOL' type below.
typedef int8 _BOOL1;
typedef int16 _BOOL2;
typedef int32 _BOOL4;

#ifndef _WINDOWS_
	typedef int BOOL;       // uppercase BOOL is usually 4 bytes
#endif
typedef int64 QWORD;
#ifndef __cplusplus
	typedef int bool;       // we want to use bool in our C programs
#endif

#ifdef __GNUC__
#define __pure __attribute__((const))
#else
#define __pure          // pure function: always returns the same value, has no
                        // side effects
#endif

// Non-returning function
#if defined(__GNUC__)
	#define __noreturn  __attribute__((noreturn))
#else
	#define __noreturn  __declspec(noreturn)
#endif


#ifndef NULL
	#define NULL 0
#endif

// Some convenience macros to make partial accesses nicer
// first unsigned macros:
#define LOBYTE(x)   (*((uint8*)&(x)))
#define LOWORD(x)   (*((uint16*)&(x)))
#define HIBYTE(x)   (*((uint8*)&(x)+1))
#define HIWORD(x)   (*((uint16*)&(x)+1))
#define LODWORD(x)  (*((_DWORD*)&(x)))  // low dword
#define HIDWORD(x)  (*((_DWORD*)&(x)+1))
#define BYTEn(x, n)   (*((_BYTE*)&(x)+n))
#define WORDn(x, n)   (*((_WORD*)&(x)+n))
#define BYTE1(x)   BYTEn(x,  1)         // byte 1 (counting from 0)
#define BYTE2(x)   BYTEn(x,  2)
#define BYTE3(x)   BYTEn(x,  3)
#define BYTE4(x)   BYTEn(x,  4)
#define BYTE5(x)   BYTEn(x,  5)
#define BYTE6(x)   BYTEn(x,  6)
#define BYTE7(x)   BYTEn(x,  7)
#define BYTE8(x)   BYTEn(x,  8)
#define BYTE9(x)   BYTEn(x,  9)
#define BYTE10(x)  BYTEn(x, 10)
#define BYTE11(x)  BYTEn(x, 11)
#define BYTE12(x)  BYTEn(x, 12)
#define BYTE13(x)  BYTEn(x, 13)
#define BYTE14(x)  BYTEn(x, 14)
#define BYTE15(x)  BYTEn(x, 15)
#define WORD1(x)   WORDn(x,  1)
#define WORD2(x)   WORDn(x,  2)         // third word of the object, unsigned
#define WORD3(x)   WORDn(x,  3)
#define WORD4(x)   WORDn(x,  4)
#define WORD5(x)   WORDn(x,  5)
#define WORD6(x)   WORDn(x,  6)
#define WORD7(x)   WORDn(x,  7)

// now signed macros (the same but with sign extension)
#define SLOBYTE(x)   (*((int8*)&(x)))
#define SLOWORD(x)   (*((int16*)&(x)))
#define SLODWORD(x)  (*((int32*)&(x)))
#define SHIBYTE(x)   (*((int8*)&(x)+1))
#define SHIWORD(x)   (*((int16*)&(x)+1))
#define SHIDWORD(x)  (*((int32*)&(x)+1))
#define SBYTEn(x, n)   (*((int8*)&(x)+n))
#define SWORDn(x, n)   (*((int16*)&(x)+n))
#define SBYTE1(x)   SBYTEn(x,  1)
#define SBYTE2(x)   SBYTEn(x,  2)
#define SBYTE3(x)   SBYTEn(x,  3)
#define SBYTE4(x)   SBYTEn(x,  4)
#define SBYTE5(x)   SBYTEn(x,  5)
#define SBYTE6(x)   SBYTEn(x,  6)
#define SBYTE7(x)   SBYTEn(x,  7)
#define SBYTE8(x)   SBYTEn(x,  8)
#define SBYTE9(x)   SBYTEn(x,  9)
#define SBYTE10(x)  SBYTEn(x, 10)
#define SBYTE11(x)  SBYTEn(x, 11)
#define SBYTE12(x)  SBYTEn(x, 12)
#define SBYTE13(x)  SBYTEn(x, 13)
#define SBYTE14(x)  SBYTEn(x, 14)
#define SBYTE15(x)  SBYTEn(x, 15)
#define SWORD1(x)   SWORDn(x,  1)
#define SWORD2(x)   SWORDn(x,  2)
#define SWORD3(x)   SWORDn(x,  3)
#define SWORD4(x)   SWORDn(x,  4)
#define SWORD5(x)   SWORDn(x,  5)
#define SWORD6(x)   SWORDn(x,  6)
#define SWORD7(x)   SWORDn(x,  7)


// Helper functions to represent some assembly instructions.

#ifdef __cplusplus

// check that unsigned multiplication does not overflow
template<class T> bool is_mul_ok(T count, T elsize)
{
	static_assert((T)(-1) > 0); // make sure T is unsigned
	if ( elsize  == 0 || count == 0 )
		return true;
	return count <= ((T)(-1)) / elsize;
}

// multiplication that saturates (yields the biggest value) instead of overflowing
// such a construct is useful in "operator new[]"
template<class T> T saturated_mul(T count, T elsize)
{
	return is_mul_ok(count, elsize) ? count * elsize : T(-1);
}

#include <stddef.h> // for size_t

// memcpy() with determined behavoir: it always copies
// from the start to the end of the buffer
// note: it copies byte by byte, so it is not equivalent to, for example, rep movsd
inline void *qmemcpy(void *__restrict dst, const void *__restrict src, size_t cnt)
{
	char *out = (char *)dst;
	const char *in = (const char *)src;
	while ( cnt > 0 )
	{
		*out++ = *in++;
		--cnt;
	}
	return dst;
}

template <typename T> void memsetType(T *dest, T fill, size_t numElem)
{
	for (size_t i = 0; i < numElem; ++i)
		dest[i] = fill;
}

// Generate a reference to pair of operands
template<class T>  int16 __PAIR__( int8  high, T low) { return ((( int16)high) << sizeof(high)*8) | uint8(low); }
template<class T>  int32 __PAIR__( int16 high, T low) { return ((( int32)high) << sizeof(high)*8) | uint16(low); }
template<class T>  int64 __PAIR__( int32 high, T low) { return ((( int64)high) << sizeof(high)*8) | uint32(low); }
template<class T> uint16 __PAIR__(uint8  high, T low) { return (((uint16)high) << sizeof(high)*8) | uint8(low); }
template<class T> uint32 __PAIR__(uint16 high, T low) { return (((uint32)high) << sizeof(high)*8) | uint16(low); }
template<class T> uint64 __PAIR__(uint32 high, T low) { return (((uint64)high) << sizeof(high)*8) | uint32(low); }

// rotate left
template<class T> T __ROL__(T value, int count)
{
	const uint nbits = sizeof(T) * 8;
	
	if ( count > 0 )
	{
		count %= nbits;
		T high = value >> (nbits - count);
		if ( T(-1) < 0 ) // signed value
			high &= ~((T(-1) << count));
		value <<= count;
		value |= high;
	}
	else
	{
		count = -count % nbits;
		T low = value << (nbits - count);
		value >>= count;
		value |= low;
	}
	return value;
}

inline uint8  __ROL1__(uint8  value, int count) { return __ROL__((uint8)value, count); }
inline uint16 __ROL2__(uint16 value, int count) { return __ROL__((uint16)value, count); }
inline uint32 __ROL4__(uint32 value, int count) { return __ROL__((uint32)value, count); }
inline uint64 __ROL8__(uint64 value, int count) { return __ROL__((uint64)value, count); }
inline uint8  __ROR1__(uint8  value, int count) { return __ROL__((uint8)value, -count); }
inline uint16 __ROR2__(uint16 value, int count) { return __ROL__((uint16)value, -count); }
inline uint32 __ROR4__(uint32 value, int count) { return __ROL__((uint32)value, -count); }
inline uint64 __ROR8__(uint64 value, int count) { return __ROL__((uint64)value, -count); }

// carry flag of left shift
template<class T> bool __MKCSHL__(T value, uint count)
{
	const uint nbits = sizeof(T) * 8;
	count %= nbits;
	
	return (value >> (nbits-count)) & 1;
}

// carry flag of right shift
template<class T> bool __MKCSHR__(T value, uint count)
{
	return (value >> (count-1)) & 1;
}

// sign flag
template<class T> bool __SETS__(T x)
{
	if ( sizeof(T) == 1 )
		return int8(x) < 0;
	if ( sizeof(T) == 2 )
		return int16(x) < 0;
	if ( sizeof(T) == 4 )
		return int32(x) < 0;
	return int64(x) < 0;
}

// overflow flag of subtraction (x-y)
template<class T, class U> bool __OFSUB__(T x, U y)
{
	if ( sizeof(T) < sizeof(U) )
	{
		U x2 = x;
		int8 sx = __SETS__(x2);
		return (sx ^ __SETS__(y)) & (sx ^ __SETS__(x2-y));
	}
	else
	{
		T y2 = y;
		int8 sx = __SETS__(x);
		return (sx ^ __SETS__(y2)) & (sx ^ __SETS__(x-y2));
	}
}

// overflow flag of addition (x+y)
template<class T, class U> bool __OFADD__(T x, U y)
{
	if ( sizeof(T) < sizeof(U) )
	{
		U x2 = x;
		int8 sx = __SETS__(x2);
		return ((1 ^ sx) ^ __SETS__(y)) & (sx ^ __SETS__(x2+y));
	}
	else
	{
		T y2 = y;
		int8 sx = __SETS__(x);
		return ((1 ^ sx) ^ __SETS__(y2)) & (sx ^ __SETS__(x+y2));
	}
}

// carry flag of subtraction (x-y)
template<class T, class U> bool __CFSUB__(T x, U y)
{
	int size = sizeof(T) > sizeof(U) ? sizeof(T) : sizeof(U);
	if ( size == 1 )
		return uint8(x) < uint8(y);
	if ( size == 2 )
		return uint16(x) < uint16(y);
	if ( size == 4 )
		return uint32(x) < uint32(y);
	return uint64(x) < uint64(y);
}

// carry flag of addition (x+y)
template<class T, class U> bool __CFADD__(T x, U y)
{
	int size = sizeof(T) > sizeof(U) ? sizeof(T) : sizeof(U);
	if ( size == 1 )
		return uint8(x) > uint8(x+y);
	if ( size == 2 )
		return uint16(x) > uint16(x+y);
	if ( size == 4 )
		return uint32(x) > uint32(x+y);
	return uint64(x) > uint64(x+y);
}

#else
// The following definition is not quite correct because it always returns
// uint64. The above C++ functions are good, though.
#define __PAIR__(high, low) (((uint64)(high)<<sizeof(high)*8) | low)
// For C, we just provide macros, they are not quite correct.
#define __ROL__(x, y) __rotl__(x, y)      // Rotate left
#define __ROR__(x, y) __rotr__(x, y)      // Rotate right
#define __CFSHL__(x, y) invalid_operation // Generate carry flag for (x<<y)
#define __CFSHR__(x, y) invalid_operation // Generate carry flag for (x>>y)
#define __CFADD__(x, y) invalid_operation // Generate carry flag for (x+y)
#define __CFSUB__(x, y) invalid_operation // Generate carry flag for (x-y)
#define __OFADD__(x, y) invalid_operation // Generate overflow flag for (x+y)
#define __OFSUB__(x, y) invalid_operation // Generate overflow flag for (x-y)
#endif

// Check windows
#if _WIN32 || _WIN64
#if _WIN64
	#define ENVIRONMENT64
#else
	#define ENVIRONMENT32
#endif
#endif

// Check GCC
#if __GNUC__
#if __x86_64__ || __ppc64__
	#define ENVIRONMENT64
#else
	#define ENVIRONMENT32
#endif
#endif

#ifndef _countof
#if __cplusplus >= 201103L || (defined(_MSC_VER) && _MSC_VER >= 1900)
template <typename T, size_t N> constexpr size_t _countof(T const (&)[N]) noexcept
{
    return N;
}

// For dynamic containers
template <class C> size_t _countof(C const& arr)
{
    return arr.size();
}
#elif __cplusplus >= 199711L
template <typename T, size_t N> char (&COUNTOF_REQUIRES_ARRAY_ARGUMENT(T(&)[N]))[N];
#define _countof(arr) sizeof(COUNTOF_REQUIRES_ARRAY_ARGUMENT(x))
#else
#define _countof(arr) (sizeof(arr) / sizeof((arr)[0]))
#endif
#endif

#include <sys/types.h>	// For ssize_t
#if defined(_MSC_VER)
#include <BaseTsd.h>
typedef SSIZE_T ssize_t;	// For some demented reason MSVC doesn't have ssize_t
#endif

#ifndef __GNUC__

#ifdef _MSC_VER

constexpr inline size_t __builtin_ctz(uint32_t mask)
{
	unsigned long index = 0;
	
	if (_BitScanForward(&index, mask))
		return index;
	else
		return 32;
}

constexpr inline size_t __builtin_clz(uint32_t mask)
{
	unsigned long index = 0;
	
	if (_BitScanReverse(&index, mask)
		return 31 - index;
	else
		return 32;
}

#else

constexpr inline size_t __builtin_ctz(uint32_t mask)
{
	int32_t t = (!(mask & 0xFFFF)) << 4;	// If (mask has no small bits) t = 16 else 0
	
	mask >>= t;	// mask = [0 - 0xFFFF] + higher garbage bits
	
	uint32_t r = t;	// r = [0, 16]
	
	t = (!(mask & 0xFF)) << 3;
	mask >>= t;	// mask = [0 - 0xFF] + higher garbage bits
	r += t;	// r = [0, 8, 16, 24]
	
	t = (!(mask & 0xF)) << 2;
	mask >>= t;	// mask = [0 - 0xF] + higher garbage bits
	r += t;	// r = [0, 4, 8, 12, 16, 20, 24, 28]
	
	t = (!(mask & 3)) << 1;
	mask >>= t;
	mask &= 3;	// x = [0 - 3]
	r += t;	// r = [0 - 30] and is even
	
	/* The return statement is equivalent to :
		switch (mask)
		{
		case 0:
			return r + 2;
			
		case 2:
			return r + 1;
			
		case 1:
		case 3:
			return r;
		}
	*/
	return r + ((2 - (mask >> 1)) & -(!(mask & 1)));
}

constexpr inline size_t __builtin_clz(uint32_t mask)
{
	int32_t t = (!(mask & 0xFFFF0000)) << 4;	// If (mask is 16-bit big or less) t = 16 else 0
	
	mask >>= 16 - t;	// mask = [0 - 0xFFFF]
	
	uint32_t r = t;	// r = [0, 16]
	
	t = (!(mask & 0xFF00)) << 3;
	mask >>= 8 - t;	// mask = [0 - 0xFF]
	r += t;	// r = [0, 8, 16, 24]
	
	t = (!(mask & 0xF0)) << 2;
	mask >>= t;	// mask = [0 - 0xF]
	r += t;	// r = [0, 4, 8, 12, 16, 20, 24, 28]
	
	t = (!(mask & 0xC)) << 1;
	mask >>= 2 - t;	// x = [0 - 3]
	r += t;	// r = [0 - 30] and is even
	
	/* The return statement is equivalent to :
		switch (mask)
		{
		case 0:
			return r + 2;
			
		case 2:
			return r + 1;
			
		case 1:
		case 3:
			return r;
		}
	*/
	return r + ((2 - mask) & -(!(mask & 2)));
}

#endif

constexpr inline size_t __builtin_ctzll(uint64_t mask)
{
	union
	{
		uint64_t all;
		struct
		{
			uint32_t low;
			uint32_t high;
		};
	} x = {mask};
	
	x.all = mask;
	const int32_t f = -(!x.low);
	return __builtin_clz((x.high & f) | (x.low & ~f)) + (f & ((int32_t)(sizeof(int32_t) * CHAR_BIT)));
}

constexpr inline size_t __builtin_clzll(uint64_t mask)
{
	union
	{
		uint64_t all;
		struct
		{
			uint32_t low;
			uint32_t high;
		};
	} x = {mask};
	
	x.all = mask;
	const int32_t f = -(!x.high);
	return __builtin_clz((x.high & ~f) | (x.low & f)) + (f & ((int32_t)(sizeof(int32_t) * CHAR_BIT)));
}

#endif

constexpr inline size_t bsf(uint32_t mask)
{
	return __builtin_ctz(mask);
}

constexpr inline size_t bsr(uint32_t mask)
{
	return ((sizeof(uint32_t) * CHAR_BIT) - 1)  - __builtin_clz(mask);
}

constexpr inline size_t bsf64(uint64_t mask)
{
	return __builtin_ctzll(mask);
}

constexpr inline size_t bsr64(uint64_t mask)
{
	return ((sizeof(uint64_t) * CHAR_BIT) - 1) - __builtin_clzll(mask);
}

template <typename T> inline bool bitTest(T a, size_t b)
{
	return (a >> b) & 1;
}

// No definition for rcl/rcr because the carry flag is unknown
#define __RCL__(x, y)    invalid_operation // Rotate left thru carry
#define __RCR__(x, y)    invalid_operation // Rotate right thru carry
#define __MKCRCL__(x, y) invalid_operation // Generate carry flag for a RCL
#define __MKCRCR__(x, y) invalid_operation // Generate carry flag for a RCR
#define __SETP__(x, y)   invalid_operation // Generate parity flag for (x-y)
#define __int8 char
#define __int16 short
#define __int64 long long