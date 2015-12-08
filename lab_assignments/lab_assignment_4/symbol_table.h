#include <cstdio>
#include <iostream>
#include <string>
#include <cstdlib>
#include <unordered_map>


void cp_add_param(int type, int param_num, int size, std::string id);
struct symbol_entry cp_pop_param();
struct symbol_entry cp_pop_variable();
void cp_add_variable(int type, std::string sym_name, int size);
void cp_add_function( std::string sym_name, std::string type,
                                        int num_params, std::string ret_type);
void cp_add_symbol(struct symbol_entry entry);
struct cp_symbol_entry get_entry(std::string sym_name);
bool cp_is_entry(std::string sym_name);
bool cp_is_entry(struct symbol_entry entry);
void cp_print_table();


struct symbol_entry {
        std::string symbol_name;        // Symbol Name (Required)
        std::string type;               // Symbol Type (Required)
        int unit_size;                  // The bytes of single unit. (Non-Func)
        int arr_size;                  // Number of bytes. (Non-Func)
        int ebp_offset;
        int scope_depth;
        bool is_param;
        std::string init_val;           // The initial value. (Non-Func)
        std::string scope;              // The name of the scope. (Required)
        int num_params;                 // The number of params. (Func only)
        std::string ret_type;           // The return type. (Func only)
        int param_num;                  // The param number. (Func only)
};


class SymbolTable {
        private:
                int entries;
                std::unordered_map<std::string, struct symbol_entry> sym_table;
                std::string scope;
        public:
                SymbolTable(std::string scope);
                void add_entry(struct symbol_entry entry);
                bool set_scope(
                        std::string symbol_name,
                        int depth,
                        std::string scope_name
                );
                void print_table(void);

                struct symbol_entry get_entry(std::string symbol_name);
                bool is_entry(std::string symbol_name);
                bool is_entry(struct symbol_entry item);

                bool operator==(const SymbolTable &other) const {
                        return (other.scope == scope);
                }
};

