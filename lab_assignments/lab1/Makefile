
hello: assembl
	gcc -m32 hello.o -o hello

assembl: 
	nasm -f elf -g -F stabs hello.asm -l hello.lst

clean:
	rm hello.lst
	rm hello.o
	rm hello

