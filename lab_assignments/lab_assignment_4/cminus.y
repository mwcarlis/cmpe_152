
%{
#include <stdio.h>
#include "symbol_table.h"

extern int lineno;

extern "C"
{
        int yyparse(void);
        int yylex(void);
        int yywrap() { return 1;}
        int yyerror(const char *msg);
}

%}
%union {
        int ival;
        char text[40];
}
/* C-Minus BNF Grammar */

%token ELSE
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE

%token <text> ID
%token <ival> NUM

%token LTE
%token GTE
%token EQUAL
%token NOTEQUAL

%type <text> var_declaration var call
%type <ival> type_specifier params param_list
%%

program : declaration_list ;

declaration_list : declaration_list declaration | declaration ;

declaration : var_declaration | fun_declaration ;

var_declaration : type_specifier ID ';' {
                printf("line: %d\t", lineno);
                if ( !cp_is_entry($2) ) {
                        cp_add_symbol($2, 1, 1, "Int", "None");
                        printf("Adding symbol");

                }
                        
                printf(", var_decl1: %d %s\n", $1, $2);
        } | type_specifier ID '[' NUM ']' ';' {
                printf(", var_decl2:\n");
};

type_specifier : INT {
                $$ = 0;
        } | VOID {
                $$ = 1;
};

fun_declaration : type_specifier ID '(' params ')' compound_stmt {
        printf("line: %d\t", lineno);
        printf("func_decl: %s\t%d\n", $2, $4);
};

params : param_list {
                $$ = $1;
        } | VOID {
                $$ = 0;
};

param_list : param_list ',' param {
                $$ = $1 + 1;
        } | param {
                $$ = 1;
};

param : type_specifier ID {
        printf("param: %s\n", $2);

        } | type_specifier ID '[' ']' {
        
};

compound_stmt : '{' local_declarations statement_list '}' ;

local_declarations : local_declarations var_declaration {
        printf("local decl\n");

} | /* empty */ ;

statement_list : statement_list statement
               | /* empty */ ;

statement : expression_stmt
          | compound_stmt
          | selection_stmt
          | iteration_stmt
          | return_stmt ;

expression_stmt : expression ';'
                | ';' ;

selection_stmt : IF '(' expression ')' statement
               | IF '(' expression ')' statement ELSE statement ;

iteration_stmt : WHILE '(' expression ')' statement ;

return_stmt : RETURN ';' | RETURN expression ';' ;

expression : var '=' expression | simple_expression ;

var : ID | ID '[' expression ']' ;

simple_expression : additive_expression relop additive_expression
                  | additive_expression ;

relop : LTE | '<' | '>' | GTE | EQUAL | NOTEQUAL ;

additive_expression : additive_expression addop term | term ;

addop : '+' | '-' ;

term : term mulop factor | factor ;

mulop : '*' | '/' ;

factor : '(' expression ')' | var | call | NUM ;

call : ID '(' args ')' ;

args : arg_list | /* empty */ ;

arg_list : arg_list ',' expression | expression ;

%%

int main(void) {
        printf("Start\n");
        yyparse();
        
        printf("Finish\n");
}

int yyerror(const char *msg) {
        fprintf(stderr,"%s: line %d\n", msg, lineno);
        return 0;
}


