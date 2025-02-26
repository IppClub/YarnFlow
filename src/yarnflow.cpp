#include "yarnflow/yarn_compiler.h"
#include "yarnflow_lua.h"


#include <string>
#include <string_view>
using namespace std::string_literals;
using namespace std::string_view_literals;

extern "C" {
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"
} // extern "C"

static int yarn_compile(lua_State* L) {
	size_t len = 0;
	const char* str = luaL_checklstring(L, 1, &len);
	std::string_view codes{str, len};
	auto res = yarnflow::compile(codes);
	if (res.error) {
		const auto& error = res.error.value();
		lua_pushnil(L);
		lua_pushlstring(L, error.displayMessage.data(), error.displayMessage.size());
		lua_createtable(L, 0, 0);
		lua_pushlstring(L, error.msg.data(), error.msg.size());
		lua_rawseti(L, -2, 1);
		lua_pushinteger(L, error.line);
		lua_rawseti(L, -2, 2);
		lua_pushinteger(L, error.col);
		lua_rawseti(L, -2, 3);
		return 3;
	} else {
		lua_pushlstring(L, res.codes.c_str(), res.codes.size());
		return 1;
	}
}

extern "C" {
	int luaopen_yarnflow(lua_State* L) {
		lua_newtable(L); // mod
		lua_pushcfunction(L, yarn_compile);
		lua_setfield(L, -2, "compile");
		if (luaL_loadbuffer(L, yarnflow_lua, sizeof(yarnflow_lua), "=(yarnflow)") != LUA_OK) {
			std::string err = "failed to load yarnflow module.\n"s + lua_tostring(L, -1);
			luaL_error(L, err.c_str());
		} else { // mod modFunc
			if (lua_pcall(L, 0, 1, 0) != LUA_OK) { // modFunc(), mod initFunc
				std::string err = "failed to load yarnflow module.\n"s + lua_tostring(L, -1);
				luaL_error(L, err.c_str());
			} else { // mod initFunc
				lua_pushvalue(L, -2); // mod initFunc mod
				if (lua_pcall(L, 1, 0, 0) != LUA_OK) {
					std::string err = "failed to load yarnflow module.\n"s + lua_tostring(L, -1);
					luaL_error(L, err.c_str());
				}
			}
		}
		return 1;
	}
}
