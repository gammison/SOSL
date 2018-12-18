#include<string.h>
#include "linkedlist.h" 


struct set {
    struct List list;
    int card;
    int type;
};



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

void create(void *ptr_from_llvm, int dType){

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
            
            if(!has((struct set *)against,(void *)(&(tmpCurr->data)))){
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
    if (findNode(nodes, value,compar) != 0){// not sure about comparator - RyanC, need write compare funs
        return 1;
    }
     
    return 0;
}


struct set* add(struct set *s, void *value){                            
    struct List nodes = s->list;
    if (has(s,value)){                                              
        addFront(&nodes, value);
    }

    return s;
}

void remove(struct set *s, void *value){                              
    struct Node *tmpNode = s->list->head;
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
    struct List *tmpNodes = tmp->list;
    struct Node *tmpcurr = tmpNodes -> head;

    struct List *uNodes = U->list;
    struct Node *uCurr = uNodes -> head;


    struct set *AiU = intersect(A,U);
    for(int i=0; i<(U->card); i++){
        
        if(!has(AiU, uCurr){
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
struct set* union(struct set *A, struct set *B){                 
    struct set *tmp; 
    struct List *tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes -> head;

    struct List *aNodes = A->list;
    struct Node *aCurr = aNodes -> head;

    struct List *bNodes = B->list;
    struct Node *bCurr = bNodes -> head;

    for (int i=0; i<(U->card); i++){
        tmpCurr->next = uCurr;
        tmpCurr = tmpCurr->next;
        aCurr = uCurr->next;
        (tmp->card)++;
    }

    return tmp;
}

struct *set intersect(struct set *A, struct set *B){                  
    struct set *tmp; 
    struct List *tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes->head;

    struct List *aNodes = A->list;
    struct Node *aCurr = aNodes->head;

    struct List *bNodes = B->list;
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
    struct List *tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes->head;

    struct List *aNodes = A->list;
    struct Node *aCurr = aNodes->head;

    struct List *bNodes = B->list;
    struct Node *bCurr = bNodes->head;

    return tmp;
}
