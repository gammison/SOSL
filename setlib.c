#include<string.h>
#include<stdlib.h>
#include<stdio.h>
#include "setlib.h"

/* type = 0 -> int
 *      = 1 -> boolean
 *      = 2 -> char
 *      = 3 -> string
 *      = 4 -> set
 *      = 5 -> void

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

void *create_set(int dType){  //not necessairly from llvm
    struct set *newset = malloc(sizeof(struct set));
    initList(&(newset->list));
    newset->card = 0;
    newset->type = 1;
    return (void *) newset;
}

void *get_head(void *set_ptr){
    struct set *s = (struct set *) set_ptr;                          

    return (void *) (s->list).head;
}

void *get_data_from_node(void *node_ptr){
    struct Node *node = (struct Node *) node_ptr; 
    return node->data;
}

void *get_next_node(void *node_ptr){
    struct Node *node = (struct Node *) node_ptr; 

    return (void *) node->next;
}

void destroy(void *set_ptr){            
    struct set *s = (struct set *) set_ptr;  

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

int has(void *set_ptr, void *value){    
    struct set *s = (struct set *) set_ptr;                          

    struct List *nodes = &(s->list);
    int (*compar)(const void *, const void *);
    if(s->type == 0 || s->type==1 || s->type == 2)
        compar = compare_int_bool_char;
    else if(s->type == 3)
        compar = compare_string;
    else if(s->type == 4)
        compar = compare_set;
    if (findNode(nodes, value, compar) != 0){
        return 1;
    }
     
    return 0;
}

int has_const(void *set_ptr, int value){
    return has(set_ptr, &value);
}


void *adds(void *set_ptr, void *value){  
    struct set *s = (struct set *) set_ptr;                          
    struct List nodes = s->list;

    if (!has(s,value)){                                              
        addFront(&nodes, value);
    }

    return (void *) s;
}

void *remove_elm(void *set_ptr, void *value){   
    struct set *s = (struct set *) set_ptr;                               
    struct Node *tmpNode = (s->list).head;
    struct Node *prev;

    while(tmpNode != 0 && tmpNode->data != value){
        prev = tmpNode; 
        tmpNode = tmpNode->next; 
    }

    if (tmpNode == 0) return (void *) s; 

    prev->next = tmpNode->next; 
    free(tmpNode);
    return (void *) s;
}



void *complement(void *A_ptr, void* U_ptr){
    struct set *A = (struct set *) A_ptr;   
    struct set *U = (struct set *) U_ptr;  

    struct set *tmp = create_set(A->type);
    struct List tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes.head;

    struct List uNodes = U->list;
    struct Node *uCurr = uNodes.head;


    struct set *AiU = intersect(A,U);
    for(int i=0; i<(U->card); i++){
        
        if(!has(AiU, uCurr->data)){
            adds(tmp, uCurr->data); 
        }
        uCurr = uCurr->next;
    }
    destroy(AiU);
    return (void *) tmp;
}
void* copy(void *A){                //maybe put in a set_lib.c?
    return 0;
}

void* set_union(void *A_ptr, void *B_ptr){       
    struct set *A = (struct set *) A_ptr;   
    struct set *B = (struct set *) B_ptr; 

    struct List aNodes = A->list;
    struct Node *aCurr = aNodes.head;

    struct List bNodes = B->list;
    struct Node *bCurr = bNodes.head;
    
    struct set *AuB=create_set(A->type); 
        
    int bigger_card = (A->card > B->card) ? A->card : B->card;
    for (int i=0; i<bigger_card; i++){
        if(i<A->card){
            adds(AuB,aCurr);
            aCurr = aCurr->next;
        }
        if(i< B->card){
            adds(AuB,bCurr);
            bCurr = bCurr->next;
        }
    }

    return (void *) AuB;
}
int compare(void *Adata, void *Bdata, int type){
    if(type == 0 || type == 1 || type == 2)
        return compare_int_bool_char(Adata,Bdata);
    else if(type == 3)
        return compare_string(Adata,Bdata);
    else if(type == 4)
        return compare_set(Adata,Bdata);

    return -1;
}
void *intersect(void *A_ptr, void *B_ptr){    
    struct set *A = (struct set *) A_ptr;   
    struct set *B = (struct set *) B_ptr;   

    struct set *tmp = create_set(A->type); 

    struct List aNodes = A->list;
    struct Node *aCurr = aNodes.head;

    struct List bNodes = B->list;
    struct Node *bCurr = bNodes.head;
    
    int larger_card; 
    A->card > B->card ? (larger_card = A->card):(larger_card = B-> card);
    int smaller_card; 
    A->card <= B->card ? (smaller_card = A->card) : (smaller_card = B->card);
    for (int i=0; i<smaller_card; i++){
        for (int j=0; j<larger_card; j++){
            if(compare(aCurr->data,bCurr->data, A->type) == 0){
                adds(tmp, A->card > B->card ? aCurr->data: bCurr->data);
            }
            A->card > A->card ? (bCurr = bCurr->next):(aCurr = aCurr->next);
        }
        A->card <= B->card ? (aCurr = aCurr->next):(bCurr = bCurr->next);
    }

    return (void *) tmp;
}

int get_card(void *A_ptr){
    struct set *A = (struct set *) A_ptr;   

    return A->card;
}

void *cartesian(void *A_ptr, void *B_ptr){                // not done -Ryan C.
    struct set *A = (struct set *) A_ptr;   
    struct set *B = (struct set *) B_ptr;   

    
    struct set *tmp; 
    struct List tmpNodes = tmp->list;
    struct Node *tmpCurr = tmpNodes.head;

    struct List aNodes = A->list;
    struct Node *aCurr = aNodes.head;

    struct List bNodes = B->list;
    struct Node *bCurr = bNodes.head;

    return tmp;
}

void print_set(void *A_ptr){
    struct set *A = (struct set *) A_ptr;   
    printf(":{");
    struct Node *Acurr = A->list.head;
    for(int i = 0; i<get_card(A); i++){
        int typ = A->type;
        if(i < get_card(A) - 1){
            if(typ == 0)
                printf("%d,",*((int *)Acurr->data));
            else if(typ == 1)
                printf(*((int *)Acurr->data) == 0 ? "false," : "true,");
            else if(typ == 2)
                printf("%c,",*((char *)Acurr->data));
            else if(typ == 3)
                printf("%s,",(char *)(Acurr->data));
            else if(typ == 4)
                print_set(Acurr->data);
        }
        else{
            if(typ == 0)
                printf("%d",*((int *)Acurr->data));
            else if(typ == 1)
                printf((*(int *)Acurr->data) == 0 ? "false" : "true");
            else if(typ == 2)
                printf("%c",*((char *)Acurr->data));
            else if(typ == 3)
                printf("%s",(char *)(Acurr->data));
            else if(typ == 4)
                print_set(Acurr->data);
        }
        Acurr = Acurr->next;
    }
}
