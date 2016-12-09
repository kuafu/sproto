local sproto = require "sproto"
local print_r = require "print_r"

local server_proto = sproto.parse [[

.package {
	type 0 : integer
	session 1 : integer
}

.usertype{
	id 0: integer
}

foobar 1 {
	request {
		what 0 : string
	}
	response {
		ok 0 : boolean
	}
}

foo 2 {
	response {
		ok 0 : boolean
	}
}

bar 3 {}

blackhole 4 {
}

testproto 122 {
}

.type {
	.field {
		name 0 : string
		buildin	1 :	integer
		type 2 : integer
		tag	3 :	integer
		array 4	: boolean
	}
	name 0 : string
	fields 1 : *field
}


]]

local client_proto = sproto.parse [[
.package {
	type 0 : integer
	session 1 : integer
}
]]

print("---------------- start dump proto ----------------")

local core = require "sproto.core"
core.dumpproto(server_proto.__cobj)

print("---------------- end dump proto ----------------")

print("")

print("---------------- start check types ----------------")
assert(server_proto:exist_type "package")
assert(server_proto:exist_type "foobar.request")
assert(server_proto:exist_type "foobar.response")
assert(server_proto:exist_type "foo.response")


print("---------------- start check protocol ----------------")

assert(server_proto:exist_proto "foobar")
assert(server_proto:exist_proto "foo")
assert(server_proto:exist_proto "bar")
assert(server_proto:exist_proto "blackhole")
assert(server_proto:exist_proto "testproto")

print("")
print("----------------------- default table -----------------------")

--print( server_proto:queryproto("foo") )
print("== package:")
print_r(server_proto:default("package"))

print("\n== foobar request:")
print_r(server_proto:default("foobar", "REQUEST"))

print("\n== foobar response:")
print_r(server_proto:default("foobar", "RESPONSE"))

assert(server_proto:default("foo", "REQUEST")==nil)
print(server_proto:default("foo", "RESPONSE"))


print("")
print("----------------------- query proto -----------------------")

local proto = server_proto:query_proto("foo")
for k,v in pairs(proto) do
	print(k,v)
end


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