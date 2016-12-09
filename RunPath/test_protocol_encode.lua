local sproto = require "sproto"
local print_r = require "print_r"

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


print("---------------- start dump proto ----------------")

local core = require "sproto.core"
core.dumpproto(server_proto.__cobj)


print("----------------------- default table -----------------------")


print("\n== foobar request encode:")

local req_pb, tag = server_proto:request_encode("foobar", { what="hellokitty"} )
print( #req_pb, tag )

print("\n== foobar request decode:")
local request_decode, name = server_proto:request_decode("foobar", req_pb)
print(name)
print_r(request_decode)

print("\n== foobar response encode:")
local res_pb = server_proto:response_encode("foobar", {ok = true} )
print(#res_pb)
local res_decode = server_proto:response_decode("foobar", res_pb)
print_r(res_decode)

--[[
=== 4 types ===
foo.response
	ok (0) boolean
foobar.request
	what (0) string
foobar.response
	ok (0) boolean
package
	type (0) integer
	session (1) integer
=== 4 protocol ===
	foobar (1) request:foobar.request response:foobar.response
	foo (2) request:(null) response:foo.response
	bar (3) request:(null)
	blackhole (4) request:(null)
--]]