#ifndef MODLIB_SHAREDLIB_H
#define MODLIB_SHAREDLIB_H

#include <dlfcn.h>

typedef struct SharedHandle {
    void* ptr;
    char* path; 
} SharedHandle;

typedef struct SymbolHandle {
    void* ptr;
    char* name;
} SymbolHandle;

/**
 * load a shared lib by it's name
 * @param path the path to the lib
 * @return the lib handle
 */
SharedHandle sharedLib_load(char* path);
/**
 * get a symbol from the shared lib
 * @param handle the lib handle
 * @param symbolName the name of the symbol to find
 * @return the symbol handle, must be casted to the symbol type
 */
SymbolHandle sharedLib_get(SharedHandle handle, char* symbolName);
/**
 * close the shared lib
 * @param handle the lib handle
 * @return 0 if everything went smoothly
 */
int sharedLib_close(SharedHandle handle);

#endif // MODLIB_SHAREDLIB_H