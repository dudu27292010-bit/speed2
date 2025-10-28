-- loader.lua — decodifica base64 e executa o payload
local b64 = [[
bG9jYWwgVUlTID0gZ2FtZTpHZXRTZXJ2aWNlKCJVc2VySW5wdXRTZXJ2aWNlIikKbG9jYWwgUGxheWVycyA9IGdhbWU6R2V0U2VydmljZSgiUGxheWVycyIpCmxvY2FsIGxvY2FsUGxheWVyID0gUGxheWVycy5Mb2NhbFBsYXllcgoKLS0gQnVzY2EgbyBodW1hbm9pZCBkbyBqb2dhZG9yIGRpbmFtaWNhbWVudGUgY29tIGJhc2Ugbm8gbmljawpsb2NhbCBodW1hbm9pZCA9IHdvcmtzcGFjZS5FbnRpdGllczpXYWl0Rm9yQ2hpbGQobG9jYWxQbGF5ZXIuTmFtZSk6RmluZEZpcnN0Q2hpbGRPZkNsYXNzKCJIdW1hbm9pZCIpCgotLSBBanVzdGEgbyB0YW1hbmhvIGRvIEh1bWFub2lkUm9vdFBhcnQgZGUgdG9kYXMgYXMgZW50aWRhZGVzIChpbmNsdWluZG8gbyBwcsOzcHJpbyBqb2dhZG9yKSBwYXJhIDEyeDEyeDEyCmZvciBfLCBlbnRpdHkgaW4gaXBhaXJzKHdvcmtzcGFjZS5FbnRpdGllczpHZXRDaGlsZHJlbigpKSBkbwogICAgbG9jYWwgaHJwID0gZW50aXR5OkZpbmRGaXJzdENoaWxkKCJIdW1hbm9pZFJvb3RQYXJ0IikKICAgIGlmIGhycCB0aGVuCiAgICAgICAgaHJwLlNpemUgPSBWZWN0b3IzLm5ldygxMiwgMTIsIDEyKQogICAgZW5kCmVuZAoKbG9jYWwgYXRpdm8gPSB0cnVlCmxvY2FsIGRlYm91bmNlID0gZmFsc2UKClVJUy5JbnB1dEJlZ2FuOkNvbm5lY3QoZnVuY3Rpb24oaW5wdXQsIGdwKQogICAgaWYgZ3AgdGhlbiByZXR1cm4gZW5kCiAgICBpZiBub3QgYXRpdm8gdGhlbiByZXR1cm4gZW5kCgogICAgaWYgaW5wdXQuS2V5Q29kZSA9PSBFbnVtLktleUNvZGUuTGVmdFNoaWZ0IHRoZW4KICAgICAgICBpZiBkZWJvdW5jZSB0aGVuIHJldHVybiBlbmQKICAgICAgICBkZWJvdW5jZSA9IHRydWUKICAgICAgICB0YXNrLndhaXQoMC4wKQogICAgICAgIGlmIGF0aXZvIGFuZCBodW1hbm9pZCBhbmQgaHVtYW5vaWQuUGFyZW50IHRoZW4KICAgICAgICAgICAgaHVtYW5vaWQuV2Fsa1NwZWVkID0gMTM1CiAgICAgICAgZW5kCiAgICAgICAgZGVib3VuY2UgPSBmYWxzZQoKICAgIGVsc2VpZiBpbnB1dC5LZXlDb2RlID09IEVudW0uS2V5Q29kZS5SaWdodFNoaWZ0IHRoZW4KICAgICAgICBhdGl2byA9IGZhbHNlCiAgICBlbmQKZW5kKQoK
]]

local function decodeBase64(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f = '', (b:find(x)-1)
        for i = 6, 1, -1 do
            r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0)
        end
        return string.char(c)
    end))
end

local ok, chunk = pcall(function() return loadstring(decodeBase64(b64)) end)
if not ok or not chunk then error("failed to load payload") end
chunk()
