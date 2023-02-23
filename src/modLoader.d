module modLoader;

import std.file: exists, isDir, dirEntries;

enum MOD_FOLDER_PATH = "./mods/";

alias getModDefinition_t = extern(C) ModDefinition* function();

