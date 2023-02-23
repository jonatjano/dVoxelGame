import modlib;

import std.string: toStringz;
import std.stdio: writeln;

extern(C) {
    ModDefinition* getModDefinition() {
        return createMod();
    }
}

ModDefinition* createMod() {
    ModDefinition* modDef = modDefinition_create("D Mod".toStringz);

    BlockType* myBlock;
    myBlock = blockType_create();
    myBlock.name = "Apple";
    myBlock.texture = "red";
    modDefinition_addBlockType(modDef, myBlock);

    myBlock = blockType_create();
    myBlock.name = "Dirt";
    myBlock.texture = "maroon";
    modDefinition_addBlockType(modDef, myBlock);

    myBlock = blockType_create();
    myBlock.name = "Wood";
    myBlock.texture = "maroon";
    modDefinition_addBlockType(modDef, myBlock);

    myBlock = blockType_create();
    myBlock.name = "Leave";
    myBlock.texture = "lime";
    modDefinition_addBlockType(modDef, myBlock);

    return modDef;
}