JWASM_DIR=../../JWasm
AS=$(JWASM_DIR)/GccUnixR/jwasm

PRJ=BIOSNext

all: $(PRJ).186

clean:
	rm $(PRJ).186
	rm $(PRJ).BIN

$(AS):
	make -C $(JWASM_DIR) -f GccUnix.mak

%.186 : %.asm $(AS)
	$(AS) -bin $<
	mv $*.BIN $@



