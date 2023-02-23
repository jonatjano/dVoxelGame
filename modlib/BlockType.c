#include <stdlib.h>

#include "BlockType.h"

BlockType* blockType_create() {
	return calloc(1, sizeof(BlockType));
}