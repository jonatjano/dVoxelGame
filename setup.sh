if [ -d "raylib" ] 
then
	cd raylib
	git pull
	rm -r build
else
	git clone https://github.com/raysan5/raylib.git raylib
	cd raylib
fi

mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=OFF ..
make
make install

cd ../..
rm -r raylib
