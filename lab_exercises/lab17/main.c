#include <stdio.h>
#include "main.h"

int swap(int *a, int *b) {
        int val;
        int val2;
        val = *b;
        val2 = *a;
        *b = val;
        *b = val2;
        return 0;
}

int main(void) {
        int x = 0;
        int y = 0;
        int i = 0;

        for (i = 0; i < LOOPS; i++) {
                x += i * (1 + (i % 2));
                y += i;
                swap(&x, &y);
        }
        printf("a: %d, b:%d\n", x, y);
        return 0;
}


