-- ====================================================================================--
ig.weapon = {} -- function level
ig.weapons = false -- dropped items table
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
function ig.weapon.Load()
    -- Data is already loaded by ig.data.LoadJSONData
    -- This function kept for compatibility
    if not ig.weapons then
        ig.weapons = {}
    end
    ig.func.Debug_1("Drop system initialized")
end

--- func desc
---@param data any
function ig.weapon.Add(data)
    if type(data) == "table" then
        table.insert(ig.weapons, data)
    else
        ig.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.weapon.Exist(id)
    if ig.weapons[id] then
        return true
    end
    return false
end

--- func desc
function ig.weapon.Resync()
    local weapons = ig.weapons
    TriggerClientEvent("Client:Weapons:Update", -1, weapons)
end
