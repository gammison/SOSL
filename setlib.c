#include<string.h>
#include<stdlib.h>
#include "linkedlist.h" 
#include "set.h"

/* type = 0 -> int
 *      = 1 -> boolean
 *      = 2 -> char
 *      = 3 -> string
 *      = 4 -> set

struct set* create(struct List *list, int dType){ 
    struct set *result; 
    struct List *curr = result->head; 

    result->card = 0;
    result->type = dType;
      
    while (list != 0) {
        curr = list;
        curr = curr->next;
        list = list->next;
        result->card++;
    }

    return result;

}*/

struct set *create_set(int dType){//not necessairly from llvm
    struct set *newset = malloc(sizeof(struct set));
    initList(&(newset->list));
    newset->card = 0;
    newset->type = 1;
    return newset;
}
struct Node *get_head(struct set *A){
    return (A->list).head;
}

void *get_data_from_node(struct Node *data){
    return data->data;
}

struct Node *get_next_node(struct Node *data){
    return data->next;
}

void destroy(struct set *s){                                            
    struct List nodes = s->list;
    struct Node *next = nodes.head;

    if ((s->type)==4){
        for (int i=0; i<(s->card); i++){
            struct set *temp = next->data;
            next = next->next;
            destroy(temp);
        }
    }
    else {
        removeAllNodes(&nodes);
    }
}

int compare_int_bool_char(const void *data_sought, const void *against){
//they're all the same so we just cast to int and do equivalence
    if(*(int *)data_sought != *(int *)against)
        return 1;
    return 0;
}
int compare_string(const void *data_sought, const void *against){
    return strcmp((char *)data_sought,(char *)against);
}

int compare_set(const void *data_sought, const void *against){
    int type_sought = ((struct set *)data_sought)->type;
    int type_against =((struct set *)against)->type;//will throw error if screw up types
    if(type_sought != type_against)
        return 1;//sets of different types are clearly not the same thing
    else{
        //loop over all the elements and run the right compare method
        struct Node *tmpCurr = (((struct set *)data_sought)->list).head;

        for(int i=0; i<(((struct set *)data_sought)->card); i++){
            
            if(has((struct set *)against,tmpCurr->data)==0){
                return 1;
            }
            else{
                tmpCurr= tmpCurr->next;
            }
        }
    }
    return 0;

}

int has(struct set *s, void *value){                              
    struct List *nodes = &(s->list);
    int (*compar)(const void *, const void *);
    if(s->type == 0 || s->type==1 || s->type == 2)
        compar = compare_int_bool_char;
    else if(s->type == 3)
        compar = compare_string;
    else if(s->type == 4)
        compar = compare_set;
    if (findNode(nodes, value,compar) != 0){
        return 1;
    }
     
    return 0;
}


struct set* add(struct set *s, void *value){                            
    struct List nodes = s->list;
    if (!has(s,value)){                                              
        addFront(&nodes, value);
    }

    return s;
}

void remove(struct set *s, void *value){                              
    struct Node *tmpNode = (s->list).head;
    struct Node *prev;

    while(tmpNode != 0 && tmpNode->data != value){
        prev = tmpNode; 
        tmpNode = tmpNode->next; 
    }

    if (tmpNode == 0) return; 

    prev->next = tmpNode->next; 
    free(tmpNode);
}



struct set* complement(struct set *A, struct set* U){
    struct set *tmp;
    struct List tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes.head;

    struct List uNodes = U->list;
    struct Node *uCurr = uNodes.head;


    struct set *AiU = intersect(A,U);
    for(int i=0; i<(U->card); i++){
        
        if(!has(AiU, uCurr)){
            tmpCurr->next = uCurr;
            tmpCurr = tmpCurr->next;
            uCurr = uCurr->next;
            (tmp->card)++;
        }
        else{
             uCurr = uCurr->next;
        }
    }

    return tmp;
}
struct set* copy(struct set *A){                //maybe put in a set_lib.c?
    return 0;
}

struct set* set_union(struct set *A, struct set *B){                 
    struct List aNodes = A->list;
    struct Node *aCurr = aNodes.head;

    struct List bNodes = B->list;
    struct Node *bCurr = bNodes.head;
    
    struct set *AuB=create_set(A->type); 
        
    int bigger_card = (A->card > B->card) ? A->card : B->card;
    for (int i=0; i<bigger_card; i++){
        if(i<A->card){
            add(AuB,aCurr);
            aCurr = aCurr->next;
        }
        if(i< B->card){
            add(AuB,bCurr);
            bCurr = bCurr->next;
        }
    }

    return AuB;
}

struct set *intersect(struct set *A, struct set *B){                  
    struct set *tmp; 
    struct List tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes.head;

    struct List aNodes = A->list;
    struct Node *aCurr = aNodes.head;

    struct List bNodes = B->list;
    struct Node *bCurr = bNodes.head;

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

int getCard(struct set *A){
    return A->card;
}

struct set *cartesian(struct set *A, struct set *B){                // not done -Ryan C.
    struct set *tmp; 
    struct List tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes.head;

    struct List aNodes = A->list;
    struct Node *aCurr = aNodes.head;

    struct List bNodes = B->list;
    struct Node *bCurr = bNodes.head;

    return tmp;
}
