%{
#include <stdio.h>

char blob[100];
// To set DEBUG debug=1
int debug=0;
int class;
int success=1;

#define OP      1
#define ASSIGN  2
#define NUM     3
#define ID      4
#define TOKEN   5
#define LP      6
#define RP      7
#define NA      100
#define ERROR   9999

/*
void Fail();
int Expr();
int EPrime();
int Term();
int TPrime();
int Factor();
*/

%}

digit [0-9]
letter [a-zA-Z]
assign =
oper [+|-|\*|\/]

num {digit}+

id {letter}({letter}|{digit})*

whitespace [ \t\n]*


%%

\(              return(LP);
\)              return(RP);
<<EOF>>         return(EOF);
{whitespace}    ;
.               return(ERROR);
%%

void Fail() {
    printf("SYNTAX ERROR\n");
    exit(0);
}

int main(int argc, char *argv[]) {
    if (Stok() == 1) {
        printf("SUCCESS\n");
        return 1;
    }
    Fail();
}

int Stok() {
    if (Xtok() == 0) {
        // When Xtok() returns better be at EOF.
        class = yylex();
        if (class == EOF)
            return 1;
    }
    Fail();
}

int Xtok() {
    //  Stop when EOF or failure.
    class = yylex();
    if (class == EOF) {
        return EOF;
    }else if (class == LP) {
        while (1 == 1) {
            success = Xtok();
            if (success == RP) {
                return 0;
            } else if (success == EOF) {
                Fail();
            }
        }
    } else if (class == RP) {
        return RP;
    }
    Fail();
}


