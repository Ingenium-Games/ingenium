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
    return c.file.Exists(file..".json")
end

function c.json.Read(file)
    local content = c.file.Read(file..".json")
    return json.decode(content)
end
  
function c.json.Write(file, content)
    local data = json.encode(content)
    c.file.Write(file..".json", data)
end