echo "Recompiling ...";

echo "Compiling lib"
rm -v libmodlib.so
gcc -shared modlib/*.c -o libmodlib.so
LIBMODLIBFOLDER="$(pwd)"

echo "Compiling mods"
cd mods
rm -v *.so

echo "... dMod"
cd dMod
    dmd -oflibdmod.so *.d -shared -L-L=$LIBMODLIBFOLDER -L-lmodlib
    rm -v *.o
cd ..

echo "... cppMod"
cd cppMod
    g++ -shared -o libcppmod.so basemod.cpp modlib.cpp -lmodlib -Wl,-L,$LIBMODLIBFOLDER
cd ..

echo "... cMod"
cd cMod
    gcc -shared -o libcmod.so mod.c -lmodlib -Wl,-L,$LIBMODLIBFOLDER
cd ..

mv */*.so .
cd ..

echo "Compiling engine"
rm -v main
rm -v src/*/*.i
gcc -E src/libs/raylib.c > src/libs/raylib.i
dmd src/*.d src/*/*.d src/libs/raylib.i -ofmain -L-L/code -L-lraylib -L-lmodlib -L-L. -L-rpath='$ORIGIN/'
rm *.o

echo "Ended :)"
