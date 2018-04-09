cmake_minimum_required(VERSION 3.11)

set(CMAKE_CXX_STANDARD 17)

project(sample_cwrapper)

execute_process(COMMAND ocamlc -where OUTPUT_VARIABLE OCAML_PREFIX)

set(SYMENGINE_ROOT ..)
set(SYMENGINE_PREFIX ${SYMENGINE_ROOT}/build/usr/local)
find_library(symengine NAMES libsymengine.a symengine PATHS ${PREFIX}/lib)
add_library(splcore STATIC visitor.cpp visitor.h ocaml_wrapper.cpp ocaml_wrapper.h)
target_include_directories(splcore PRIVATE ${SYMENGINE_ROOT})
target_include_directories(splcore PUBLIC ${SYMENGINE_PREFIX}/include ${OCAML_PREFIX})
target_link_libraries(splcore ${symengine} gmp)

add_executable(${PROJECT_NAME} sample.c)
target_link_libraries(${PROJECT_NAME} splcore)
