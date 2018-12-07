#include<"linkedlist.h">
struct set {
    struct linkedlist list;
    int card;
    int type;
}


/* type = 0 -> int
 *      = 1 -> boolean
 *      = 2 -> char
 *      = 3 -> string
 *      = 4 -> set

struct set* create(void *tomake, int size, int type){                   // returns setPtr instead of set
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

int destroy(struct set *s){                                             // Why does function return int? - RyanC
    //not sure if the linkedlist destroy works quite well enough

    struct linkedlist *nodes = &(s->list);
    removeAllNodes(nodes);
}

struct set* add(struct set *s, void *value){                             // added setPtr as parameter - RyanC
    struct linkedlist *nodes = &(s->list);
    if (include(s,value)){                                               // used include function - RyanC
        addFront(nodes, value);
    }

    return s;
}

struct set remove(void *value, int type){                                // why do we need type? - Ryan C
    //type or not needed since passed sast?
    
    // why don't we have remove function in linkedlist.c? -Ryan C
    
}


int include(struct set *s, void *value){                                  // should return int -Ryan C
    struct linkedlist *nodes = &(s->list);
     if (findNode(nodes, value, ???) != NULL){                            // not sure about comparator - RyanC
        return 1;
     }
     
     return 0;
}

struct set complement(struct set universe){
   
}

struct set* union(struct set *A, struct set *B){                           // changed parameters to setPtrs, returns setPtr - Ryan C
    struct set *tmp; 
    struct linkedlist *tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes -> head;

    struct linkedlist *aNodes = A->list;
    struct Node *aCurr = aNodes -> head;

    struct linkedlist *bNodes = B->list;
    struct Node *bCurr = bNodes -> head;

    for (int i=0; i<(A->card); i++){
        tmpCurr->next = aCurr;
        tmpCurr = tmpCurr->next;
        aCurr = aCurr->next;
        (tmp->card)++;
    }

    for (int j=0; j<(B->card); j++){
        if (!include(tmp,bCurr)){
            tmpCurr->next = bCurr;
            tmpCurr = tmpCurr->next;
            bCurr = bCurr->next;
            (tmp->card)++;
        }
    }

    return tmp;
}

struct set intersect(struct set A, struct set B){


}
