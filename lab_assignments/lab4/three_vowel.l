%{
#include <stdio.h>
%}

%%
([b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*[aeiouAEIOU]){3}[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*   printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%



