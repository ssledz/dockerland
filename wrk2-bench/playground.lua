json = require "json"

payload = json.decode(io.open("test.json"):read("*all"))

for i,r in pairs(payload) do
	print(r.url)
end
