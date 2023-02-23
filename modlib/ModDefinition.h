// Version 0.0.0

#include <stdlib.h>

#include "raylibTypedef.h"
#include "BlockType.h"
#include "list.h"

typedef struct ModDefinition {
	/**
	 * [a-z][a-z0-9_]*
	 */
	char* name;
	/**
	 * List<BlockType>
	 */
	List* blocks;
} ModDefinition;

ModDefinition* modDefinition_create(char* modName);
ModDefinition* modDefinition_addBlockType(ModDefinition* modDef, BlockType* blockType);
void modDefinition_free(ModDefinition* modDef);