#include <stddef.h>

typedef struct List { void* value; struct List* next; } List;
List* list_create();
List* list_create_init(void* value);
void list_delete(List* list);
List* list_deleteHead(List* list);
List* list_deleteQueue(List* list);
List* list_end(List* list);
List* list_addElement(List* list, void* newValue);
size_t list_size(List* list);
List* list_at(List* list, size_t index);
List* list_removeElement(List* list, List* pointer);

typedef struct Color { char r; char g; char b; char a; } Color;

typedef struct BlockType { const char* texture; const char* name; } BlockType;
BlockType* blockType_create();

typedef struct ModDefinition {
    const char* name;
    List* blocks;
} ModDefinition;

ModDefinition* modDefinition_create(const char* modName);
ModDefinition* modDefinition_addBlockType(ModDefinition* modDef, BlockType* blockType);