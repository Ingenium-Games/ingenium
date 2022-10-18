-- ====================================================================================--

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