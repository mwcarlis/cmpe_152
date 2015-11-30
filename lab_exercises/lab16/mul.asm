
SECTION .text
global mypow
;.type mypow @function


mypow:
        ; Make a frame for this function
        push ebp
        mov ebp, esp
        ; Preserve the registers
        push ecx
        push ebx
        push edx
        ; Get the mypow parameters
        mov eax, [ebp+8]  ; get x
        mov edx, [ebp+12] ; get y
        mov ebx, eax
        mov ecx, 1
        call looppow
xpowy:
        mov edx, [ebp+16] ; get z
        mov ebx, eax
        mov ecx, 1
        call looppow
xypowz:
        ; Resore the register
        pop edx
        pop ebx
        pop ecx
        ; Take down the stack
        mov esp, ebp
        pop ebp
        ret

looppow: ; Perform (eax ^ edx)
        imul eax, ebx
        add ecx, 1
        cmp ecx, edx
        jb looppow
        ret

