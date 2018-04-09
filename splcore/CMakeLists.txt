cmake_minimum_required(VERSION 3.11)

set(CMAKE_CXX_STANDARD 17)

project(splcore)

execute_process(COMMAND ocamlc -where OUTPUT_VARIABLE OCAML_PREFIX)

add_library(${PROJECT_NAME} STATIC visitor.cpp visitor.h ocaml_wrapper.cpp ocaml_wrapper.h)
target_link_libraries(${PROJECT_NAME} symengine catch)
target_include_directories(${PROJECT_NAME} PUBLIC ${symengine_SOURCE_DIR} ${catch_SOURCE_DIR} ${symengine_BINARY_DIR} ${OCAML_PREFIX})

add_executable(test sample.c)
target_link_libraries(test ${PROJECT_NAME})
