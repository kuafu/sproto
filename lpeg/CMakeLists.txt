project(lpeg)

FILE(GLOB SOURCE_FILES "*.c")
FILE(GLOB HEADER_FILES "*.h" "*.inl")

add_definitions(-D_USE_EIGEN -D_USE_BOOST -D_USE_OPENMP)

add_library(lpeg
	${HEADER_FILES}
	${SOURCE_FILES}
  )

target_link_libraries (lpeg liblua )