FROM ubuntu:jammy

RUN apt update && \
	apt install -y wget && \
	wget https://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list && \
	apt-get update --allow-insecure-repositories && \
	apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring && \
	apt-get update && \
	apt-get install -y dmd-compiler dub

RUN apt update && \
	apt install -y build-essential git cmake libasound2-dev mesa-common-dev libx11-dev libxrandr-dev libxi-dev xorg-dev libgl1-mesa-dev libglu1-mesa-dev

RUN git clone https://github.com/raysan5/raylib.git raylib && \
	cd raylib && \
	mkdir build && cd build && \
	cmake -DBUILD_SHARED_LIBS=OFF .. && \
	make && \
	make install

RUN apt install -y gdc

RUN apt install -y inotify-tools

RUN apt install -y nano

RUN echo "alias rdmda='rdmd \$(find src -name \"*.d\" -printf \"%p \")'" >> ~/.bashrc
