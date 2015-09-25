; Executable name : hello
; Description : A simple assembly app for Linux
;               using glibc to display text
;
; Build using these commands:
;       nasm -f elf -g -F stabs hello.asm -l hello.lst
;       gcc -m32 hello.o -o hello

SECTION .data   ; Section containing initialized data

HelloMsg: db "Hello world!",10,0

PrintFizz: db "%u, Fizz!",10,0

PrintVal: db "%u",10,0


SECTION .bss    ; Section containing uninitialized data
SECTION .text   ; Section containing code

extern printf   ;
global main     ;

; ------------------------------------------------------

main:
        nop             ;
        push ebp        ;
        mov ebp,esp
        push ebx        ;
        push esi
        push edi

; Everything before this is boilerplate; use it for all apps

        mov ecx,1       ; Set Start=1

; ------  Loop 1 to 100
loopmain:
        call isfizz     ; If it's not within [50, 59] go off diviz-a-bility.

        add ecx,1       ; Add Start += 1
        cmp ecx,100     ; At end of loop branch statement.

        jbe loopmain    ;
        jmp thatsallfolks         ; END the program.



isfizz:
        cmp ecx,59
        ja isdiviz      ; If it's above 59 check diviz-a-bility
        cmp ecx,50
        jb isdiviz      ; If it's below 50 check diviz-a-bility
        call fiznum     ; It's within [50, 59], print that fizz.
        ret

isdiviz:
        xor edx,edx     ; Clear the MSBs
        mov eax,ecx     ; Set the LSBs: Since 100 < (2 ^ 32) - 1
        mov ebx,5
        div ebx         ; Divide eax by 5
        cmp edx,0       ; Remainder - 0?
        jne buzzval     ; Return if Remainder != 0
        call fiznum
        ret

buzzval:
        ; Print the non Fizz case.
        ; I.e has no 5 in it's digits and is not divisible by 5.
        push ecx
        push PrintVal
        call printf
        add esp,4
        pop ecx
        ret

fiznum:
        ; Print the Fizz case.
        ; I.e divisible by 5 or has a 5 in it's digits.
        push ecx
        push PrintFizz
        call printf
        add esp,4       ; Get the format off the stack.
        pop ecx         ; Get ecx back.
        ret

thatsallfolks:
        ; END of the program.  Boil that plate.
        ; Everything after this is boilerplate; use it for all apps
        pop edi
        pop esi
        pop ebx
        mov esp,ebp
        pop ebp
        ret


