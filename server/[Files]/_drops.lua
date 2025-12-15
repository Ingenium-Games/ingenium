-- ====================================================================================--
c.drop = {} -- function level
c.drops = false -- dropped items table
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

--- Load drops from JSON (now handled by c.data.LoadJSONData)
---@param . any
function c.drop.Load()
    -- Data is already loaded by c.data.LoadJSONData
    -- This function kept for compatibility
    if not c.drops then
        c.drops = {}
    end
    c.func.Debug_1("Drop system initialized")
end

--- func desc
---@param data any
function c.drop.Add(data)
    if type(data) == "table" then
        table.insert(c.drops, data)
    else
        c.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function c.drop.Exist(id)
    if c.drops[id] then
        return true
    end
    return false
end

--- func desc
function c.drop.Resync()
    local drops = c.drops
    TriggerClientEvent("Client:Drops:Update", -1, drops)
end
