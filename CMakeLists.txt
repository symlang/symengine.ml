cmake_minimum_required(VERSION 3.11)

project(sample_cwrapper)

set(PREFIX ../build/usr/local)
find_library(symengine NAMES libsymengine.a symengine PATHS ${PREFIX}/lib)
add_executable(${PROJECT_NAME} sample.c)
target_include_directories(${PROJECT_NAME} PUBLIC ${PREFIX}/include)
target_link_libraries(${PROJECT_NAME} ${symengine})
