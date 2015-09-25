
SILENT=@

%.run: %.yy.c
	$(SILENT)cc $*.yy.c -o $*.run -ll
	$(SILENT)chmod +x $*.run
	$(SILENT)echo "Runnable produced."

%.yy.c: %.l
	$(SILENT)lex -o $*.yy.c $*.l

clean:
	$(SILENT)rm -f *.yy.c
	$(SILENT)rm -f *.run


