#include "linkedlist.h"

/*type corrosponds int,boolean,char,string,set
 * 0 -> int
 * 1 -> boolean
 * 2 -> char
 * 3 -> string
 * 4 -> set */
struct set{
    struct List list;
    int card;
    int type;
};
void *create_set(int dType);

void destroy(void *s_ptr);

int has(void *s_ptr, void *value);
int compare_int_bool_char(const void *data_sought, const void *against);
int compare_string(const void *data_sought, const void *against);
int compare_char(const void *data_sought, const void *against);
int compare_set(const void *data_sought, const void *against);
int get_card(void *A_ptr);
void *get_head(void *set_ptr);
void *get_data_from_node(void *node_ptr);
void *get_next_node(void *data);

void* add(void *s_ptr, void *value);
void* remove_elm(void *s_ptr, void *value);

void print_set(void *A_ptr);

void *complement(void *A_ptr, void *U);
void *set_union(void *A_ptr, void *B);
void *intersect(void *A_ptr, void *B);
void *copy(void *A_ptr);
void *cartesian(void *A_ptr, void *B);
