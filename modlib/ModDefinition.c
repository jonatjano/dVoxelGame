#include "ModDefinition.h"

#include <stdio.h>

ModDefinition* modDefinition_create(char* modName) {
	ModDefinition* modDef = calloc(1, sizeof(ModDefinition));
	modDef->name = modName;
	List* myBlocks = list_create();
	modDef->blocks = myBlocks;
}

ModDefinition* modDefinition_addBlockType(ModDefinition* modDef, BlockType* blockType) {
	printf("Registering block %s for mod %s\n", blockType->name, modDef->name);
	list_addElement(modDef->blocks, blockType);
}

void modDefinition_free(ModDefinition* modDef) {
	list_delete(modDef->blocks);
}