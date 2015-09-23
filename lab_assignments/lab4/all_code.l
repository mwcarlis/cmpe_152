# Matthew Carlis

##### Five letters start with t.

%{
#include <stdio.h>
%}

%%
t[a-zA-Z]{4}            printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%



##### Four letters

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


##### Start & End Vowel

%{
#include <stdio.h>
%}

%%
[aeiouAEIOU][a-zA-Z]*[aeiouAEIOU]       printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%


#### Three Vowel
%{
#include <stdio.h>
%}

%%
([b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*[aeiouAEIOU]){3}[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*   printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%



#### Tion Letters
%{
#include <stdio.h>
%}

%%
[a-zA-Z]+tion[a-zA-Z]*  printf("%s\n", yytext);
[a-zA-Z][a-zA-Z]*       ;
[ \t\n]*                ;
[^a-zA-Z]*              ;
%%


