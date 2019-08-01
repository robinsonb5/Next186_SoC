JWASM_DIR=../../../JWasm
AS=$(JWASM_DIR)/GccUnixR/jwasm

all: bootstrap.mif

clean:
	rm bootstrap.mif

$(AS):
	make -C $(JWASM_DIR) -f GccUnix.mak

%.mif : %.BIN Makefile
	srec_cat $< -Binary -Byte-Swap 4 -Exclude 0 256 -Offset -256 -o $@ -Memory_Initialization_File 32

%.BIN : %.asm $(AS) Makefile
	$(AS) -bin $<


