
#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <string>
#include <algorithm>
#include <stack>
#include <tuple>
#include <unordered_map>
#include <iomanip>
#include <vector>

#include "symbol_table.h"

// A stack for declared function parameters.
static std::stack<struct symbol_entry> param_qq;
// A stack for declared variables.
static std::stack<struct symbol_entry> variable_qq;


// Scoping hash tables.
static std::unordered_map<std::string, std::vector<int>> stack_scope;


std::string GLOBAL_VAR = "global";
// Parent of global is null.
static SymbolTable global = SymbolTable(GLOBAL_VAR);


static std::vector<SymbolTable> scopes(1, global);
static int current_num = 0;


// Start C-Compatable wrapper interfaces.

bool cp_add_param(int type, int param_num, int size, int ebp, std::string sym_name) {
        /*Add a parameter to the top of the param stack*/
        struct symbol_entry entry;
        if (type == 1) {
                // 1 is an integer.
                entry.type = "Int variable";
        } else if (type == 2) {
                // 2 is an integer array.
                entry.type = "Int array";
        } else {
                // We ignore VOID since it's uninteresting.
                printf("Bad add_param type: %d\n", type);
        }
        std::vector<int> temp = stack_scope[sym_name];
        if ( 1 == stack_scope.count(sym_name)) {
                if ( std::find(temp.begin(), temp.end(), 0) != temp.end()) {
                        return false;
                }
        } else {
                stack_scope[sym_name].emplace_back(0);
        }
        entry.arr_size = size;
        entry.param_num = param_num;
        entry.scope_num = 0;
        entry.symbol_name = sym_name;
        entry.ebp_offset = ebp;
        param_qq.push(entry);
        return true;
}

struct symbol_entry cp_pop_param() {
        /*Remove and get the top of the param stack*/
        struct symbol_entry entry;
        entry = param_qq.top();
        entry.is_param = true;
        param_qq.pop();
        return entry;
}

bool cp_add_variable(int type, std::string sym_name,
                        int ebp, int size, int scope_depth, int scope_num) {
        /*Add a variable to the top of the variable stack*/
        if ( 1 == stack_scope.count(sym_name)) {
                std::vector<int> temp = stack_scope[sym_name];
                if ( std::find(temp.begin(), temp.end(), scope_num) != temp.end()) {
                        std::cout << " Symbol " << std::setw(10) << sym_name;
                        std::cout << " already defined in this scope (Scope " << scope_num;
                        std::cout << ")" << std::endl;
                        return false;
                }
        }
        struct symbol_entry entry;
        if (type == 1) {
                // 1 is an integer.
                entry.type = "Int variable";
        } else if (type == 2) {
                // 2 is an integer arra array.
                entry.type = "Int array";
        } else {
                // We ignore VOID since it's uninteresting.
                printf("Bad add_param type: %d\n", type);
        }
        stack_scope[sym_name].emplace_back(scope_num);
        entry.symbol_name = sym_name;
        entry.is_param = false;
        entry.arr_size = size;
        entry.scope_depth = scope_depth;
        entry.ebp_offset = ebp;
        entry.scope_num = scope_num;
        variable_qq.push(entry);
        return true;
}

struct symbol_entry cp_pop_variable() {
        /*Remove and get the top of the variable stack*/
        struct symbol_entry entry;
        entry = variable_qq.top();
        variable_qq.pop();
        return entry;
}

bool cp_add_function(std::string sym_name, std::string type,
                        int num_params, int scope_num, std::string ret_type) {
        struct symbol_entry entry;
        entry.symbol_name = sym_name;
        entry.scope_num = scope_num;
        entry.type = type;
        entry.num_params = num_params;
        entry.ret_type = ret_type;
        entry.scope = GLOBAL_VAR;
        entry.arr_size = 0;
        entry.ebp_offset = 0;
        entry.is_param = false;
        scopes[current_num].add_entry(entry);
        return true;
}

void cp_add_symbol(struct symbol_entry entry) {
        std::string func = "Function";
        int old_num = current_num;
        if ( entry.scope_num != current_num ) {
                // Is this variable in a different scope?
                if (entry.scope_num >= scopes.size()) {
                        // Is this a new scope?
                        SymbolTable new_scope = SymbolTable(entry.scope);
                        scopes.emplace_back(new_scope);
                        current_num = scopes.size() - 1;
                } else {
                        current_num = entry.scope_num;
                }
        }

        if (entry.scope_num != 0) {
                std::cout << " Symbol=" << std::setw(10) << entry.symbol_name;
                std::cout << ", SType=" << std::setw(14) << entry.type;

                std::cout << " , ArrSize=" << std::setw(3) << entry.arr_size;
                std::cout << ", ScopeDepth=" << std::setw(3) << entry.scope_depth;
                std::cout << ", ScopeNumber=" << std::setw(3) << entry.scope_num;
                std::cout << ", EBP Offsets=" << std::setw(4) << entry.ebp_offset;
                //std::cout << ", Scope=" << entry.scope;

                // End.
                std::cout << std::endl;
        }
        scopes[current_num].add_entry(entry);

        current_num = old_num;
        return;
}

struct symbol_entry cp_get_entry(std::string sym_name) {
        return scopes[current_num].get_entry(sym_name);
}

bool cp_is_entry(std::string sym_name) {
        return scopes[current_num].is_entry(sym_name);
}

bool cp_is_entry(struct symbol_entry entry) {
        return scopes[current_num].is_entry(entry);
}

void cp_print_table() {
        return scopes[current_num].print_table();
}


// Start SymbolTable member functions.
SymbolTable::SymbolTable(std::string t_scope) {
        scope = t_scope;
}

void SymbolTable::print_table() {
        std::cout << "\n--Global Symbol Table:--\n";
        struct symbol_entry entry;
        for (auto& x: sym_table){
                entry = x.second;
                if (entry.scope == GLOBAL_VAR) {
                        std::cout << " Symbol=" << std::setw(15) << entry.symbol_name;
                        std::cout << ", IsParm=" << std::setw(2) << entry.is_param;
                        std::cout << ", SType=" << std::setw(14) << entry.type;
                        std::cout << ", ArrSize=" << std::setw(3) << entry.arr_size;
                        std::cout << ", EBP Offest=" << std::setw(4) << entry.ebp_offset;

                        std::cout << std::endl;
                }
        }
        std::cout << std::endl << std::endl;
}


void SymbolTable::add_entry(struct symbol_entry entry) {
        sym_table[entry.symbol_name] = entry;
        return;
}

bool SymbolTable::set_scope(std::string symbol_name, int depth, std::string scope_name) {
        struct symbol_entry temp;
        temp = sym_table[symbol_name];
        temp.scope = scope_name;
        sym_table[symbol_name] = temp;
        return true;
}

struct symbol_entry SymbolTable::get_entry(std::string symbol_name) {
        struct symbol_entry symbol;
        symbol = sym_table[symbol_name];
        std::cout << "Symbol: " << symbol.symbol_name << std::endl;
        return symbol;
}

bool SymbolTable::is_entry(std::string symbol_name) {
        int ret_v = sym_table.count(symbol_name);
        //std::cout << "is_entry " << symbol_name << " " << ret_v << std::endl;
        return ret_v == 1;
}

bool SymbolTable::is_entry(struct symbol_entry entry) {
        return is_entry(entry.symbol_name);
}

