#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "mylist.h"

struct Node *addFront(struct List *list, void *data){
       
        struct Node *node = malloc(sizeof(struct Node));
        node->data = data;
        node->next = list->head; 
        list->head = node;
        return list->head;

}
void traverseList(struct List *list, void(*f)(void *)){        
    
    struct Node *tmp = list->head;
    while(tmp != NULL){
        (*f)(tmp->data);
        tmp = tmp->next;
    }
}
void flipSignDouble(void *data){

    double *d = data;
    *d = -1 * (*d); 

}
int compareDouble(const void *data1, const void *data2){

    
    if(*(double *)data1 == *(double *)data2){
        return 0;
    }
    else{
        return 1;
    }
}
struct Node *findNode(struct List *list, const void *dataSought, int (*compar)(const void *, const void *)){
    
    struct Node *tmp = list->head;
    
    while(tmp){
        if((*compar)(dataSought, tmp->data) == 0){
            return tmp;
        }
        tmp = tmp->next;
    }  
    return NULL;
        
}
void *popFront(struct List *list){
        
        
        if(list->head == 0){
            return NULL;
        }  
        void *data;
        struct Node *n = list->head;
        list->head = list->head->next;
        data = n->data;
        free(n);
        return data;
        
}
void removeAllNodes(struct List *list){

    while(list->head != NULL){
        popFront(list);
    }   
}
struct Node *addAfter(struct List *list, struct Node *prevNode, void *data){
    
    struct Node *node = malloc(sizeof(struct Node));
   
    if(prevNode == NULL){
        list->head= node;
        return list->head;
    }
    prevNode->next = node;
    return prevNode->next;
    
}
void reverseList(struct List *list){

    struct Node *prv;
    struct Node *cur = list->head;
    struct Node *nxt;
    prv = NULL;
    nxt = NULL;

    while(cur){
        nxt = cur->next;
        cur->next = prv;
        prv = cur;
        cur = nxt;
    }
    cur = prv;
    list->head = cur;
}
