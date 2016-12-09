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


print("\n== foobar request encode:")

local req_pb, tag = server_proto:request_encode("foobar", { what="hellokitty"} )
print( #req_pb, tag )

print("\n== foobar request decode:")
local request_decode, name = server_proto:request_decode("foobar", req_pb)
print(name)
print_r(request_decode)

