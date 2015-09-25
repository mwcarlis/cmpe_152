
fiz: assembl
	gcc -m32 perfect_median.o -o perfect_median.run

assembl: 
	nasm -f elf -g -F stabs perfect_median.asm -l perfect_median.lst

clean:
	rm perfect_median.lst
	rm perfect_median.o
	rm perfect_median.run

