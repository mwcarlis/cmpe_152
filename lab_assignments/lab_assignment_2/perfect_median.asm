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

PrintVDash: db "%u -",10,0


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

        mov ecx,6       ; Set Start

loopmain:

        ; Set partial sum ecx to push
        push ecx
        sub ecx,1
        call partial_sum    ; Get lower sum 1 to ecx-1
        mov eax,ecx         ; Move lsum ecx to eax
        mov ecx,[esp]       ; Get ecx from stack
        push eax            ; Put lsum eax onto stack
        call subloop        ; Check all vals from ecx+1 to 10,000
        add esp,4           ; Get eax off the stack
        pop ecx


        add ecx,1
        cmp ecx,9999
        jbe loopmain
        jmp thatsallfolks   ; END the program.

subloop:
        ;; get middle from ecx
        ;; go to 10,000
        ;; get lsum from stack.
        push eax
        push ebx
        push edx
        ;; ----------------

        mov eax,[esp+16]    ; lsum is eax
        mov ebx,ecx         ; middle is ebx
        add ebx,1           ; middle + 1 is ebx
        mov ecx,ebx         ; middle + 1 is ecx
        add ecx,1           ; middle + 2 is ecx
        mov edx,ebx         ; middle + 1 is edx

        sublooptop:
                add edx,ecx ; rsum is edx
                cmp eax,edx ; lsum == rsum?
                jne noprint 
                push ecx    ; n is ecx
                push ebx    ; middle + 1 is ebx
                sub ebx,1   ; middle is ebx
                mov ecx,ebx ; middle is ecx
                call buzzval
                pop ebx     ; middle + 1 is ebx
                pop ecx     ; n is ecx
        noprint:
                add ecx,1   ; middle + n + 1 is ecx
                cmp ecx,10000
                jbe sublooptop
        pop edx
        pop ebx
        pop eax
        ret

delta_part_sum:
        ;; Accepts unsigned int N out of ecx
        ;; Accepts unsigned in M off the stack.
        ;; Returns the sum of all vals from N to M in ecx
        push eax
        push ebx
        push edx

        call partial_sum    ; partial_sum(N)
        push ecx            ; Save partial_sum(N)
        mov ecx,[esp+20]    ; eax is M
        call partial_sum    ; partial_sum(M)
        pop eax             ; eax is partial_sum(N)
        sub ecx,eax         ; partial_sum(M) - partial_sum(N)

        pop edx
        pop ebx
        pop eax
        ret

partial_sum:
        ;; Accepts one unsigned N out of ecx.
        ;; Returns the sum of all vals from 1 to N in ecx
        push eax
        push ebx
        push edx        ; Push register state.

        mov eax,ecx     ; N eax is ecx
        mov ebx,eax
        add ebx,1       ; N + 1
        mul ebx         ; Denom = (N * (N + 1))/2
        mov ecx,eax     ; ecx is Denom
        push 2          ; Set divisor = 2
        call divideby   ; Do Denom / divisor
        add esp,4       ; Pop off the divisor

        pop edx
        pop ebx
        pop eax         ; Pop off old state.
        ret

divideby:
        ;; Accepts N out of ecx
        ;; Accepts unsigned M off the stack
        ;; Returns N / M in ecx
        push eax
        push ebx
        push edx

        xor edx,edx     ; Clear the MSBs
        mov eax,ecx     ; Set the LSBs: Since 100 < (2 ^ 32) - 1
        mov ebx,[esp+16]
        div ebx         ; Divide eax by ebx
        mov ecx,eax     ; Move Quotent into ecx

        pop edx
        pop ebx
        pop eax
        ret

buzzval:
        ;; Print the value in ecx
        ;;
        push eax ; Save the registers.
        push ebx
        push edx

        push ecx
        push PrintVDash
        call printf
        add esp,4
        pop ecx ; Make the registers safe again.

        pop edx
        pop ebx
        pop eax
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


