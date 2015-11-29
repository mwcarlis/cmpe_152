#include <stdio.h>

#define BIG_SIZE 100000

typedef int bool;
#define true 1
#define false 0

int main(void)
{
        int big_p[BIG_SIZE];
        int i;
        for ( i = 0; i < BIG_SIZE; i++ ) {
                big_p[i] = BIG_SIZE - i;
        }
        printf("BEFORE SORT\n");
        for ( i = 0; i < 20; i++ ) {
                printf("big_p[%d]: %d\n", i, big_p[i]);
        }
        bubble_sort(&big_p, BIG_SIZE);
        printf("AFTER SORT\n");
        for ( i = 0; i < 20; i++ ) {
                printf("big_p[%d]: %d\n", i, big_p[i]);
        }
        return 0;
}

int bubble_sort(int *sequence, int size) {
        int pos = 0;
        int temp = 0;
        bool swapped = false;
        do {
                swapped = false;
                for ( pos = 1; pos < size; pos++ ) {
                        if ( sequence[pos - 1] > sequence[pos] ) {
                                temp = sequence[pos - 1];
                                sequence[pos - 1] = sequence[pos];
                                sequence[pos] = temp;
                                swapped = true;
                        }
                }
        } while ( swapped == true );
        printf("\n");
        return 0;
}
