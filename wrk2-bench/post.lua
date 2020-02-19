json = require "json"

math.randomseed(os.time())

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c)
        fields[#fields + 1] = c
    end)
    return fields
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

fileOut = "out.json"
local threads = {}

function parse_args(args)
    for i, arg in pairs(args) do
        if arg == "-f" then
            fileIn = args[i + 1]
        end
        if arg == "-o" then
            fileOut = args[i + 1]
        end
    end
end

function setup(thread)
    table.insert(threads, thread)
end

function init(args)
    counter = 0
    responseNoBid = 0
    responseBidOk = 0
    responseAll = 0
    parse_args(args)
    rqs, rqsCount = load_requests(fileIn)
    print("Reading " .. fileIn .. " (" .. rqsCount .. " requests)")
end

function request()
    counter = counter + 1
    local req = rqs[1 + counter % rqsCount]

    local body
    local method = req.method or "GET"
    if req.post then
        body = req.post.payload
        wrk.headers["Content-Length"] = req.post.size
        wrk.headers["Content-Type"] = "application/json"
    end

    for _, h in ipairs(req.headers or {}) do
        wrk.headers[h.key:upper()] = h.value

    end

    return wrk.format(method:upper(), req.url, null, body)
end

function done(summary, latency, requests)
    local r = summary.requests
    local d = summary.duration
    local b = summary.bytes
    local b2d = 1000000.0 * b / d / 1024
    local r2d = 1000000.0 * r / d

    local template = [[
        {
                "bytes"    : "%d",
                "requests" : "%d",
                "duration" : "%d",
                "latency"      : {
                        "mean"  : "%f",
                        "stdev" : "%f",
                        "min"   : "%f",
                        "max"   : "%f",
                        "percentile" : {
                                "p50" : "%f",
                                "p75" : "%f",
                                "p90" : "%f",
                                "p99" : "%f",
                                "p99_999" : "%f"
                        }
                },
                "velocity_per_s" : {
                        "requests" : "%f",
                        "kbytes" : "%f"
                },
                "bidding" : {
                        "noBid"        : "%d",
                        "bidOk"        : "%d",
                        "all"          : "%d",
                        "bidOkRatio"   : "%f"
                }
        }
        ]]

    local noBid = 0
    local bidOk = 0
    local all = 0

    for _, thread in ipairs(threads) do
        bidOk = bidOk + thread:get("responseBidOk")
        noBid = noBid + thread:get("responseNoBid")
        all = all + thread:get("responseAll")
    end

    local bidOkRatio = bidOk / all

    local json = string.format(template,
            b,
            r,
            d,
            latency.mean,
            latency.stdev,
            latency.min,
            latency.max,
            latency:percentile(50),
            latency:percentile(75),
            latency:percentile(90),
            latency:percentile(99),
            latency:percentile(99.999),
            r2d,
            b2d,
            noBid,
            bidOk,
            all,
            bidOkRatio
    )

    local thread = threads[1]
    local fileOut = thread:get("fileOut")
    print("\nWriting report to " .. fileOut)
    local fp = io.open(fileOut, "w")
    fp:write(json)
end

function response(status, headers, body)

    if status == 204 then
        responseNoBid = responseNoBid + 1
    end

    if status == 200 then
        responseBidOk = responseBidOk + 1
    end

    responseAll = responseAll + 1

end