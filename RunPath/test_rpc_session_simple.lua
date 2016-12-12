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

local core 		= require "sproto.core"
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

--local req = client:request(server_proto, "foobar", { what = "my request data" }, 4400)
local proto = server_proto:query_proto("foobar")
local session = 4400
local  rpc_header = {}
rpc_header.type = proto.tag
rpc_header.session = session
rpc_header.ud = ud


local __session = {}
__session[session] = proto.response or true

local __package = assert(core.querytype(server_proto.__cobj, "package"), "type package not found")

local header = core.encode(__package, rpc_header)

local content = core.encode(proto.request, { what = "my request data" } )
local req = core.pack(header ..  content)

print("req size:", #req, ", save to request.foobar.dat")
local file = io.open( "request.foobar.dat", "w" )
file:write(req)
file:close()


print("----------------------- server dispatch 1 -----------------------")
--local rpctype, name, request, response = server_host:dispatch(req)

local bin = core.unpack(req)
local  rpc_header = {}
local header, size = core.decode(__package, bin, rpc_header)
assert(header.type == rpc_header.type and header.session == rpc_header.session,
	"rpc header not equal")
--print_r(rpc_header)
local content = bin:sub(size + 1)

local  response_pb = nil
if header.type then
	local proto = server_proto:query_proto(header.type)
	--print_r(proto)
	local result
	if proto.request then
		result = core.decode(proto.request, content)
	end
	
	--request need response
	if rpc_header.session then
		print( "REQUEST", proto.name, result, "Need RESPONSE" , header.ud )

		local  res_header = {}
		res_header.session = rpc_header.session
		res_header.type=nil
		local header = core.encode(__package, res_header)

		-------------------------- RESPONSE --------------------------
		--gen_response(self, proto.response, rpc_header.session)
		if proto.response then
			local content = core.encode(proto.response, { ok = true } )
			response_pb = core.pack(header .. content)
		end

	end
end

print("response_pb size:", #response_pb)

-- local resp = response { ok = true }
-- print("<< server_host response package size =", #resp)

print("----------------------- client dispatch -----------------------")
print("client receive response session")
-- local rpctype, session, response = client:dispatch(response_pb)
-- assert(rpctype == "RESPONSE" and session == 4400)
local bin = core.unpack(response_pb)
local rpc_header = {}
local header, size = core.decode(__package, bin, rpc_header)
local content = bin:sub(size + 1)
if not header.type then
	print("dispatch response")
	local session = assert(rpc_header.session, "session not found")
	local response = assert(__session[session], "Unknown session")
	__session[session] = nil

	if response == true then
		print("true1")
		print("RESPONSE", session, nil, header.ud)
		assert(false, "what happened?")
	else
		local result = core.decode(response, content)
		print("RESPONSE", session, result, header.ud)
		for k,v in pairs(result) do
			print(k,v)
		end
	end

end