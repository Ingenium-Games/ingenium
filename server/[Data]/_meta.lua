-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
    Turn the shared data into a Metatable with locked to prevent tampering.
    Call it with setmetatable to local tables for shared uses.
    rawset and rawget will still donkey fuck, but w/e
]]--

c.meta = {
    __index = self,
    __newindex = function() print("Locked") end,
    __metatable = function() print("Locked") end,
}

--[[
    : Example 
    c.items = {}
    setmetatable(c.items,c.meta)
]]--