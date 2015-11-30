
hello: main.c mul.asm
	nasm -f elf -o mul.o mul.asm
	gcc -m32 -c main.c -o main.o
	gcc -m32 -o main.run mul.o main.o

clean:
	rm -f main.o
	rm -f mul.o
	rm -f main.run
