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
local core 		= require "sproto.core"
local server = server_proto:host "package"
local client = client_proto:host "package"
--local client_request = client:attach(server_proto)
--core.dumpproto(server_proto.__cobj)


function encode_header(name, session)
	local proto = server_proto:query_proto(name)

	local rpc_header={}
	rpc_header.type = proto.tag
	rpc_header.session = session
	
	local __package = assert(core.querytype(server_proto.__cobj, "package"), "type package not found")
	local buffer = core.encode(__package, rpc_header)

	return core.pack(buffer)
end

function decode_header(...)
	local bin = core.unpack(...)

	local  rpc_header = {}
	-- rpc_header.tag = nil
	-- rpc_header.session = nil
	-- rpc_header.ud = nil

	local __package = assert(core.querytype(server_proto.__cobj, "package"), "type package not found")

	local header, size = core.decode(__package, bin, rpc_header)
	print("header:", rpc_header.tag, rpc_header.session, rpc_header.ud)
	for k, v in pairs( rpc_header ) do
		print( k, v )
	end
	print("rpc header:", header.type, header.session, size)
end

print("----------------------- query proto -----------------------")

local proto_package = server_proto:query_proto("foobar")
for k, v in pairs( proto_package ) do
	print( k, v )
end

print("----------------------- encode header -----------------------")
local header = encode_header("foobar", 4400)

print("header size:", #header, ", save to rpc_foobar_header.dat")
local file = io.open( "request.foobar.dat", "w" )
file:write(header)
file:close()


print("----------------------- decode header -----------------------")
decode_header(header)

