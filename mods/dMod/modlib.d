module modlib;

extern(C) {
	struct List { void* value; List* next; }
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

	struct Color { char r; char g; char b; char a; }

	struct BlockType { const(char)* texture; const(char)* name; }
	BlockType* blockType_create();

	struct ModDefinition {
		const(char)* name;
		List* blocks;
	}

	ModDefinition* modDefinition_create(const(char)* modName);
	ModDefinition* modDefinition_addBlockType(ModDefinition* modDef, BlockType* blockType);
}