local sproto = require "sproto"
local print_r = require "print_r"

local server_proto = sproto.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

foobar 77 {
	request {
		what 0 : string
	}
	response {
		ok 0 : boolean
	}
}
]]

local client_proto = sproto.parse [[
.package {
	type 0 : integer
	session 1 : integer
}
]]

-- local core 		= require "sproto.core"
-- core.dumpproto(server_proto.__cobj)

-- The type package must has two field : type(tag) and session
local server_host = server_proto:host "package"
local client = client_proto:host "package"

print("----------------------- client request -----------------------")

-- 请求与回应规则
--通过rpc head(也就是.package)信息判断是请求还是回应包，包可能附带信息:session, rpc type

--数据包需要回应, 则需要:
-- 1. 填充type，表明自己的请求身份；
-- 2. 填充 session， 表明需要回应,同时将回应的sproto_type与session建立映射关系
-- 3.填充.rpc_type.request,用于协议编码

--数据包只是一个回应包，则
-- 1.不填充type
-- 2.填充session，然对方知道是属于哪个session
-- 3.填充.rpc_type.response,用于协议编码

local req = client:request(server_proto, "foobar", { what = "my request data" }, 4400)

print("req size:", #req, ", save to request.foobar.dat")
local file = io.open( "request.foobar.dat", "w" )
file:write(req)
file:close()


print("----------------------- server dispatch 1 -----------------------")

local rpctype, name, request, response = server_host:dispatch(req)
assert(rpctype == "REQUEST" and name == "foobar" 
	and type(request)=="table" and type(response)=="function" )

print_r(request)



local resp = response { ok = true }
print("<< server_host response package size =", #resp)

print("----------------------- client gain session 4400 -----------------------")
print("client dispatch")
local rpctype, session, response = client:dispatch(resp)
assert(rpctype == "RESPONSE" and session == 4400)
print_r(response)

