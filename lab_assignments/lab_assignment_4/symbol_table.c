
#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <string>
#include <stack>
#include <tuple>

#include "symbol_table.h"

static std::stack<struct symbol_entry> param_qq;
static std::stack<struct symbol_entry> variable_qq;

// Parent of global is null.
static SymbolTable global = SymbolTable(NULL);
// Start with current at global.
static SymbolTable *current = &global;

void cp_add_param(int type, int param_num, std::string sym_name) {
        /*Add a parameter to the top of the param stack*/
        struct symbol_entry entry;
        if (type == 1) {
                entry.type = "Int";
                entry.param_num = param_num;
                entry.symbol_name = sym_name;
                param_qq.push(entry);
        } else {
                printf("Bad add_param type: %d\n", type);
        }
        return;
}

struct symbol_entry cp_pop_param() {
        /*Remove and get the top of the param stack*/
        struct symbol_entry entry;
        entry = param_qq.top();
        param_qq.pop();
        return entry;
}

void cp_add_variable(int type, std::string sym_name) {
        /*Add a variable to the top of the variable stack*/
        struct symbol_entry entry;
        if (type == 1) {
                entry.type = "Int";
                entry.symbol_name = sym_name;
                variable_qq.push(entry);
        } else {
                printf("Bad add_param type: %d\n", type);
        }
        return;
}

struct symbol_entry cp_pop_variable() {
        /*Remove and get the top of the variable stack*/
        struct symbol_entry entry;
        entry = variable_qq.top();
        variable_qq.pop();
        return entry;
}

void cp_add_function(std::string sym_name, std::string type,
                        int num_params, std::string ret_type) {
        struct symbol_entry entry;
        entry.symbol_name = sym_name;
        entry.type = type;
        entry.num_params = num_params;
        entry.ret_type = ret_type;
        entry.scope = "global";
        current->add_entry(entry);
        return;
}

void cp_add_symbol(struct symbol_entry entry) {
        current->add_entry(entry);
        return;
}

struct symbol_entry cp_get_entry(std::string sym_name) {
        return current->get_entry(sym_name);
}

bool cp_is_entry(std::string sym_name) {
        return current->is_entry(sym_name);
}

bool cp_is_entry(struct symbol_entry entry) {
        return current->is_entry(entry);
}

void cp_print_table() {
        current->print_table();
}

SymbolTable::SymbolTable(SymbolTable *parent) {
        parent = parent;
}

void SymbolTable::print_table() {
        std::cout << "\nPrinting Table\n";
        for (auto& x: sym_table){
                std::cout << " ";
                std::cout << x.first << ": " << x.second.type << ": " << x.second.scope << ": "  << std::endl;
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
        return ret_v == 1;
}

bool SymbolTable::is_entry(struct symbol_entry global) {
        return is_entry(global.symbol_name);
}

