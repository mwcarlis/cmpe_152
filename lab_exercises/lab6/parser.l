%{
#include <stdio.h>

char blob[100];
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

id {letter}[{letter}|{digit}]*
tok [^ \t\n]*

whitespace [ \t\n]*


%%

\(              return('(');
\)              return(')');
{oper}          return(OP);
{assign}        return(ASSIGN);

{num}           return(NUM);
{id}            return(ID);
{tok}           return(TOKEN);
<<EOF>>         return(EOF);
{whitespace}    ;

%%


int main(int argc, char *argv[]) {
    class = yylex();
    sprintf(blob, "%s", yytext); 
    //printf("copied %d %s\n", class, blob);
    if (Expr() == 1) {
        if (class == EOF) {
            printf("SUCCESS\n");
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
    //printf("Expr()\n");
    if (Term() == 1)
        return EPrime(); 
    else Fail();
}

int EPrime() {
    //printf("EPrime(): %d %s\n", class, yytext);

    if (class == OP && (strcmp("+", blob) == 0 ||
                        strcmp("-", blob) == 0)) {

        class = yylex();
        sprintf(blob, "%s", yytext); 
        if (Term() == 1)
            return EPrime();
        else Fail();
    } else if (strcmp(")", blob) == 0 || class == EOF) {
        //printf("In here?\n");
        return 1;
    }
    return 0;
}

int Term() {
    //printf("Term()\n");
    if (Factor() == 1)
        return TPrime();
    else Fail();
}

int TPrime() {
    //printf("TPrime(): %s\n", blob);

    if (class == OP && (strcmp("*", blob) == 0 ||
                        strcmp("/", blob) == 0)) {
        class = yylex();
        sprintf(blob, "%s", yytext); 
        if (Factor() == 1)
            return TPrime();
        else Fail();
    } else if (strcmp("+", blob) == 0 ||
               strcmp("-", blob) == 0 ||
               strcmp(")", blob) == 0 ||
               class == EOF) {
        return 1;
    }
    return 0;
}

int Factor() {
    // printf("Factor(): %d, %s\n", class, yytext);
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
        //printf("val %d, %s\n", class, yytext);
        class = yylex();
        sprintf(blob, "%s", yytext); 
        //printf("eof? %d, %s\n", class, yytext);
        return 1;
    }
    Fail();
}

