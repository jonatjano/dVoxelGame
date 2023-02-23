#include "modlib.h"

ModDefinition* createMod();

ModDefinition* getModDefinition() {
    return createMod();
}

ModDefinition* createMod() {
    ModDefinition* modDef = modDefinition_create("C Mod");

    BlockType* myBlock = NULL;
    myBlock = blockType_create();
    myBlock->name = "love";
    myBlock->texture = "pink";
    modDefinition_addBlockType(modDef, myBlock);

    return modDef;
}