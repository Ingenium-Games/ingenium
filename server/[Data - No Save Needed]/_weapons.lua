-- ====================================================================================--
-- Weapons (ig.weapon, ig.weapons initialized in server/_var.lua)

-- ============================================
-- WEAPON HELPERS
-- ============================================

---Get all weapon data
---@return table All weapons data
function ig.weapon.GetAll()
    return ig.weapons
end

--- func desc
---@param id any
function ig.weapon.Exist(id)
    if ig.weapons[id] then
        return true
    end
    return false
end

---Get weapon data by hash
---@param hash number Weapon hash
---@return table|nil Weapon data or nil if not found
function ig.weapon.GetByHash(hash)
    return ig.weapons[tostring(hash)]
end

---Get weapon data by name
---@param name string Weapon name (e.g., "weapon_pistol")
---@return table|nil Weapon data or nil if not found
function ig.weapon.GetByName(name)
    for _, weapon in pairs(ig.weapons) do
        if weapon.name:lower() == name:lower() then
            return weapon
        end
    end
    return nil
end

---Get weapons by category
---@param category string Category (e.g., "Pistol", "Rifle", "Melee")
---@return table Array of weapons in category
function ig.weapon.GetByCategory(category)
    local result = {}
    for _, weapon in pairs(ig.weapons) do
        if weapon.category == category then
            table.insert(result, weapon)
        end
    end
    return result
end

---Get weapon display name
---@param hash number Weapon hash
---@return string Display name or "Unknown"
function ig.weapon.GetDisplayName(hash)
    local weapon = ig.weapon.GetByHash(hash)
    return weapon and weapon.label or "Unknown"
end

---Check if weapon is melee
---@param hash number Weapon hash
---@return boolean True if melee weapon
function ig.weapon.IsMelee(hash)
    local weapon = ig.weapon.GetByHash(hash)
    return weapon and weapon.category == "Melee"
end


--- func desc
function ig.weapon.Resync()
    local weapons = ig.weapons
    TriggerClientEvent("Client:Weapons:Update", -1, weapons)
end