// Just returns 1 on x64 we always have cpuid there

bool isCpuidAvailable()
{
  unsigned int initialFlags; // et0@1 MAPDST
  unsigned int flagsAfterWrite; // et0@1

  initialFlags = __readeflags();
  __writeeflags(initialFlags ^ 0x200000);
  flagsAfterWrite = __readeflags();
  __writeeflags(initialFlags);
  return initialFlags != flagsAfterWrite;
}