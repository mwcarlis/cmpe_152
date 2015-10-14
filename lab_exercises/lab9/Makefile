
SILENT=@

%.exc: %.o
	$(SILENT)gcc -m32 -g $*.o -o $*.exc

%.o: %.asm
	$(SILENT)nasm -f elf -g -F stabs $*.asm -l $*.lst

%.run: %.yy.c
	$(SILENT)cc y.tab.c $*.yy.c -o $*.run -ll -lm
	$(SILENT)chmod +x $*.run
	$(SILENT)echo "Runnable produced."

%.yy.c: %.l
	yacc -d $*.yacc
	$(SILENT)lex -o $*.yy.c $*.l


clean:
	$(SILENT)rm -f *.yy.c
	$(SILENT)rm -f *.run
	$(SILENT)rm -f *.exc
	$(SILENT)rm -f *.lst
	$(SILENT)rm -f y.tab.*


