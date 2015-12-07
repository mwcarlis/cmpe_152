%{
#include "cminus.hh"


extern YYSTYPE yylval;

int lineno = 1;

%}

digit [0-9]
letter [a-zA-Z]
assign =
oper [\+|\-|\*|\/]

num {digit}+
token {letter}({letter}|{digit})*
id {token}(_{token}*)*
whitespace [ \t\n]*


%%

"else"          return ELSE;
"if"            return IF;
"int"           return INT;
"return"        return RETURN;
"void"          return VOID;
"while"         return WHILE;

{id} {
        strcpy(yylval.text, yytext);
        // printf("scan id: %s\n", yytext);
        return ID;
}
{num} {
        yylval.ival = atoi(yytext);
        return NUM;
}

"<"             return '<';
">"             return '>';

"<="            return LTE;
">="            return GTE;
"=="            return EQUAL;
"!="            return NOTEQUAL;

";"             return ';';
","             return ',';
"["             return '[';
"]"             return ']';
"("             return '(';
")"             return ')';
"{"             return '{';
"}"             return '}';
"="             return '=';
"+"             return '+';
"-"             return '-';
"/"             return '/';
"*"             return '*';

"\n" {
        ++lineno;
        //printf("line: %d\n", lineno);
}
{whitespace}    ;
<<EOF>>         return(EOF);

%%

