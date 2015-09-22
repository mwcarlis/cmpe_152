%{
#include <stdio.h>
%}

%%
t[a-zA-Z]{4}            printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%



