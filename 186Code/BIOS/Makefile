JWASM_DIR=../../JWasm
AS=$(JWASM_DIR)/GccUnixR/jwasm

PRJ=BIOSNext

all: $(PRJ).BIN

clean:
	rm $(PRJ).mif
	rm $(PRJ).BIN

$(AS):
	make -C $(JWASM_DIR) -f GccUnix.mak

%.mif : %.186
	srec_cat $< -Binary -o $@ -Memory_Initialization_File 32

%.BIN : %.asm $(AS)
	$(AS) -bin $<


