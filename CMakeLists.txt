cmake_minimum_required(VERSION 3.10)
project(yarnflow CXX)

set(LUA_LIBDIR ${LUA_INCDIR}/../lib ${LUA_INCDIR}/../../lib)
set(LUA_INCLUDE_DIR "${LUA_INCDIR}")

get_filename_component(LUA_EXEC_NAME ${LUA} NAME)
if (LUA_EXEC_NAME STREQUAL "luajit")
	find_library(LUA_LIBRARIES
		NAMES luajit libluajit
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.4" OR LUA_EXEC_NAME MATCHES "lua54")
	find_library(LUA_LIBRARIES
		NAMES lua54 lua5.4 liblua54 liblua5.4 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.3" OR LUA_EXEC_NAME MATCHES "lua53")
	find_library(LUA_LIBRARIES
		NAMES lua53 lua5.3 liblua53 liblua5.3 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.2" OR LUA_EXEC_NAME MATCHES "lua52")
	find_library(LUA_LIBRARIES
		NAMES lua52 lua5.2 liblua52 liblua5.2 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.1" OR LUA_EXEC_NAME MATCHES "lua51")
	find_library(LUA_LIBRARIES
		NAMES lua51 lua5.1 liblua51 liblua5.1 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
else ()
	find_library(LUA_LIBRARIES
		NAMES lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
endif()

if (LUA_LIBRARIES MATCHES "LUA_LIBRARIES-NOTFOUND")
	find_package(Lua)
	if (LUA_FOUND)
		set(LUA_LIBRARIES "${LUA_LIBRARY}")
	endif()
else ()
	message(STATUS "Lua: using information from luarocks")
endif()

message(STATUS "Lua: " ${LUA})
message(STATUS "Lua include: " ${LUA_INCLUDE_DIR})
message(STATUS "Lua library: ${LUA_LIBRARIES}")

enable_language(CXX)
include_directories(src ${LUA_INCLUDE_DIR})
add_definitions(-std=c++17 -O3 -fPIC)

if (APPLE)
	add_compile_options(-Wno-deprecated-declarations)
endif ()

add_library(libyarnflow MODULE
	src/ast.cpp
	src/parser.cpp
	src/yarnflow/yarn_compiler.cpp
	src/yarnflow.cpp
)
set_target_properties(libyarnflow PROPERTIES PREFIX "")
set_target_properties(libyarnflow PROPERTIES OUTPUT_NAME "yarnflow")
target_link_libraries(libyarnflow ${LUA_LIBRARIES})

install(CODE "")
