%{
#include <stdio.h>
%}

%%
[aeiouAEIOU][a-zA-Z]*[aeiouAEIOU]       printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%


