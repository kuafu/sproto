#include <iostream>
#include <fstream>

// #include "lua.h"
// #include "lauxlib.h"
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
	if (!ifs)
		return false;

	ifs.seekg(0, ifs.end);
	int length = ifs.tellg();
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
	if (!ofs)
		return false;

	ofs.write(msg, len);
	ofs.close();
	return true;
}

// for skynet_lalloc use
#define raw_realloc realloc
#define raw_free free


void* skynet_lalloc(void *ud, void *ptr, size_t osize, size_t nsize) {
	if(nsize == 0)
	{
		raw_free(ptr);
		return NULL;
	}
	else
	{
		return raw_realloc(ptr, nsize);
	}
}

int main(int argc, char* argv[])
{
	lua_State *L = lua_newstate(skynet_lalloc, NULL);

	lua_getglobal(L, "f");		/* function to be called */
	lua_pushliteral(L, "how");	/* 1st argument */
	lua_getglobal(L, "t");		/* table to be indexed */
	lua_getfield(L, -1, "x");	/* push result of t.x (2nd arg) */
	lua_remove(L, -2);			/* remove 't' from the stack */
	lua_pushinteger(L, 14);		/* 3rd argument */
	lua_call(L, 3, 1);			/* call 'f' with 3 arguments and 1 result */
	lua_setglobal(L, "a");		/* set global 'a' */

	std::string pb;
	if (!LoadPbfile("addressbook.pb", pb))
	{
		std::cout << "open addressbook.pb failed" << std::endl;
		return -1;
	}


}

// void test
// {
// 	lua_State *L = lua_State();
// 	printf("%d\n", lua_gettop(L));
// 	lua_dostring(L, "return 1,'a'");
// 	printf("%d\n", lua_gettop(L));
// 	printf("%s\n", lua_tostring(L,-2));
// 	printf("%s\n", lua_tostring(L,-1));
// }