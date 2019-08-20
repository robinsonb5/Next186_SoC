/*	Firmware for loading files from SD card.
	Part of the ZPUTest project by Alastair M. Robinson.
	SPI and FAT code borrowed from the Minimig project.

	This boot ROM ends up stored in the ZPU stack RAM
	memory-mapped to 0x0000000
*/


#include "stdarg.h"

#include "uart.h"
#include "spi.h"
#include "minfat.h"
#include "small_printf.h"

#define DATACHANNEL 0xFFFFFFCC
#define HW_DATACHANNEL(x) (*(volatile unsigned int *)(DATACHANNEL+x))
#define DC_HANDSHAKE 0x100

#define DC_NOP 0x80
#define DC_BOOTSTRAP 0x81
#define DC_READCAPACITY 0x82
#define DC_READBLOCK 0x83
#define DC_WRITEBLOCK 0x84

#define SYSTEMBASE 0xFFFFFFC8
#define HW_SYSTEM(x) *(volatile unsigned int *)(SYSTEMBASE+x)
#define REG_SYSCONTROL 0

// #define puts(x) 
void _boot();
void _break();

extern fileTYPE file;
extern unsigned char sector_buffer[512];       // sector buffer

static int parity;

int dc_handshake()
{
	int t;
	while(((t=HW_DATACHANNEL(0))&DC_HANDSHAKE)==parity)
		;
	parity^=DC_HANDSHAKE;
	return(t&~DC_HANDSHAKE);
}

#define dc_send(x) HW_DATACHANNEL(0)=(((x)&255)|parity);

int SendFile(const char *fn)
{
	int t;
	int i;
	int lba;
	int count;
	parity=0;

	while(1)
	{
		int cmd=dc_handshake();

		switch(cmd)
		{
			case DC_NOP:
				puts("Got NOP\n");
				dc_send(cmd);	// Echo command back to PC
				break;

			case DC_READBLOCK:
				puts("ReadGot NOP\n");
				dc_send(0); lba=dc_handshake()<<24;
				dc_send(0); lba|=dc_handshake()<<16;
				dc_send(0); lba|=dc_handshake()<<8;
				dc_send(0); lba|=dc_handshake();
				dc_send(0); count=dc_handshake();
				puts("Got addr and count\n");
				// FIXME - send some kind of error code here
				while(count--)
				{
					sd_read_sector(lba++,sector_buffer);
					puts("Sending block\n");
					for(i=0;i<512;++i)
					{
						dc_send(sector_buffer[i]);
						dc_handshake();
					}
				}
				dc_send(0); // Error code
				
				break;

			case DC_READCAPACITY:
				puts("Got READCAPACITY\n");
				dc_send(sd_size>>24);
				dc_handshake();
				dc_send(sd_size>>16);
				dc_handshake();
				dc_send(sd_size>>8);
				dc_handshake();
				dc_send(sd_size);
				break;

			case DC_BOOTSTRAP:
				puts("Got BOOTSTRAP\n");

				if(FileOpen(&file,fn))
				{
					int imgsize=(file.size+511)/512;
					int c=0;
					int sector=0;

					struct BIOSTag *tag=(struct BIOSTag *)sector_buffer;
					while(c<imgsize)
					{
						if(!FileRead(&file,sector_buffer))
							return(0);
						puts("Sending block\n");
						for(i=0;i<512;++i)
						{
							dc_send(sector_buffer[i]);
							dc_handshake();
							if(parity) putchar('-'); else putchar('_');
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
				break;

			default:
				puts("unknown command\n");
				break;
		}
		puts("Waiting for next command\n");
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

