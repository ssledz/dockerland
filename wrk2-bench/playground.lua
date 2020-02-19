json = require "json"

payload = json.decode(io.open("test.json"):read("*all"))

for i,r in pairs(payload) do
    print(r.url)
    print(r.method)
    local encoded = json.encode(r.payload)
    print(encoded)
    print("size: " .. #{ string.byte(encoded, 1, -1) })
end

print(payload[1].payload)
--payload[1].post = {}
payload[1].post = {payload = json.encode(payload[1].payload) }

print(json.encode(payload[1].payload))
print(payload[1].post.payload)

local req = {}

local payload = json.encode(req.payload)

if req.payload then
    print("payload: " .. payload)
end
