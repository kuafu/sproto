cmake_minimum_required(VERSION 2.8)

project(Test)
include_directories(lua5.3/src)
#link_directories(D:/SDK/lua5.3/build/Debug)

set(LIB_SRC 
	sproto.h
	sproto.c 
	lsproto.c
)
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -g -O2")

set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
#SHARED 
add_library(sproto ${LIB_SRC})
target_link_libraries(sproto liblua)

link_directories(${CMAKE_SOURCE_DIR}/lib)
set(EXE_SRC 
	sproto.h
	sproto.c 
	demo.cpp 
)
#set(CMAKE_CXX_FLAGS "-Wall -g -O2")
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
add_executable(Test ${EXE_SRC})
#target_link_libraries(Test sproto)

add_subdirectory(lua5.3)

add_library(bit32 SHARED lbitlib.c )
target_link_libraries(bit32 liblua)

add_subdirectory(lpeg)