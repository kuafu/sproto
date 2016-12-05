--package.cpath = "debug/?.dll"
local sproto 	= require "sproto"
local core 		= require "sproto.core"
local print_r 	= require "print_r"

------------------------------------------
-- pb
local parser = require "sprotoparser"
local pbin = parser.parse [[
.Person {
	name 0 : string
	id 1 : integer
	email 2 : string

	.PhoneNumber {
		number 0 : string
		type 1 : integer
	}

	phone 3 : *PhoneNumber
}

.AddressBook {
	person 0 : *Person(id)
	others 1 : *Person
}
]]

file = io.open("addressbook.pb", "w")
file:write(pbin)
file:close()

--------------------------------------------
-- local sp = sproto.parse [[
-- .Person {
-- 	name 0 : string
-- 	id 1 : integer
-- 	email 2 : string

-- 	.PhoneNumber {
-- 		number 0 : string
-- 		type 1 : integer
-- 	}

-- 	phone 3 : *PhoneNumber
-- }

-- .AddressBook {
-- 	person 0 : *Person(id)
-- 	others 1 : *Person
-- }
-- ]]

local sp  = sproto.new(pbin)


-- print("start core.dumpproto(sp.__cobj)")
-- -- core.dumpproto only for debug use
-- --sp.__cobj引用c中的sproto对象
-- core.dumpproto(sp.__cobj)
-- print("")
-- print("end dump")
-- print("----------------------------------------------")
-- print("")


local def = sp:default "Person"
print("default table for Person")
print_r(def)

local ab = {
	person = {
		[10000] = {
			name = "Alice",
			id = 10000,
			phone = {
				{ number = "123456789" , type = 1 },
				{ number = "87654321" , type = 2 },
			}
		},
		[20000] = {
			name = "Bob",
			id = 20000,
			phone = {
				{ number = "01234567890" , type = 3 },
			}
		}
	},
	others = {
		{
			name = "Carol",
			id = 30000,
			phone = {
				{ number = "9876543210" },
			}
		},
	}
}

collectgarbage "stop"

print("1---------------------------------------------------")
local code = sp:encode("AddressBook", ab)
file = io.open("addressbook_encode.dat", "w")
file:write(code)
file:close()

print("2---------------------------------------------------")
local addr = sp:decode("AddressBook", code)
print("3---------------------------------------------------")
print_r(addr)
