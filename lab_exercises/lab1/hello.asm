; Executable name : hello
; Description : A simple assembly app for Linux
;               using glibc to display text
;
; Build using these commands:
;       nasm -f elf -g -F stabs hello.asm -l hello.lst
;       gcc -m32 hello.o -o hello

SECTION .data   ; Section containing initialized data

HelloMsg: db "Hello world!",10,0

SECTION .bss    ; Section containing uninitialized data

SECTION .text   ; Section containing code

extern printf   ;
global main     ;

main:
        nop             ;
        push ebp        ;
        mov ebp,esp
        push ebx        ;
        push esi
        push edi
; Everything before this is boilerplate; use it for all apps

        push HelloMsg   ;
        call printf     ;
        add esp,4       ;

; Everything after this is boilerplate; use it for all apps
        pop edi         ;
        pop esi
        pop ebx
        mov esp,ebp     ;
        pop ebp
        ret             ;


