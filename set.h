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
void create_set(void *ptr_from_llvm, int dType);

void destroy(struct set *s);

int has(struct set *s, void *value);
int compare_int_bool_char(const void *data_sought, const void *against);
int compare_string(const void *data_sought, const void *against);
int compare_char(const void *data_sought, const void *against);
int compare_set(const void *data_sought, const void *against);

struct set* add(struct set *s, void *value);
void remove(struct set *s, void *value);

struct set *complement(struct set *A, struct set *U);
struct set *set_union(struct set *A, struct set *B);
struct set *intersect(struct set *A, struct set *B);
struct set *copy(struct set *A);
struct set *cartesian(struct set *A, struct set *B);

