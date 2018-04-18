all: binding

build/build.ninja: symengine/CMakeLists.txt
	mkdir -p build && cd build && cmake ../symengine -GNinja -DBUILD_TESTS=no -DBUILD_BENCHMARKS=no -DCMAKE_INSTALL_PREFIX=.

symengine: build/build.ninja
	ninja -C build install

binding: symengine
	jbuilder build @install

clean:
	ninja -C build -t clean
	jbuilder clean

test:
	mkdir -p build && cd build && cmake ../symengine -GNinja -DBUILD_TESTS=yes -DBUILD_BENCHMARKS=yes -DCMAKE_INSTALL_PREFIX=.
	ninja -C build && ninja -C build test
	jbuilder runtest

.PHONY: all symengine binding test
