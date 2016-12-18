#include <iostream>
#include <fstream>
#include <assert.h>

extern "C"
{
#include "lua.h"
#include "luaconf.h"
#include "lauxlib.h"
#include "lualib.h"
}

bool LoadPbfile(const char* filename, std::string& pb)
{
	std::ifstream ifs(filename, std::ifstream::binary);
	if(!ifs)
		return false;

	ifs.seekg(0, ifs.end);
	int length = (int)ifs.tellg();
	ifs.seekg(0, ifs.beg);
	pb.resize(length, ' ');

	char* begin = &*pb.begin();
	ifs.read(begin, length);
	ifs.close();

	return true;
}

bool SaveMsgfile(const char* filename, const char* msg, size_t len)
{
	std::ofstream ofs(filename, std::ofstream::binary);
	if(!ofs)
		return false;

	ofs.write(msg, len);
	ofs.close();
	return true;
}

void testhow(lua_State* L)
{
	/* lua
	t = { x = 8 }

	function f(...)
	print(...)
	return 888
	end
	*/

	// a = f("how", t.x, 14)
	lua_getglobal(L, "f");		/* function to be called */
	lua_pushliteral(L, "how");	/* 1st argument */
	lua_getglobal(L, "t");		/* table to be indexed */
	lua_getfield(L, -1, "x");	/* push result of t.x (2nd arg) */
	lua_remove(L, -2);			/* remove 't' from the stack */
	lua_pushinteger(L, 14);		/* 3rd argument */
	lua_call(L, 3, 1);			/* call 'f' with 3 arguments and 1 result */

	lua_setglobal(L, "a");		/* set global 'a' */

	//////////////////////////////////////////////////////////////////////////
	lua_getglobal(L, "a");
	int x = luaL_checkinteger(L, 1);
	assert(x == 888);
}


bool init(lua_State *L, const char* file)
{
	luaL_openlibs(L);	//! 

	int ret = luaL_dofile(L, file);
	if(ret != 0)
	{
		printf("Error occurs when calling luaL_dofile() Hint Machine 0x%x\n", ret);
		printf("Error: %s", lua_tostring(L, -1));
		return false;
	}


	return true;
}



int main(int argc, char* argv[])
{
	lua_State *L = luaL_newstate();  /* create state */

	init(L, "init.lua");
	testhow(L);

	//lua_State *L = lua_newstate(skynet_lalloc, NULL);

	std::string pb;
	if(!LoadPbfile("addressbook.pb", pb))
	{
		std::cout << "open addressbook.pb failed" << std::endl;
		return -1;
	}


}
