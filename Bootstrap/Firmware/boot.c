/*
	Firmware for loading BIOS from SD card.
	Provides block level access both to floppy images and the whole card.
	SPI and FAT code borrowed from the Minimig project.
*/


#include <stdio.h>
#include "stdarg.h"

#include "uart.h"
#include "spi.h"
#include "minfat.h"

#define DATACHANNEL 0xFFFFFFCC
#define HW_DATACHANNEL(x) (*(volatile unsigned int *)(DATACHANNEL+x))
#define DC_HANDSHAKE 0x100

#define DC_FDREADBLOCK 0x2
#define DC_FDWRITEBLOCK 0x3
#define DC_FDVERIFYBLOCK 0x4
#define DC_FDREADCAPACITY 0x60

#define DC_READBLOCK 0x82
#define DC_WRITEBLOCK 0x83
#define DC_VERIFYBLOCK 0x84
#define DC_READCAPACITY 0xE0

#define DC_SETIMAGE 0xFC
#define DC_BOOTSTRAP 0xFD
#define DC_DEBUG 0xFE
#define DC_NOP 0xFF

#define SYSTEMBASE 0xFFFFFFC8
#define HW_SYSTEM(x) *(volatile unsigned int *)(SYSTEMBASE+x)
#define REG_SYSCONTROL 0

#define INTERRUPTBASE 0xffffffb0	// Not actually used for interrupts, but a latching trigger for the disk button
#define HW_INTERRUPT(x) *(volatile unsigned int *)(INTERRUPTBASE+x)
#define REG_INTERRUPT_CTRL 0x0


// #define puts(x) 
void _boot();
void _break();

extern fileTYPE file;
extern unsigned char sector_buffer[512];       // sector buffer
char filename[12];

static int parity;

int dc_handshake()
{
	int t;
	while(((t=HW_DATACHANNEL(0))&DC_HANDSHAKE)==parity)
		;
	parity^=DC_HANDSHAKE;
	return(t&~DC_HANDSHAKE);
}

#define dc_send(x) (HW_DATACHANNEL(0)=(((x)&255)|parity))

static void puthex(int val)
{
	int c;
	int i;
	int nz=0;
	if(val)
	{
		for(i=0;i<8;++i)
		{
			c=(val>>28)&0xf;
			val<<=4;
			if(c)
				nz=1;	// Non-zero?  Start printing then.
			if(c>9)
				c+='A'-10;
			else
				c+='0';
			if(nz)	// If we've encountered only zeroes so far we don't print.
				putchar(c);
		}
	}
	else
		putchar('0');
}

int main(int argc,char **argv)
{
	int t;
	int i;
	int lba;
	int count;
	int fdinit=0;
	parity=0;

	puts("SDInit ");
	if(spi_init())
	{
		puts("Part ");
		FindDrive();

		while(1)
		{
			int result=0;
			int cmd=dc_handshake();

			if(HW_INTERRUPT(REG_INTERRUPT_CTRL)&1)
			{
				puts("flip disk\n");
				HW_INTERRUPT(REG_INTERRUPT_CTRL)=0; // Clear latch
			}

			switch(cmd)
			{
				case DC_NOP:
					dc_send(DC_NOP);
					break;

				case DC_SETIMAGE:
					for(i=0;i<12;++i)
					{
						dc_send(0); filename[i]=dc_handshake();
					}
					filename[11]=0;
					puts(filename);
					if(fdinit=FileOpen(&file,filename))
					{
		
						dc_send(0);
						dc_handshake();				
						dc_send(0);
					}
					else
					{
						dc_send(0xff);
						dc_handshake();
						dc_send(0xff);
						puts("FErr ");
					}
					break;

				case DC_DEBUG:
					dc_send(DC_DEBUG);
					putchar(dc_handshake());
					putchar(' ');
					dc_send(DC_DEBUG);
					break;

				case DC_WRITEBLOCK:
				case DC_FDWRITEBLOCK:
					dc_send(0); lba=dc_handshake()<<24;
					dc_send(0); lba|=dc_handshake()<<16;
					dc_send(0); lba|=dc_handshake()<<8;
					dc_send(0); lba|=dc_handshake();
					dc_send(0); count=dc_handshake();

					putchar('W');
					puthex(count);
					putchar(' ');
					puthex(lba);
					putchar(' ');

					while(count--)
					{
						unsigned char *ptr=(unsigned char *)sector_buffer;
						if(cmd==DC_FDWRITEBLOCK)	// Must do this before receiving data,
							FileSeek(&file,lba++);	// since it trashes the sector buffer!

						for(i=0;i<512;++i)
						{
							dc_send(0);
							*ptr++=dc_handshake();
						}
						if(cmd==DC_FDWRITEBLOCK)
							FileWrite(&file,sector_buffer);
						else
							sd_write_sector(lba++,sector_buffer);
						putchar('.');
					}
					dc_send(0); // Error code
				
					break;

				case DC_VERIFYBLOCK:
				case DC_FDVERIFYBLOCK:
				case DC_READBLOCK:
				case DC_FDREADBLOCK:
					dc_send(0); lba=dc_handshake()<<24;
					dc_send(0); lba|=dc_handshake()<<16;
					dc_send(0); lba|=dc_handshake()<<8;
					dc_send(0); lba|=dc_handshake();
					dc_send(0); count=dc_handshake();

					putchar('R');
					puthex(count);
					putchar(' ');
					puthex(lba);
					putchar(' ');

					while(count--)
					{
						unsigned char *ptr=sector_buffer;
						if(cmd==DC_FDREADBLOCK)
 						{
							// FIXME - send error if there's no fdimage.
							FileSeek(&file,lba++);
							FileRead(&file,sector_buffer);
						}
						else
						{
							sd_read_sector(lba++,sector_buffer);
						}
						if(cmd==DC_VERIFYBLOCK || cmd==DC_FDVERIFYBLOCK)
						{
							for(i=0;i<512;++i)
							{
								dc_send(0);
								if(*ptr++!=dc_handshake())
									result=0xff;
							}
						}
						else
						{
							for(i=0;i<512;++i)
							{
								dc_send(*ptr++);
								dc_handshake();
							}
						}
						putchar('.');
					}
					dc_send(result); // Error code
					break;


				case DC_READCAPACITY:
					puts("RCAP ");
					dc_send(sd_size>>24);
					dc_handshake();
					dc_send(sd_size>>16);
					dc_handshake();
					dc_send(sd_size>>8);
					dc_handshake();
					dc_send(sd_size);
					break;

				default:
					puthex(cmd);
					puts("? ");
					break;
			}
		}
	}
	return(0);
}

