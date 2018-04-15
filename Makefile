all: symengine binding

build/build.ninja: symengine/CMakeLists.txt
	mkdir -p build && cd build && cmake ../symengine -GNinja

symengine: build/build.ninja
	ninja -C build

binding:
	jbuilder build @runtest

clean:
	ninja -C build -t clean
	jbuilder clean

.PHONY: all symengine binding
