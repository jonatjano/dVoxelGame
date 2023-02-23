#ifndef MODLIB_LIST_H
#define MODLIB_LIST_H

#include <stdlib.h>

#include "BlockType.h"

typedef struct List {
    void* value;
    struct List* next;
} List;

/**
 * create a new list element with no value
 */
List* list_create();

/**
 * create a new list element with a value
 */
List* list_create_init(void* value);

/**
 * delete the whole list
 */
void list_delete(List* list);

/**
 * remove the head from the list
 */
List* list_deleteHead(List* list);

/**
 * delete everything in the list after the pointer
 */
List* list_deleteQueue(List* list);

/**
 * get the last element of the list
 */
List* list_end(List* list);

/*
 * add an element at the end of a list
 */
List* list_addElement(List* list, void* newValue);

/*
 * get the list size
 */
size_t list_size(List* list);

/**
 * get the element by index if it exists
 */
List* list_at(List* list, size_t index);

/**
 * remove the element from the list
 */
List* list_removeElement(List* list, List* pointer);

#endif // MODLIB_LIST_H