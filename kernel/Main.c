#include "Common.h"

void Print(int x, int y, const char* string, BYTE attr);

void main(void)
{
	DWORD* Videomemory = (DWORD*) 0xB8000;
	for (int loop = 0; loop < 4000; loop++)
	{
		*Videomemory = 0x00;
		Videomemory++;
	}
	Print(0, 0, "Welcome to the C kernel world. Write in C.", 0x0F);
	while(TRUE);
}

void Print(int x, int y, const char* string, BYTE attr)
{
	VideoChar* Video = (VideoChar*) 0xB8000;
	Video += (80 * y) + x;
	for (int loop = 0; string[loop] != 0; loop++)
	{
		Video[loop].Char = string[loop];
		Video[loop].Attr = attr;
	}
}