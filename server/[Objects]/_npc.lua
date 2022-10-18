-- ====================================================================================--

c.npc = {} -- function level
c.npcs = {} -- database pull - If ever used?	
c.ndex = {} -- the index/store for currently used vehciles prior to writing to db.

-- ====================================================================================--

---@param net integer "Network ID 16 bit integer"
function c.npc.Find(net)
    for k,v in ipairs(c.ndex) do
        if k == net and type(v) == "table"  then
            return true
        end
    end
    return false
end