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
message(---------------------------------------------)
message(LIBRARY_OUTPUT_PATH: ${LIBRARY_OUTPUT_PATH})
message(CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR})
message(CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR})
message(CMAKE_ARCHIVE_OUTPUT_DIRECTORY: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})

#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
#SHARED 
add_library(sproto ${LIB_SRC})
target_link_libraries(sproto liblua)
#SET_TARGET_PROPERTIES(sproto PROPERTIES DEBUG_POSTFIX "D")
SET_TARGET_PROPERTIES(sproto PROPERTIES PREFIX "../")

if(WIN32)
	add_custom_command(TARGET sproto PRE_BUILD
		COMMAND if not exist ..\\RunPath mkdir ..\\RunPath)
	add_custom_command(TARGET sproto POST_BUILD
		COMMAND copy \"$(TargetPath)\" \"${CMAKE_SOURCE_DIR}/RunPath\"
		COMMAND copy \"$(OutDir)\\lua.exe\" \"${CMAKE_SOURCE_DIR}/RunPath\"
		COMMAND copy \"$(OutDir)\\lua.dll\" \"${CMAKE_SOURCE_DIR}/RunPath\"
		COMMAND copy \"$(OutDir)\\lpeg.dll\" \"${CMAKE_SOURCE_DIR}/RunPath\"
	)
	#install(TARGETS Ogitor RUNTIME DESTINATION bin CONFIGURATIONS Debug Release RelWithDebInfo MinSizeRel)
endif(WIN32)

#######################################################################################

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

