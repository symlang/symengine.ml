cmake_minimum_required(VERSION 3.11)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_USER_MAKE_RULES_OVERRIDE ${CMAKE_CURRENT_SOURCE_DIR}/symengine/cmake/UserOverride.cmake)
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FCMAKE_CXX_FLAGS_RELEASELAGS_DEBUG} -Wno-unused-variable")

project(symengine.ml)

add_subdirectory(symengine)
add_subdirectory(splcore)
