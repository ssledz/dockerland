json = require "json"

math.randomseed(os.time())

function table.copy(xs)
    local ys = {}
    for k, v in pairs(xs) do
        ys[k] = v
    end
    return ys
end

function table.to_string(xs)

    local str = ""
    for k, v in pairs(xs or {}) do
        str = str .. tostring(k) .. " = " .. tostring(v) .. ", "
    end
    if #str == 0 then
        return xs and "[]" or "null"
    else
        return "[" .. str:sub(0, -3) .. "]"
    end
end

function table.swap(xs)
    local ys = {}
    for k, v in pairs(xs) do
        ys[v] = k
    end
    return ys
end

function table.merge(xs, ys, f)

    local zs = table.copy(xs)

    for k, v in pairs(ys) do
        zs[k] = f(zs[k], v)
    end

    return zs
end

function shuffle(paths)
    local j, k
    local n = #paths

    for _ = 1, n do
        j, k = math.random(n), math.random(n)
        paths[j], paths[k] = paths[k], paths[j]
    end

    return paths
end

function load_requests(file)
    local fp = io.open(file, "r")
    local rqs = json.decode(fp:read("*all"))
    io.close(fp)
    for _, req in ipairs(rqs) do
        if req.payload then
            local payload = json.encode(req.payload)
            req.post = {
                payload = payload,
                size = #{ string.byte(payload, 1, -1) }
            }
        end
    end
    return shuffle(rqs), #rqs
end

file_out = "out.json"
local threads = {}

function parse_args(args)
    for i, arg in pairs(args) do
        if arg == "-f" then
            fileIn = args[i + 1]
        end
        if arg == "-o" then
            file_out = args[i + 1]
        end
    end
end

function setup(thread)
    table.insert(threads, thread)
end

function init(args)
    counter = 0
    parse_args(args)
    response_status = {}
    rqs, rqsCount = load_requests(fileIn)
    print("Reading " .. fileIn .. " (" .. rqsCount .. " requests)")
end

function request()
    counter = counter + 1
    local req = rqs[1 + counter % rqsCount]

    local body
    local method = req.method or "GET"
    local headers = {}
    if req.post then
        body = req.post.payload
        headers["Content-Length"] = req.post.size
        headers["Content-Type"] = "application/json"
    end

    for _, h in ipairs(req.headers or {}) do
        headers[h.key:upper()] = h.value

    end

    return wrk.format(method:upper(), req.url, headers, body)
end

function done(summary, latency, requests)

    local status = {}

    for _, thread in ipairs(threads) do
        local t_status = table.swap(thread:get("response_status")) -- work around ;don't know why key and value are swapped
        status = table.merge(status, t_status, function(x, y)
            return (x or 0) + (y or 0)
        end)
    end

    local stats = {
        bytes = summary.bytes,
        requests = summary.requests,
        duration_us = summary.duration,
        latency_us = {
            mean = latency.mean,
            stdev = latency.stdev,
            min = latency.min,
            max = latency.max,
            percentile = {
                p50 = latency:percentile(50),
                p75 = latency:percentile(75),
                p90 = latency:percentile(90),
                p99 = latency:percentile(99),
                p99_999 = latency:percentile(99.999)
            }
        },
        velocity_s = {
            requests = 1000000.0 * summary.requests / summary.duration,
            kbytes = 1000000.0 * summary.bytes / summary.duration / 1024
        },
        status = status
    }

    local thread = threads[1]
    local fileOut = thread:get("file_out")
    print("\nWriting report to " .. fileOut)
    local fp = io.open(fileOut, "w")
    fp:write(json.encode(stats))
end

function response(status, headers, body)
    local idx = "http_" .. tostring(status)
    response_status[idx] = (response_status[idx] or 0) + 1
end