json = require "json"
table = require "table"

payload = json.decode(io.open("test.json"):read("*all"))

for i, r in pairs(payload) do
    print(r.url)
    print(r.method)
    local encoded = json.encode(r.payload)
    print(encoded)
    print("size: " .. #{ string.byte(encoded, 1, -1) })
end

print(payload[1].payload)
--payload[1].post = {}
payload[1].post = { payload = json.encode(payload[1].payload) }

print(json.encode(payload[1].payload))
print(payload[1].post.payload)

local req = {}

local payload = json.encode(req.payload)

if req.payload then
    print("payload: " .. payload)
end

function table.copy(xs)
    local ys = {}
    for k, v in pairs(xs) do
        ys[k] = v
    end
    return ys
end

function table.to_string(xs)
    local str = ""
    for k, v in pairs(xs) do
        str = str .. tostring(k) .. " = " .. tostring(v) .. ", "
    end
    if #str == 0 then
        return "[]"
    else
        return "[" .. str:sub(0, -3) .. "]"
    end
end

--local xs = {
--    ["200"] = 10,
--    ["401"] = 20
--}

local xs = {}
xs["200"] = 10
xs["401"] = 20

local ys = {}
ys["200"] = 11
ys["401"] = 1


function table.merge(xs, ys, f)

    print(xs)

    local zs = table.copy(xs)

    for k, _ in pairs(ys) do
        zs[k] = f(zs[k], ys[k])
    end

    return zs
end

print("--------------")
--print(table.to_string(xs))
--print(table.to_string({}))
print(table.to_string(table.merge(xs, ys, function (x, y) return x + y end)))