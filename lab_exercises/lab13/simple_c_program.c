

struct books {
        int fun;
        char silly;
        int dog;
        char cat;
        char log;
        char frog;
        int mob;
        char tod[4];
};




int main(void) {
        struct books book;
        int x;

        book.fun = 0;
        book.silly = 'a';
        book.dog = 1;
        book.cat = 'b';
        book.log = 'c';
        book.frog = 'd';
        book.mob = 2;
        book.tod[0] = 'a';
        book.tod[1] = 'b';
        book.tod[2] = 'b';
        book.tod[3] = 'a';
        x = 4 + 1;
        return loyd(x, 8);
}

int loyd(int y, int z) {
        int x;
        x = 10 + y;
        return x;
}


