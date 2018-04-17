all: binding

build/build.ninja: symengine/CMakeLists.txt
	mkdir -p build && cd build && cmake ../symengine -GNinja -DBUILD_BENCHMARKS=no -DCMAKE_INSTALL_PREFIX=.

symengine: build/build.ninja
	ninja -C build install

binding: symengine
	jbuilder build @runtest

clean:
	ninja -C build -t clean
	jbuilder clean

.PHONY: all symengine binding
