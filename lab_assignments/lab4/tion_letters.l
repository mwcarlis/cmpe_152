%{
#include <stdio.h>
%}

%%
[a-zA-Z]+tion[a-zA-Z]*  printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%


