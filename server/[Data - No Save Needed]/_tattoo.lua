--[[
    Game Data Helper Functions (Server-side)  (ig.tattoo, ig.tattoos initialized in server/_var.lua)
    Provides query and validation functions for tattoos, weapons, vehicles, and modkits
    Server is the authority - clients request data via callbacks
]]--
-- ============================================
-- TATTOO HELPERS
-- ============================================

---Get all tattoo data
---@return table All tattoos data
function ig.tattoo.GetAll()
    return ig.tattoos
end

---Get tattoo data by hash
---@param hash number Tattoo hash
---@return table|nil Tattoo data or nil if not found
function ig.tattoo.GetByHash(hash)
    return ig.tattoos[tostring(hash)]
end

---Get tattoos by zone
---@param zone string Zone name (e.g., "ZONE_HEAD", "ZONE_TORSO")
---@return table Array of tattoos for the zone
function ig.tattoo.GetByZone(zone)
    local result = {}
    for _, tattoo in pairs(ig.tattoos) do
        if tattoo.zone == zone then
            table.insert(result, tattoo)
        end
    end
    return result
end

---Get tattoos by collection
---@param collection string Collection hash
---@return table Array of tattoos in the collection
function ig.tattoo.GetByCollection(collection)
    local result = {}
    for _, tattoo in pairs(ig.tattoos) do
        if tattoo.collection == collection then
            table.insert(result, tattoo)
        end
    end
    return result
end

---Check if tattoo is for male character
---@param hash number Tattoo hash
---@return boolean True if for male
function ig.tattoo.IsMale(hash)
    local tattoo = ig.tattoo.GetByHash(hash)
    return tattoo and (tattoo.gender == "male" or tattoo.gender == "both")
end

---Check if tattoo is for female character
---@param hash number Tattoo hash
---@return boolean True if for female
function ig.tattoo.IsFemale(hash)
    local tattoo = ig.tattoo.GetByHash(hash)
    return tattoo and (tattoo.gender == "female" or tattoo.gender == "both")
end
