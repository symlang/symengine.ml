cmake_minimum_required(VERSION 3.11)

set(CMAKE_CXX_STANDARD 17)

project(splcore)

execute_process(COMMAND ocamlc -where OUTPUT_VARIABLE OCAML_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)

add_library(${PROJECT_NAME} STATIC visitor.cpp visitor.h ocaml_wrapper.cpp ocaml_wrapper.h)
target_link_libraries(${PROJECT_NAME} symengine catch)
target_include_directories(${PROJECT_NAME} PUBLIC ${symengine_SOURCE_DIR} ${catch_SOURCE_DIR} ${symengine_BINARY_DIR} ${OCAML_PREFIX})

add_executable(test_splcore sample.c)
target_link_libraries(test_splcore ${PROJECT_NAME})
add_custom_command(TARGET test_splcore POST_BUILD COMMAND ${PROJECT_BINARY_DIR}/test_splcore)
# add_test(${PROJECT_NAME} ${PROJECT_BINARY_DIR}/test_splcore)
