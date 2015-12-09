#include <stdio.h>

int g_unit(int x, int y) {
        int temp = x;
        x = y;
        y = temp;
        return x - y + 10;
}

int main(void)
{
        int i;
        int a[256], b[256];
        for(i=0; i<256; i++){
                a[i] = 0;
                b[i] = i;
        }

        for (i=0; i< 500000000; i+=3){

                a[i%256] = a[i%256] + b[i%256] + i;
        }
        printf("%d\n", a[0]);
        printf("%d\n", b[0]);
        return 0;
}

