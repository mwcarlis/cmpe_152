
main: optimized
	gcc main.c -o main.o
	gcc -S -fverbose-asm main.c -o main.s

optimized:
	gcc -O1 -fverbose-asm main.c -o O1_main.o
	gcc -O1 -S -funroll-loops -floop-optimize main.c -o O1_main.s

clean:
	rm -f main.o
	rm -f main.s
	rm -f O1_main.o
	rm -f O1_main.s

