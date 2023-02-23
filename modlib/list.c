#include <stdio.h>

#include "list.h"

/**
 * create a new list element with no value
 */
List* list_create() {
    return calloc(1, sizeof(List));
}

/**
 * create a new list element with a value
 */
List* list_create_init(void* value) {
    List* val = malloc(sizeof(List));
    val->next = NULL;
    val->value = value;
    return val;
}

/**
 * delete the whole list
 */
void list_delete(List* list) {
    List* next = NULL;
    while (list != NULL) {
        next = list->next;
        free(list->value);
        free(list);
        list = next;
    }
}

/**
 * remove the head from the list
 */
List* list_deleteHead(List* list) {
    List* newHead = list->next;
    free(list->value);
    free(list);
    return newHead;
}

/**
 * delete everything in the list after the pointer
 */
List* list_deleteQueue(List* list) {
    list_delete(list->next);
    list->next = NULL;
    return list;
}

/**
 * get the last element of the list
 */
List* list_end(List* list) {
    if (list == NULL) {
        return NULL;
    }
    while (list->next != NULL) {
        list = list->next;
    }
    return list;
}

/*
 * add an element at the end of a list
 */
List* list_addElement(List* list, void* newValue) {
    if (list == NULL) {
        return NULL;
    }
    if (list->value == NULL) {
        list->value = newValue;
        return list;
    }
    while (list->next != NULL) {
        list = list->next;
    }
    List* newBlock = list_create_init(newValue);
    list->next = newBlock;
    return newBlock;
}

/*
 * get the list size
 */
size_t list_size(List* list) {
    size_t size = 0;
    while (list != NULL) {
        list = list->next;
        size++;
    }
    return size;
}

/**
 * get the element by index if it exists
 */
List* list_at(List* list, size_t index) {
    while (index-- > 0)
    {
        if (list != NULL) {
            list = list->next;
        } else {
            return NULL;
        }
    }
    return list;
}

/**
 * remove the element from the list
 */
List* list_removeElement(List* list, List* pointer) {
    if (pointer == NULL) {
        return list;
    }
    List* originalHead = list;
    List* previous = NULL;
    while (list != NULL && list != pointer) {
        previous = list;
        list = list->next;
    }
    if (list == NULL) {
        return originalHead;
    }

    if (previous == NULL) {
        // deleting head
        List* newHead = pointer->next;
        free(pointer->value);
        free(pointer);
        return newHead;
    } else {
        // deleting body part
        previous->next = pointer->next;
        free(pointer->value);
        free(pointer);
        return originalHead;
    }
}