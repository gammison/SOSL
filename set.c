#include<"linkedlist.h">
struct set{
    struct linkedlist list;
    int card;
    int type;
}


/* type = 0 -> int
 *      = 1 -> boolean
 *      = 2 -> char
 *      = 3 -> string
 *      = 4 -> set
struct set create(void *tomake, int size, int type){
    if(type == 0)
        tomake = (int *)tomake;      
    if(type == 1)
        tomake = (int *)tomake;//bools are just 0s and 1s
    if(type == 2)
        tomake = (char *)tomake;
    if(type == 3)
        tomake = (char **)tomake;
    if(type == 4)
        tomake = (struct set *)tomake;
    //now we make the linked list and insert initial values
}

int destroy(struct set *){
//not sure if the linkedlist destroy works quite well enough
}
struct set add(void *value){


}

struct set remove(void *value, int type){//type or not needed since passed sast?


}


struct set include(void *value, type){

}

struct set complement(struct set universe){
   
}

struct set union(struct set A, struct set B){

}

struct set intersect(struct set A, struct set B){


}
