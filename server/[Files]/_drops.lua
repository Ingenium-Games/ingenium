-- ====================================================================================--
ig.drop = {} -- function level
ig.drops = false -- dropped items table
-- ====================================================================================--

--[[    
            {
                [UUID] = {
                    ["UUID"] = UUID String
                    ["NetID"] = Network ID
                    ["Coords"] = {x, y, z, h}
                    ["Model"] = Model hash
                    ["Inventory"] = [{Item, Quantity, Quality, Weapon, Meta}]
                    ["Created"] = Timestamp
                    ["Updated"] = Timestamp
                },
    
            }
    ]] --

--- Load drops from JSON (now handled by ig.data.LoadJSONData)
---@param . any
function ig.drop.Load()
    -- Data is already loaded by ig.data.LoadJSONData
    -- This function kept for compatibility
    if not ig.drops then
        ig.drops = {}
    end
    ig.funig.Debug_1("Drop system initialized")
end

--- func desc
---@param data any
function ig.drop.Add(data)
    if type(data) == "table" then
        table.insert(ig.drops, data)
    else
        ig.funig.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.drop.Exist(id)
    if ig.drops[id] then
        return true
    end
    return false
end

--- func desc
function ig.drop.Resync()
    local drops = ig.drops
    TriggerClientEvent("Client:Drops:Update", -1, drops)
end
