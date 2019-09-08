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
#define DC_SETIMAGE 0x90
#define DC_READCAPACITY 0x82
#define DC_READBLOCK 0x83
#define DC_WRITEBLOCK 0x84
#define DC_FDREADCAPACITY 0x2
#define DC_FDREADBLOCK 0x3
#define DC_FDWRITEBLOCK 0x4
#define DC_DEBUG 0xFE

#define SYSTEMBASE 0xFFFFFFC8
#define HW_SYSTEM(x) *(volatile unsigned int *)(SYSTEMBASE+x)
#define REG_SYSCONTROL 0

// #define puts(x) 
void _boot();
void _break();

extern fileTYPE file;
extern unsigned char sector_buffer[512];       // sector buffer
char filename[12];

static int parity;

int _cvt(int val, char *buf, int radix);

int dc_handshake()
{
	int t;
	while(((t=HW_DATACHANNEL(0))&DC_HANDSHAKE)==parity)
		;
	parity^=DC_HANDSHAKE;
	return(t&~DC_HANDSHAKE);
}

#define dc_send(x) (HW_DATACHANNEL(0)=(((x)&255)|parity))

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
			int cmd=dc_handshake();
			if(!parity)
				puts("Parity error\n");

			switch(cmd)
			{
				case DC_NOP:
//					puts("NOP\n");
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
					dc_send(DC_DEBUG);
					break;

				case DC_WRITEBLOCK:
				case DC_FDWRITEBLOCK:
//					puts(" W");
					dc_send(0); lba=dc_handshake()<<24;
					dc_send(0); lba|=dc_handshake()<<16;
					dc_send(0); lba|=dc_handshake()<<8;
					dc_send(0); lba|=dc_handshake();
					dc_send(0); count=dc_handshake();
					_cvt(lba,0,16);
//					puts("Got addr and count\n");
					// FIXME - send some kind of error code here
					while(count--)
					{
						int *ptr=(int *)sector_buffer;
						puts("W\n");
						if(cmd==DC_FDWRITEBLOCK)	// Must do this before receiving data,
							FileSeek(&file,lba++);	// since it trashes the sector buffer!

						for(i=0;i<128;++i)
						{
							unsigned int v;
							dc_send(0);
							v=dc_handshake();
							dc_send(0);
							v=(v<<8)|dc_handshake();
							dc_send(0);
							v=(v<<8)|dc_handshake();
							dc_send(0);
							v=(v<<8)|dc_handshake();
							*ptr++=v;
						}
						puts("w\n");
						if(cmd==DC_FDWRITEBLOCK)
							FileWrite(&file,sector_buffer);
						else
							sd_write_sector(lba++,sector_buffer);
					}
					dc_send(0); // Error code
				
					break;

				case DC_READBLOCK:
				case DC_FDREADBLOCK:
	//				puts("Read\n");
					dc_send(0); lba=dc_handshake()<<24;
					dc_send(0); lba|=dc_handshake()<<16;
					dc_send(0); lba|=dc_handshake()<<8;
					dc_send(0); lba|=dc_handshake();
					dc_send(0); count=dc_handshake();
//					_cvt(lba,0,16);
					// FIXME - send some kind of error code here
					while(count--)
					{
						int *ptr=(int *)sector_buffer;
						if(cmd==DC_FDREADBLOCK)
 						{
							// FIXME - send error if there's no fdimage.
							puts(" FS");
							_cvt(lba,0,16);
							putchar(' ');
							FileSeek(&file,lba++);
							FileRead(&file,sector_buffer);
						}
						else
						{
//							puts(" R");
							sd_read_sector(lba++,sector_buffer);
						}
	//					puts("Sending block\n");
						for(i=0;i<128;++i)
						{
							unsigned int v=*ptr++;
//							if(cmd==DC_FDREADBLOCK)
//								_cvt(v,0,16);

							dc_send(v>>24);
							dc_handshake();
							dc_send((v>>16)&255);
							dc_handshake();
							dc_send((v>>8)&255);
							dc_handshake();
							dc_send(v&255);
							dc_handshake();
						}
					}
					dc_send(0); // Error code
//					dc_handshake();
					break;


				case DC_READCAPACITY:
					puts("RCAP ");
//					fdinit=FileOpen(&file,"NEXTBOOTIMG"); // Prepare floppy image. Send SD card size.
					dc_send(sd_size>>24);
					dc_handshake();
					dc_send(sd_size>>16);
					dc_handshake();
					dc_send(sd_size>>8);
					dc_handshake();
					dc_send(sd_size);
					break;
#if 0
				case DC_BOOTSTRAP:
					puts("BSTP ");

					if(FileOpen(&file,"BIOSNEXT186"))
					{
						int imgsize=(file.size+511)/512;
						int c=0;
						int sector=0;

						struct BIOSTag *tag=(struct BIOSTag *)sector_buffer;
						while(c<imgsize)
						{
							if(!FileRead(&file,sector_buffer))
								return(0);

							puts("s\n");

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
						puts("FErr ");
						return(0);
					}
					break;
#endif
				default:
					_cvt(cmd,0,16);
					puts("??? ");
					break;
			}
		}
	}
	return(0);
}

