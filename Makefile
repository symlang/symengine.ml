BIN=build/sample_cwrapper

all: build
	./build/sample_cwrapper

build/build.ninja: CMakeLists.txt
	mkdir -p build && cd build && cmake .. -GNinja

$(BIN): build/build.ninja
	ninja -C build

build: $(BIN)

clean:
	ninja -C build -t clean

.PHONY: all build
