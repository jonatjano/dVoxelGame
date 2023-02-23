#include "modlib.cpp"
#include <string>

ModDefinition* createMod();

extern "C" {
    ModDefinition* getModDefinition() {
        return createMod();
    }
}

ModDefinition* createMod() {
    ModDefinition* modDef = modDefinition_create("C++ Mod");

    BlockType* myBlock;
    myBlock = blockType_create();
    myBlock->name = "Apple";
    myBlock->texture = "yellow";
    modDefinition_addBlockType(modDef, myBlock);

    return modDef;
}