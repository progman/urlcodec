//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// 0.0.1
// Alexey Potehin <gnuplanet@gmail.com>, http://www.gnuplanet.ru/doc/cv
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "submodule/libcore.cpp/libcore.hpp"
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// URL decode
void url_decode()
{
	int ch1, ch2;
	uint8_t r1, r2, out;


// read from stdin, convert to bin, write to stdout
	for (;;)
	{
		ch1 = getchar();
		if (ch1 == EOF) break;


		if (ch1 != '%')
		{
			out = ch1;
		}
		else
		{
			ch1 = getchar();
			if (ch1 == EOF) break;

			ch2 = getchar();
			if (ch2 == EOF) break;

			if (libcore::hex2bin((uint8_t)ch1, r1) == false) break;
			if (libcore::hex2bin((uint8_t)ch2, r2) == false) break;

			out = (uint8_t)((r1 << 4) + r2);
		}

		putchar(out);
	}
	fflush(stdout);
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// URL encode
void url_encode()
{
// read from stdin, convert to hex, write to stdout
	for (;;)
	{
		int ch = getchar();
		if (ch == EOF) break;

		const char *p = libcore::bin2hex((uint8_t)ch);

		putchar('%');

		putchar(*p);
		p++;
		putchar(*p);
	}
	fflush(stdout);
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// general function
int main(int argc, char *argv[])
{
	bool flag_decode = false;
	bool flag_encode = false;


	if (argc == 1)
	{
		flag_decode = true;
	}
	else
	{
		if (strcmp(argv[1], "-d") == 0)
		{
			flag_decode = true;
		}

		if (strcmp(argv[1], "-e") == 0)
		{
			flag_encode = true;
		}
	}


	if (flag_decode == true)
	{
		url_decode();
		return 0;
	}


	if (flag_encode == true)
	{
		url_encode();
		return 0;
	}


	printf("%s    %s\n", PROG_FULL_NAME, PROG_URL);
	printf("example: echo \"Hello%%20world%%21\" | %s [--d]\n", argv[0]);
	printf("         echo \"Hello%%20world%%21\" | %s --e\n", argv[0]);
	printf("\n");


	return 1;
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
