#include <cstdlib>
#include <string>
#include "symbol_table.h"


static SymbolTable sym_table;

int main(void) {
        SymbolTable sym_table;
        struct symbol_entry test_symbol;
        test_symbol.symbol_name = "Hello World";
        test_symbol.mem_bytes = 1;
        test_symbol.mem_size = 11;
        test_symbol.type = "String";

        std::cout << test_symbol.symbol_name << std::endl;
        sym_table.add_entry(test_symbol);
        sym_table.get_entry(test_symbol.symbol_name);

        struct symbol_entry test_symbol_2;
        test_symbol_2.symbol_name = "Weirdo";
        test_symbol_2.mem_bytes = 1;
        test_symbol_2.mem_size = 1;
        test_symbol_2.type = "String";


        std::cout << sym_table.is_entry("Hello World") << "\t" << sym_table.is_entry(test_symbol) << std::endl;
        std::cout << sym_table.is_entry("World") << "\t" << sym_table.is_entry(test_symbol_2) << std::endl;
        
        return 0;
}

