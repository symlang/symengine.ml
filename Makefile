all: build
	./build/sample_cwrapper

build/build.ninja: CMakeLists.txt
	mkdir -p build && cd build && cmake .. -GNinja

build:
	ninja -C build

clean:
	ninja -C build -t clean

.PHONY: all build
