cmake_minimum_required(VERSION 2.8)

project(Test)
include_directories(D:/SDK/lua5.3/src)
link_directories(D:/SDK/lua5.3/build/Debug)

set(LIB_SRC 
	sproto.h
	sproto.c 
	lsproto.c
)
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -g -O2")
set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
add_library(sproto SHARED ${LIB_SRC})
target_link_libraries(sproto lua.lib)


#project(demo)
link_directories(${CMAKE_SOURCE_DIR}/lib)
set(EXE_SRC 
	sproto.h
	sproto.c 
	demo.cpp 
)
#set(CMAKE_CXX_FLAGS "-Wall -g -O2")
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
add_executable(Test ${EXE_SRC})
#target_link_libraries(demo sproto)
