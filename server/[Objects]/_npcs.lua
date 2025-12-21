ig.npc = {}
ig.npcs = {}

-- ====================================================================================--
-- NPC"s 

ig.ndex = {} -- the index/store for currently generated npcs

---@param net integer "Network ID 16 bit integer"
function ig.npc.FindNpc(arg)
    for k, v in pairs(ig.ndex) do
        if v then
            if k == arg and type(v) == "table" then
                return true, v, k
            end
        end
    end
    return false, false, false
end

--- func desc
---@param net any
---@param cb any
function ig.npc.AddNpc(net, cb, ...)
    if not ig.npc.FindNpc(net) then
        ig.ndex[tonumber(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function ig.npc.GetNpc(net)
    return ig.ndex[tonumber(net)] or false
end

--- Same as above.
---@param net integer "Network ID 16 bit integer"
function ig.GetNpc(net)
    return ig.npc.GetNpc(net)
end

--- Get all xVehicles
function ig.npc.GetNpcs()
    return ig.ndex
end

--- Get all xVehicles
function ig.GetNpcs()
    return ig.npc.GetNpcs()
end

-- Set to nil for garbage collection
--- func desc
---@param net any
function ig.npc.RemoveNpc(net)
    ig.ndex[tonumber(net)] = nil
end