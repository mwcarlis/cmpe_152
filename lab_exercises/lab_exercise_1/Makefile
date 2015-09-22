
fiz: assembl
	gcc -m32 fiz_buz.o -o fiz_buz.run

assembl: 
	nasm -f elf -g -F stabs fiz_buz.asm -l fiz_buz.lst

clean:
	rm fiz_buz.lst
	rm fiz_buz.o
	rm fiz_buz.run

