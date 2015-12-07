
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

int scope_depth = 0;
int param_num = 1;
int num_locals = 0;
int var_stack = 0;

%}

/**/
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

program : declaration_list {
        struct symbol_entry entry;
        while (var_stack > 0) {
                entry = cp_pop_variable();
                entry.scope = "global";
                cp_add_symbol(entry);
                --var_stack;
        }
        printf("Done- var stack: %d\n", var_stack);

};

declaration_list : declaration_list declaration | declaration {
};

declaration : var_declaration | fun_declaration ;

var_declaration : type_specifier ID ';' {
                // printf("line: %d\t", lineno);
                if ( !cp_is_entry($2) ) {
                        // Put this ID on the stack.
                        cp_add_variable($1, $2);
                        var_stack += 1;
                        // printf("Adding symbol\n");
                        // printf(", var_decl1: %d %s\n", $1, $2);
                }

        } | type_specifier ID '[' NUM ']' ';' {
                printf(", var_decl2:\n");
};

type_specifier : INT {
                $$ = 1;
        } | VOID {
                $$ = 0;
};

fun_declaration : type_specifier ID '(' params ')' compound_stmt {
        // printf("line: %d\t", lineno);
        // printf("func_decl: %s\t%d\n", $2, $4);
        struct symbol_entry entry;
        int x = $4;
        for ( x = 0; x < $4; ++x ) {
                entry = cp_pop_param();
                entry.scope = $2;
                cp_add_symbol(entry);
        }
        // printf("\n");
        int locals = num_locals;
        for (x = 0; x < locals; x++) {
                var_stack -= 1;
                entry = cp_pop_variable();
                entry.scope = $2;
                cp_add_symbol(entry);
        }
        num_locals = 0;
        if ( !cp_is_entry($2)) {
                if ($1 == 0){
                        cp_add_function($2, "Function", $4, "Void");
                } else {
                        cp_add_function($2, "Function", $4, "Int");
                }
        }
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
        // printf("param: %s\n", $2);
        cp_add_param($1, param_num, $2);
        param_num += 1;

        } | type_specifier ID '[' ']' {

};

compound_stmt : '{' local_declarations statement_list '}' ;

local_declarations : local_declarations var_declaration {
        num_locals += 1;
        // printf("local decl\n");

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
        cp_print_table();
        printf("Finish\n");
}

int yyerror(const char *msg) {
        fprintf(stderr,"%s: line %d\n", msg, lineno);
        return 0;
}


