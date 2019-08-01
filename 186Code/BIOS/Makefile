JWASM_DIR=../../JWasm
AS=$(JWASM_DIR)/GccUnixR/jwasm

PRJ=BIOS_Next186

all: $(PRJ).BIN

clean:
	rm $(PRJ).mif
	rm $(PRJ).BIN

$(AS):
	make -C $(JWASM_DIR) -f GccUnix.mak

%.mif : %.BIN
	srec_cat $< -Binary -o $@ -Memory_Initialization_File 32

%.BIN : %.asm $(AS)
	$(AS) -bin $<


