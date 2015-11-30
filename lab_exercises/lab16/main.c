#include <stdio.h>

int mypow(int x, int y, int z);

int main(void) {
        int x, y, z;
        int ret;

        printf("Enter x, y, z seperated by comma.\n");
        scanf("%d, %d, %d", &x, &y, &z);
        printf("Got x: %d, y: %d, z: %d\n", x, y, z);
        ret = mypow(x, y, z);

        printf("mypow: %d\n", ret);
        return 0;
}

