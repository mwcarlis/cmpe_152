

a.out: symbol_table.o lex.yy.o
	c++ -std=c++11 lex.yy.o symbol_table.o cminus.cc -o a.out

lex.yy.o: lex.yy.c cminus.hh
	cc -c lex.yy.c -o lex.yy.o

lex.yy.c: parser.l
	flex parser.l

cminus.hh: cminus.cc
	@echo "cminus.hh"

cminus.cc: cminus.y
	yacc --verbose --debug -d cminus.y -o cminus.cc

symbol_table.o: symbol_table.c symbol_table.h
	g++ -std=c++11 -c symbol_table.c -o symbol_table.o

clean:
	rm -f a.out
	rm -f lex.yy.o
	rm -f lex.yy.c
	rm -f symbol_table.o
	rm -f cminus.cc
	rm -f cminus.hh
	rm -f cminus.output

