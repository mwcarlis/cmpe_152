#include <cstdio>
#include <iostream>
#include <string>
#include <cstdlib>
#include <unordered_map>


void cp_add_symbol( std::string sym_name, int mem_bytes, int size, 
                                std::string type, std::string scope );
struct cp_symbol_entry get_entry(std::string sym_name);
bool cp_is_entry(std::string sym_name);
bool cp_is_entry(struct symbol_entry entry);


struct symbol_entry {
        std::string symbol_name; 

        int mem_bytes;          // Bytes per object.
        int mem_size;           // Number of elements
        std::string type;       // Symbol Type

        std::string scope;             // The name of the scope
};


class SymbolTable {
        private:
                int entries;
                std::unordered_map<std::string, symbol_entry> sym_table;
        public:

                void add_entry(struct symbol_entry item);

                struct symbol_entry get_entry(std::string symbol_name);

                bool is_entry(std::string symbol_name);
                bool is_entry(struct symbol_entry item);
};




/*
int main(void) {
        SymbolTable item;
        struct symbol_entry test_symbol;
        test_symbol.symbol_name = "Hello World";
        test_symbol.mem_bytes = 1;
        test_symbol.mem_size = 11;
        test_symbol.type = "String";

        std::cout << test_symbol.symbol_name << std::endl;
        item.add_entry(test_symbol);
        item.get_entry(test_symbol.symbol_name);

        struct symbol_entry test_symbol_2;
        test_symbol_2.symbol_name = "Weirdo";
        test_symbol_2.mem_bytes = 1;
        test_symbol_2.mem_size = 1;
        test_symbol_2.type = "String";


        std::cout << item.is_entry("Hello World") << "\t" << item.is_entry(test_symbol) << std::endl;
        std::cout << item.is_entry("World") << "\t" << item.is_entry(test_symbol_2) << std::endl;
        
        return 0;
}
*/
