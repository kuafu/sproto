local sproto = require "sproto"
local print_r = require "print_r"

local server_proto = sproto.parse [[

foobar 1 {
	request {
		what 0 : string
	}
	response {
		ok 0 : boolean
	}
}

]]

local sproto = {}

local weak_mt = { __mode = "kv" }
local host_mt = { __index = host }
local sproto_mt = { __index = sproto }

function sproto_mt:__gc()
	print("begin __gc",self)
end

print("------")
function sproto.new(bin)
	local cobj = "assert(core.newproto(bin))__"
	local self = {
		__cobj = cobj,
		__tcache = setmetatable( {} , weak_mt ),
		__pcache = setmetatable( {} , weak_mt ),
	}
	return setmetatable(self, sproto_mt)
end

function sproto.parse(ptext)
	--local parser = require "sprotoparser"
	local pbin = "parser.parse(ptext)"
	return sproto.new(pbin)
end

function sproto:test(v)
	print("sproto.test", self, v)
end

function sproto:host( packagename )
	packagename = packagename or  "package"
	local obj = {
		__proto = self,
		--__package = assert(core.querytype(self.__cobj, packagename), "type package not found"),
		__package = packagename,
		__session = {},
	}
	return setmetatable(obj, host_mt)
end


local server_proto = sproto.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

foobar 1 {
	request {
		what 0 : string
	}
	response {
		ok 0 : boolean
	}
}
]]

-- print(server_proto)
-- for k,v in pairs(server_proto) do
-- 	print(k,v)
-- end

--collectgarbage "stop"

print("server_proto:", server_proto)

local server = server_proto:host()

--server_proto:__gc()
--print(server)

print("END")