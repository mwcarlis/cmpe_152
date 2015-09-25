%{
#include <stdio.h>
%}

%%
[a-zA-Z]                ;
[a-zA-Z][a-zA-Z]{1,2}   ;
[a-zA-Z][a-zA-Z]{3}     printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]{4,}    ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%


