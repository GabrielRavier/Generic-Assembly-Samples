void detab(char *a1)
{
  char *v1;
  int i;

  v1 = a1;
  for ( i = *a1; *v1; i = *v1 )
  {
    if ( i == '\t' )
      *v1 = ' ';
    ++v1;
  }
}