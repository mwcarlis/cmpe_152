%{
#include <stdio.h>

char blob[100];
// To set DEBUG debug=1
int debug=0;
int class;

#define OP      1
#define ASSIGN  2
#define NUM     3
#define ID      4
#define TOKEN   5

void Fail();
int Expr();
int EPrime();
int Term();
int TPrime();
int Factor();




%}

digit [0-9]
letter [a-zA-Z]
assign =
oper [+|-|\*|\/]

num {digit}+

id {letter}({letter}|{digit})*

whitespace [ \t\n]*


%%

\(              return('(');
\)              return(')');
{oper}          return(OP);
{assign}        return(ASSIGN);

{num}           return(NUM);
{id}            return(ID);
<<EOF>>         return(EOF);
{whitespace}    ;

%%

void TopBoilerPlate() {
    printf("\n");
    printf("SECTION .data\n");
    printf("ResultPrint: db \"%%u\",10,0\n");
    printf("SECTION .bss\n");
    printf("SECTION .text\n");
    printf("extern printf\n");
    printf("global main\n");
    printf("main:\n");
    printf("\tnop\n");
    printf("\tpush ebp\n");
    printf("\tmov ebp,esp\n");
    printf("\tpush ebx\n");
    printf("\tpush esi\n");
    printf("\tpush edi\n");
    printf("; Everything before this is boilerplate.\n");
    printf("\n");
}

void BottomBoilerPlate() {
    printf("\tpush ResultPrint\n");
    printf("\tcall printf\n");
    printf("\tadd esp,8\n");
    printf("\n");
    printf("; Everything after this is boilerplate.\n");
    printf("\tpop edi\n");
    printf("\tpop esi\n");
    printf("\tpop ebx\n");
    printf("\tmov esp,ebp\n");
    printf("\tpop ebp\n");
    printf("\tret\n");
    printf("\n");

}

int main(int argc, char *argv[]) {
    TopBoilerPlate();

    class = yylex();
    sprintf(blob, "%s", yytext); 
    if (debug == 1)
        printf("copied %d %s\n", class, blob);
    if (Expr() == 1) {
        if (class == EOF) {
            //printf("SUCCESS\n");
            BottomBoilerPlate();
            return 1;
        }
    }
    Fail();
}

void Fail() {
    printf("SYNTAX ERROR\n");
    exit(0);
}

int Expr() {
    if (debug == 1)
        printf("Expr()\n");
    if (Term() == 1)
        return EPrime(); 
    else Fail();
}

int EPrime() {
    char op;
    if (debug == 1)
        printf("EPrime(): %d %s\n", class, yytext);

    if (class == OP && (strcmp("+", blob) == 0 ||
                        strcmp("-", blob) == 0)) {
        sprintf(&op, "%s", blob);

        class = yylex();
        sprintf(blob, "%s", yytext); 
        if (Term() == 1) {

            printf("\tpop ecx\n");
            printf("\tpop eax\n");
            if (strcmp("+", &op) == 0) {
                printf("\tadd eax,ecx\n");
            } else if (strcmp("-", &op) == 0) {
                printf("\tsub eax,ecx\n");
            }
            printf("\tpush eax\n");

            return EPrime();
        } else {
            Fail();
        }
    } else if (strcmp(")", blob) == 0 || class == EOF) {
        return 1;
    }
    return 0;
}

int Term() {
    if (Factor() == 1)
        return TPrime();
    else Fail();
}

int TPrime() {
    char op;
    if (debug == 1)
        printf("TPrime(): %s\n", blob);

    if (class == OP && (strcmp("*", blob) == 0 ||
                        strcmp("/", blob) == 0)) {
        sprintf(&op, "%s", blob);

        class = yylex();
        sprintf(blob, "%s", yytext); 

        if (Factor() == 1) {
            if (strcmp("*", &op) == 0) {
                printf("\tpop eax\n");
                printf("\tpop ebx\n");
                printf("\timul ebx\n");
            } else if (strcmp("/", &op) == 0) {
                printf("\tpop ebx\n");
                printf("\tpop eax\n");
                printf("\txor edx,edx\n");
                printf("\tdiv ebx\n");
            }
            printf("\tpush eax\n");

            return TPrime();
        } else {
            Fail();
        }
    } else if (strcmp("+", blob) == 0 ||
               strcmp("-", blob) == 0 ||
               strcmp(")", blob) == 0 ||
               class == EOF) {
        return 1;
    }
    return 0;
}

int Factor() {
    if (debug == 1)
        printf("Factor(): %d, %s\n", class, yytext);
    if (strcmp("(", blob) == 0) {
        class = yylex();
        sprintf(blob, "%s", yytext); 
        if (Expr() != 1)
            Fail();
        if (strcmp(")", blob) != 0)
            Fail();
        class = yylex();
        sprintf(blob, "%s", yytext); 
        return 1;
    } else if (class == NUM || class == ID) {
        printf("\tpush dword %s\n", blob);
        class = yylex();
        sprintf(blob, "%s", yytext); 

        if (debug == 1)
            printf("eof? %d, %s\n", class, yytext);
        return 1;
    }
    Fail();
}

