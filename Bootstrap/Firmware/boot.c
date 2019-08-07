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

#define SYSTEMBASE 0xFFFFFFC8
#define HW_SYSTEM(x) *(volatile unsigned int *)(SYSTEMBASE+x)
#define REG_SYSCONTROL 0

// #define puts(x) 
void _boot();
void _break();

extern fileTYPE file;
extern unsigned char sector_buffer[512];       // sector buffer

struct BIOSTag
{
	char sig[4];
	char sdsize[4];
	char is_sdhc;
};

int SendFile(const char *fn)
{
	if(FileOpen(&file,fn))
	{
		int imgsize=(file.size+511)/512;
		int c=0;
		int sector=0;
		int i;
		struct BIOSTag *tag=(struct BIOSTag *)sector_buffer;
		while(c<imgsize)
		{
			if(!FileRead(&file,sector_buffer))
				return(0);
			if(c==0)
			{
				if(tag->sig[0]=='1' && tag->sig[1]=='8' && tag->sig[2]=='6' && tag->sig[3]==0)
				{
					int size=sd_size;
					puts("Found tag\n");
					tag->is_sdhc=sd_is_sdhc;
					tag->sdsize[0]=size&255; size>>=8;
					tag->sdsize[1]=size&255; size>>=8;
					tag->sdsize[2]=size&255; size>>=8;
					tag->sdsize[3]=size&255;
				}
				else
					puts("No tag!\n");
			}

			for(i=0;i<512;++i)
			{
				putchar2(sector_buffer[i]);
				if((c==(imgsize-1)) && (i==511))
					HW_SYSTEM(REG_SYSCONTROL)=0;	// Release the SD card
			}
			++c;
			if(c<imgsize)
				FileNextSector(&file);
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

