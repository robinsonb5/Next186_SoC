/*	Firmware for loading files from SD card.
	Part of the ZPUTest project by Alastair M. Robinson.
	SPI and FAT code borrowed from the Minimig project.

	This boot ROM ends up stored in the ZPU stack RAM
	which in the current incarnation of the project is
	memory-mapped to 0x04000000
	Halfword and byte writes to the stack RAM aren't
	currently supported in hardware, so if you use
    hardware storeh/storeb, and initialised global
    variables in the boot ROM should be declared as
    int, not short or char.
	Uninitialised globals will automatically end up
	in SDRAM thanks to the linker script, which in most
	cases solves the problem.
*/


#include "stdarg.h"

#include "uart.h"
#include "spi.h"
#include "minfat.h"
#include "small_printf.h"

// #define puts(x) 
void _boot();
void _break();

extern fileTYPE file;
extern unsigned char sector_buffer[512];       // sector buffer

int SendFile(const char *fn)
{
	if(FileOpen(&file,fn))
	{
		int imgsize=(file.size+511)/512;
		int c=0;
		int sector=0;
		int i;

		while(c<imgsize)
		{
			if(!FileRead(&file,sector_buffer))
				return(0);

			for(i=0;i<512;++i)
				putchar2(sector_buffer[i]);

			FileNextSector(&file);

			++c;
		}
	}
	else
	{
		puts("Can't open file\n");
		return(0);
	}
	return(1);
}

int main(int argc,char **argv)
{
	int i;

	puts("Initializing SD card\n");
	if(spi_init())
	{
		puts("Hunting for partition\n");
		FindDrive();
		if(SendFile("BIOSNEXT186"))
		{
			puts("BIOS Sent\n");
		}
		else
		{
			puts("BIOS Load failed\n");
		}
	}
	return(0);
}

