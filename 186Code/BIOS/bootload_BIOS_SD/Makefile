JWASM_DIR=../../../JWasm
AS=$(JWASM_DIR)/GccUnixR/jwasm

all: bootstrap.mif

clean:
	rm bootstrap.mif
	rm bootstrap.BIN

$(AS):
	make -C $(JWASM_DIR) -f GccUnix.mak

%.mif : %.BIN
	srec_cat $< -Binary -o $@ -Memory_Initialization_File 32

%.BIN : %.asm $(AS)
	$(AS) -bin $<


