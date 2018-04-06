cmake_minimum_required(VERSION 3.11)

set(CMAKE_CXX_STANDARD 17)

project(sample_cwrapper)

set(PREFIX ../build/usr/local)
find_library(symengine NAMES libsymengine.a symengine PATHS ${PREFIX}/lib)
add_executable(${PROJECT_NAME} sample.c visitor.cpp visitor.h)
target_include_directories(${PROJECT_NAME} PUBLIC ${PREFIX}/include)
target_link_libraries(${PROJECT_NAME} ${symengine} gmp)
