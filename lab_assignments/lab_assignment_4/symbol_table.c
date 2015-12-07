
#include <cstdlib>
#include <cstdio>
#include <string>
#include "symbol_table.h"

static SymbolTable item;

void cp_add_symbol( std::string sym_name, int mem_bytes, int size,
                                std::string type, std::string scope ) {
        struct symbol_entry entry;
        entry.symbol_name = sym_name;
        entry.mem_bytes = mem_bytes;
        entry.mem_size = size;
        entry.type = type;
        entry.scope = scope;
        item.add_entry(entry);
        return;
}

struct symbol_entry cp_get_entry(std::string sym_name) {
        return item.get_entry(sym_name);
}

bool cp_is_entry(std::string sym_name) {
        return item.is_entry(sym_name);
}

bool cp_is_entry(struct symbol_entry entry) {
        return item.is_entry(entry);
}

void SymbolTable::add_entry(struct symbol_entry item) {
        sym_table[item.symbol_name] = item;
        return;
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

bool SymbolTable::is_entry(struct symbol_entry item) {
        return is_entry(item.symbol_name);
}

/*

int main(void) {
        struct symbol_entry test_symbol;
        test_symbol.symbol_name = "Hello World";
        test_symbol.mem_bytes = 1;
        test_symbol.mem_size = 11;
        test_symbol.type = "String";

        std::cout << test_symbol.symbol_name << std::endl;
        add_symbol("Hello World", 1, 11, "String", "global");
        get_entry(test_symbol.symbol_name);

        struct symbol_entry test_symbol_2;
        test_symbol_2.symbol_name = "Weirdo";
        test_symbol_2.mem_bytes = 1;
        test_symbol_2.mem_size = 1;
        test_symbol_2.type = "String";


        std::cout << is_entry("Hello World") << "\t" << is_entry(test_symbol) << std::endl;
        std::cout << is_entry("World") << "\t" << is_entry(test_symbol_2) << std::endl;
        
        return 0;
}


*/
