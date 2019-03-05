void detab(char *buf)
{
	for (int i = *buf; *buf; i = *buf)
	{
		if ( i == '\t' )
			*buf = ' ';
		++buf;
	}
}