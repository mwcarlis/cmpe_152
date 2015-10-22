#include <stdio.h>

/* We need a prototype so the compiler knows what types function() takes */
int function(char *input);

/* Since this is static, we can define it in both hello.c and function.c */
static int i = 100;

/* This is a global variable */
int global = 10;

int main(void)
{
	/* function() should return the value of global */
	int ret = function("Hello, World!");
        return 0;
}

/* Declard as extern since defined in hello.c */
extern int global;
    
int function(char *input)
{
    printf("%s\n", input);
    return global;
}
    
