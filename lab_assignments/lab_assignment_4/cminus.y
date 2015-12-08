
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
int scope_num = 0;
int last_scope = 0;
int current_scope = 0;

int param_num = 1;
int num_locals = 0;
int var_stack = 0;

int ebp_param = 0;
int next_ebp_param = 0;

int ebp_local = 0;
int next_ebp_local = 0;

#define CALLER_SAVE 8
#define CALLEE_SAVE -8

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
                entry.param_num = var_stack;
                entry.ebp_offset = 0;
                entry.scope_num = 0;
                cp_add_symbol(entry);
                --var_stack;
        }
        // printf("program var stack: %d\n", var_stack);
        printf("parse complete!\n");

};

declaration_list : declaration_list declaration | declaration {
};

declaration : var_declaration | fun_declaration ;

var_declaration : type_specifier ID ';' {
                if ( !cp_is_entry($2) ) {
                        // Put this ID on the stack.
                        if (cp_add_variable($1, $2, ebp_local, 0, scope_depth, current_scope)){
                                var_stack += 1;
                                ebp_local -= 4;
                        } else if (num_locals > 0) {
                                // This is a local.
                                --num_locals;
                        }
                }

        } | type_specifier ID '[' NUM ']' ';' {
                int size = $4;
                if (1 == $1) {
                        if (cp_add_variable(2, $2, ebp_local, size, scope_depth, current_scope)) {
                                var_stack += 1;
                                ebp_local -= size * 4;
                        } else if (num_locals > 0) {
                                // This is a local
                                --num_locals;
                        }
                }
};

type_specifier : INT {
                $$ = 1;
        } | VOID {
                $$ = 0;
};

fun_declaration : type_specifier ID lparen params ')' compound_stmt {
        // Just scanned a function.
        if ( !cp_is_entry($2)) {
                // Is this a void or an int?
                if ($1 == 0){
                        if (!cp_add_function($2, "Function", $4, current_scope, "Void")) {

                        }
                } else {
                        if (!cp_add_function($2, "Function", $4, current_scope, "Int")) {

                        }
                }
        }
        // We just entered a function.
        int x;
        struct symbol_entry entry;
        for ( x = 0; x < $4; ++x ) {
                // Get the parameters off param stack.
                // TODO: Print function prep code?
                entry = cp_pop_param();
                entry.scope = "global";
                ebp_param -= 4;
                entry.ebp_offset = ebp_param;
                cp_add_symbol(entry);
                --param_num;
        }
        // TODO: Print function setup code.
        int locals = num_locals;
        for (x = 0; x < locals; x++) {
                // Get the local variables off variable stack.
                // TODO: Print function locals code.
                var_stack -= 1;
                entry = cp_pop_variable();
                entry.scope = $2;
                entry.param_num = locals - x;
                cp_add_symbol(entry);
        }
        // We're leaving a function.
        num_locals = 0;
        // TODO: Print function exit code.
};

lparen: '(' {
        printf("\n--Local Symbol Table:--\n");
        ebp_local = CALLEE_SAVE;
        next_ebp_local = CALLEE_SAVE;

        ebp_param = CALLER_SAVE;
        next_ebp_param = CALLER_SAVE;
}

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
        if(cp_add_param($1, -param_num, 0, ebp_param, $2)) {
                ebp_param += 4;
                ++param_num;
        }

        } | type_specifier ID '[' ']' {
        // Assume it's an int array.
        if ($1 == 1) {
                if (cp_add_param(2, -param_num, 0, ebp_param, $2)) {
                        ebp_param += 4;
                        ++param_num;
                }
        } else {
                printf("Failed array type. %d\n", $1);
        }
};

compound_stmt : lbrace local_declarations statement_list '}' {
        // We are exiting the scope.

        --scope_depth;
        current_scope = last_scope;
};

lbrace : '{' {
        // We entered a new scope.

        ++scope_depth;
        ++scope_num;
        last_scope = current_scope;
        current_scope = scope_num;

};

local_declarations : local_declarations var_declaration {
        ++num_locals;

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
        printf("Sample output:\n");
        yyparse();
        cp_print_table();
}

int yyerror(const char *msg) {
        fprintf(stderr,"%s: line %d\n", msg, lineno);
        return 0;
}


