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
        int a, b[256];
        int v = 10;
        int t;
        a = 0;
        for(i=0; i<256; i++){
                b[i] = i;
        }

        int temp;
        for (i=0; i< 500000000; i+=3){
                t = 6 * i;
                temp = 7 * 10;
                a +=  temp * (b[i%256] + i);

        }
        printf("%d\n", t);
        printf("%d\n", a);
        printf("%d\n", b[0]);
        return 0;
}

