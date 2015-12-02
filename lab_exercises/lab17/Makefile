
hello: main.c inline_main.c
	gcc -m32 -S main.c
	gcc -m32 -S inline_main.c
	gcc -m32 main.c -o main.o
	gcc -m32 -O3 main.c -o O3_main.o
	gcc -m32 inline_main.c -o inline_main.o
	gcc -m32 -O3 inline_main.c -o O3_inline_main.o

clean:
	rm -f main.o
	rm -f O3_main.o
	rm -f inline_main.o
	rm -f O3_inline_main.o
	rm -f main.s
	rm -f inline_main.s

