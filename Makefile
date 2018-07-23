NAME=gb8

SDCC=C:/SDCC
TOOLS=$(SDCC)/bin
LIBS=$(SDCC)/lib

INCLUDE=$(SDCC)/include
INCLUDE_ASM=$(SDCC)/include/asm

CC=$(TOOLS)/sdcc
AS=$(TOOLS)/sdasgb
LN=$(TOOLS)/sdcc
MAKEBIN=$(TOOLS)/makebin

CC_FLAGS=  -mgbz80 -c -l --std-sdcc11 --no-std-crt0 -I$(INCLUDE) -I$(INCLUDE_ASM)
ASM_FLAGS= -l -I$(INCLUDE) -I$(INCLUDE_ASM)
LN_FLAGS= -mgbz80 -L $(LIBS)/gbz80 gbz80.lib --no-std-crt0 --out-fmt-ihx --code-loc 0x0200
MAKEBIN_FLAGS= -Z -yn $(NAME)

SRC_C=    $(wildcard src/*.c)
SRC_C+=   $(wildcard src/bank*/*.c)
SRC_ASM=  $(wildcard src/*.s)
SRC_ASM+= $(wildcard src/bank*/*.s)

OBJ=  $(SRC_C:%.c=%.rel)
OBJ+= $(SRC_ASM:%.s=%.rel)
OBJ_LIST= $(wildcard output/out/*.rel)

#Clean Files, Build Project, create Listing:
all: clean createDirs compile link

#Build Project:
compile: $(OBJ)
	

#Link Files:
link:
	$(LN) $(LN_FLAGS) -o output/$(NAME).ihx $(OBJ_LIST)
#	$(S19GB) $(S19GB_FLAGS) -i output/$(NAME).s19 -o output/$(NAME).gb
	$(MAKEBIN) $(MAKEBIN_FLAGS) output/$(NAME).ihx output/$(NAME).gb

#Create ASM file from C:
src2asm: $(SRC_C2ASM)
	

#File Creation:
%.rel: %.c
	$(CC) $(CC_FLAGS) -o output/out/$(@F) $<
%.rel: %.s
	$(AS) $(ASM_FLAGS) -o output/out/$(@F) $<
%.s: %.c
	$(CC) -S $(CC_FLAGS) -o output/out/$(@F) $<

#Create Output Directory:
createDirs:
	@if not exist "output" mkdir output
	@if not exist "output\out" mkdir output\out
	
clean:
	@if exist "output" rmdir /S /Q output
	