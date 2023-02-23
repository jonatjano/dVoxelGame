#include "sharedLib.h"

#include <stdio.h>

SharedHandle sharedLib_load(char* path) {
    dlerror();
    SharedHandle wrapper = {.ptr = NULL, .path = path};
    wrapper.ptr = dlopen(path, RTLD_LAZY);
    char* error = dlerror();
    if (error != NULL) {
        printf("Failed to load dynamic library\n\tpath: %s,\n\terror: %s\n", path, error);
    }
    return wrapper;
}

SymbolHandle sharedLib_get(SharedHandle handle, char* symbolName) {
    dlerror();
    SymbolHandle wrapper = {.ptr = NULL, .name = symbolName};
    wrapper.ptr = dlsym(handle.ptr, symbolName);
    char* error = dlerror();
    if (error != NULL) {
        printf("Failed to load dynamic library symbol\n\tlibrary: %s\n\tname: %s,\n\terror: %s\n", handle.path, symbolName, error);
    }
    return wrapper;
}

int sharedLib_close(SharedHandle handle) {

}