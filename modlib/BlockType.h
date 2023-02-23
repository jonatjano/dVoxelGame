#ifndef MODLIB_BLOCKTYPE_H
#define MODLIB_BLOCKTYPE_H

typedef struct BlockType {
	char* texture;
	char* name;
} BlockType;

BlockType* blockType_create();

#endif // MODLIB_BLOCKTYPE_H