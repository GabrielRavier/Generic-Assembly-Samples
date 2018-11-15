// Just returns 1 on x64 we always have cpuid there


#ifdef __x86_64__
/* Read flags register */
inline uint64_t readEflags()
{
	return __builtin_ia32_readeflags_u64();
}

/* Write flags register */
inline void writeEflags(uint64_t x)
{
	__builtin_ia32_writeeflags_u64(x);
}

#else

/* Read flags register */
inline uint32_t readEflags()
{
  return __builtin_ia32_readeflags_u32();
}

/* Write flags register */
inline void writeEflags(uint32_t x)
{
	__builtin_ia32_writeeflags_u32(x);
}

#endif



bool isCpuidAvailable()
{
  unsigned int initialFlags; // et0@1 MAPDST
  unsigned int flagsAfterWrite; // et0@1

  initialFlags = readEflags();
  writeEflags(initialFlags ^ 0x200000);
  flagsAfterWrite = readEflags();
  writeEflags(initialFlags);
  return initialFlags != flagsAfterWrite;
}