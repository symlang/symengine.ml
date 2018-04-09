all: splcore binding

build/build.ninja: CMakeLists.txt
	mkdir -p build && cd build && cmake .. -GNinja

splcore: build/build.ninja
	ninja -C build

binding:
	jbuilder build @runtest

clean:
	ninja -C build -t clean
	jbuilder clean

.PHONY: all splcore binding
