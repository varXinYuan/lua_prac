local http = require("resty.http")
local json = require("cjson")
local API_URL = "http://10.2.0.38:81/"

httpapi = {}

local api = http.new()

function httpapi.request(method, path, body)
    local res, err = api:request_uri(API_URL, {
        method = method,
        path = "/api/"..path,
        body = body,
    })
    if res ~= nil then
        local response = json.decode(res.body)
        if not response["error"] then
            data = response["result"]
        end
    end
    if data ~= nil then
        return data
    else
        return false
    end
end

return httpapi
