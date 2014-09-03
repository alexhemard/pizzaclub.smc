AC = wla-65816
AFLAGS = -o
LD = wlalink
LDFLAGS = -vsr
LINKFILE = pizzaclub.link
SFILES  = pizzaclub.asm
OFILES  = $(SFILES:.asm=.o)
ROMFILE = pizzaclub.smc

all: $(OFILES)
	$(LD) $(LDFLAGS) $(LINKFILE) $(ROMFILE)

$(OFILES):
	$(AC) $(AFLAGS) $(SFILES)

clean:
	rm -rf $(ROMFILE) *.o

install: clean all
	open $(ROMFILE)	
