832DIR=../../EightThirtyTwo/Lib/
INCDIR=../../EightThirtyTwo/include/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l
DUMP=objdump
CFLAGS = -+ -size
COPT = -O=1311
all: Bootstrap_ROM.vhd

clean :
	-rm *.asm
	-rm *.S
	-rm *.o
	-rm *.vhd
	-rm *.bin
	-rm *.elf

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_ROM/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd
	sed 's/dualportram/$*_ROM1/' >$*_ROM1.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b -l4096 $*.bin >>$*_ROM1.vhd
	cat >>$*_ROM1.vhd $(ROMGENDIR)/rom_epilogue.vhd
	sed 's/dualportram/$*_ROM2/' >$*_ROM2.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b -o4096 -l2048 $*.bin >>$*_ROM2.vhd
	cat >>$*_ROM2.vhd $(ROMGENDIR)/rom_epilogue.vhd

%.bin : %.elf Makefile
	objcopy -Obinary $< $@

%.o : %.s Makefile
	gcc -c $*.s

Bootstrap.bin : start.o uart.o small_printf.o spi_c.o minfat.o swap.o boot.o division.o
	$(LD) -m map -o $@ $+

%.o : %.S Makefile
	$(AS) -o $*.o $*.S

%.o : %.c Makefile 
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c
	$(AS) -o $*.o $*.asm

%.o : $(832DIR)/%.S Makefile 
	$(AS) -o $*.o $(832DIR)/$*.S

%.o : $(832DIR)/%.asm Makefile 
	$(AS) -o $*.o $(832DIR)/$*.asm

%.o : $(LIBDIR)/%.S Makefile 
	$(AS) -o $*.o $(LIBDIR)/$*.S

%.o : $(LIBDIR)/%.asm Makefile 
	$(AS) -o $*.o $(LIBDIR)/$*.asm

%.asm : %.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

