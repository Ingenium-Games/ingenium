-- NPC management (ig.npc, ig.npcs, ig.ndex initialized in server/_var.lua)

-- ====================================================================================--
-- NPC"s 

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

--- Adds a new NPC instance to the NPC index if not already present
---@param net integer "Network ID (16-bit integer)"
---@param cb function "Callback function to instantiate NPC class"
---@param ... any "Arguments to pass to callback function"
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

--- Get all xVehicles
function ig.npc.GetNpcs()
    return ig.ndex
end

--- Removes an NPC from the index by setting it to nil for garbage collection
---@param net integer "Network ID (16-bit integer)"
function ig.npc.RemoveNpc(net)
    ig.ndex[tonumber(net)] = nil
end