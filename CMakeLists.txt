cmake_minimum_required(VERSION 3.11)

set(CMAKE_USER_MAKE_RULES_OVERRIDE ${CMAKE_CURRENT_SOURCE_DIR}/symengine/cmake/UserOverride.cmake)

project(symengine.ml)

add_subdirectory(symengine)
add_subdirectory(splcore)
