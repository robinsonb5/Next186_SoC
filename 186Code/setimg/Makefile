JWASM_DIR=../../JWasm
AS=$(JWASM_DIR)/GccUnixR/jwasm

PRJ=setimg

all: $(PRJ).com

clean:
	rm $(PRJ).com

$(AS):
	make -C $(JWASM_DIR) -f GccUnix.mak

%.com : %.asm $(AS)
	$(AS) -bin $<
	mv $*.BIN $@

