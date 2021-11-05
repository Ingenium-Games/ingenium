-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.file = {}
--[[

]]--
-- ====================================================================================--

function c.file.Exists(file)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    if f then f:close() end
    return f ~= nil
end

function c.file.Read(file)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file, "r")
    local content = f:read("a")
    f:close()
    return content
end
  
-- Write a string to a file.
function c.file.Write(file, content)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file,  "w+")
    f:write(content)
    f:flush()
    f:close()
end