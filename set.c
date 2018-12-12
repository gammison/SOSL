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

struct set* create(void *tomake, int size, int type){                 
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

void destroy(struct set *s){                                            
    struct linkedlist *nodes = s->list;
    struct linkedlist *next;

    if ((s->type)==4){
        for (int i=0; i<(s->card); i++){
            next = nodes->next;
            destroy(nodes);
            nodes = next;
        }
    }
    else {
        removeAllNodes(nodes);
    }
}

struct set* add(struct set *s, void *value){                            
    struct linkedlist *nodes = s->list;
    if (has(s,value)){                                              
        addFront(nodes, value);
    }

    return s;
}

void remove(struct set *s, void *value){                              
    struct Node *tmpNode = s->list->head;
    struct Node *prev;

    while(tmpNode != NULL && tmpNode->data != key){
        prev = tmpNode; 
        tmpNode = tmpNode->next; 
    }

    if (tmpNode == NULL) return; 

    prev->next = tmpNode->next; 
    free(tmpNode);
}


int has(struct set *s, void *value){                              
    struct linkedlist *nodes = &(s->list);
     if (findNode(nodes, value, ???) != NULL){                        // not sure about comparator - RyanC
        return 1;
     }
     
     return 0;
}

struct set complement(struct set universe){
   
}

struct set* union(struct set *A, struct set *B){                 
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
        if (!has(tmp,bCurr)){
            tmpCurr->next = bCurr;
            tmpCurr = tmpCurr->next;
            bCurr = bCurr->next;
            (tmp->card)++;
        }
    }

    return tmp;
}

struct *set intersect(struct set *A, struct set *B){                  
    struct set *tmp; 
    struct linkedlist *tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes->head;

    struct linkedlist *aNodes = A->list;
    struct Node *aCurr = aNodes->head;

    struct linkedlist *bNodes = B->list;
    struct Node *bCurr = bNodes->head;

    for (int i=0; i<(A->card); i++){
        for (int j=0; j<(B->card); j++){
            if(aCurr == bCurr){
                tmpCurr->next = aCurr;
                tmpCurr = tmpCurr->next;
            }
            bCurr = bCurr->next;
        }
        aCurr = aCurr->next;
    }

    return tmp;
}

struct *set cartesian(struct set *A, struct set *B){                // not done -Ryan C.
    struct set *tmp; 
    struct linkedlist *tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes->head;

    struct linkedlist *aNodes = A->list;
    struct Node *aCurr = aNodes->head;

    struct linkedlist *bNodes = B->list;
    struct Node *bCurr = bNodes->head;

    return tmp;
}