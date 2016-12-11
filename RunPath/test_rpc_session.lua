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

-- The type package must has two field : type(tag) and session
local server = server_proto:host "package"
local client = client_proto:host "package"
local client_request = client:attach(server_proto)
-- local core 		= require "sproto.core"
-- core.dumpproto(server_proto.__cobj)
print("----------------------- client request 4400 -----------------------")

--关于此方法host:attach
--闭包方法相当于一个lambda函数，用固定的形参重新包装了一个函数，变成了一个简单的匿名方法
--这个匿名方法赋值给client_request,以后对client_request的call，
--相当于对client对象(表)的这个匿名方法的call
--当然如果在构造闭包的时候用了冒号运算符，这个简单的client_request还会传递隐藏的形参self

-- name必须是个rpctype
-- 如果请求带了session，则会在client上加上response
local req = client_request("foobar", { what = "my request data" }, 4400)

print("req size:", #req, ", save to request.foobar.dat")
local file = io.open( "request.foobar.dat", "w" )
file:write(req)
file:close()

--req是对rpc tag, rpc request args, session的编码和打包
--这里foobar的tag是 1; request方法是 foobar.request，参数是 {what 0 : string}, session 是 1
--session的作用是索引这个rpc的 foobar.response，也就是告诉server要用哪个response打包回应参数


print("----------------------- server dispatch 1 -----------------------")

local rpctype, name, request, response = server:dispatch(req)
assert(rpctype == "REQUEST" and name == "foobar" 
	and type(request)=="table" and type(response)=="function" )

print_r(request)



local resp = response { ok = true }
print("<< server response package size =", #resp)

print("----------------------- client gain session 4400 -----------------------")
print("client dispatch")
local rpctype, session, response = client:dispatch(resp)
assert(rpctype == "RESPONSE" and session == 4400)
print_r(response)

