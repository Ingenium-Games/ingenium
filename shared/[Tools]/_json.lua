-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.json = {}
--[[
    I only use these for data files in Json, anyone can and should change them to a more 
    appropriately named function. Like ReadJson etc.
]]--
-- ====================================================================================--

function c.json.Exists(file)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file..".json", "r")
    if f then f:close() f = true else f = false end
    return f
end

function c.json.Read(file)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file..".json", "r")
    local content = f:read("a")
    f:close()
    return json.decode(content)
end
  
-- Write a string to a file.
function c.json.Write(file, content)
    local steralize = json.encode(content)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."/data/"..file..".json",  "w+")
    f:write(steralize)
    f:flush()
    f:close()
end