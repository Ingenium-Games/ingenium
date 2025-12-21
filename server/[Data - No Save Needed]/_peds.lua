--[[
    Ped Data Helper Functions (Server-side)
    Provides query and validation functions for ped models
    Server is the authority - clients request data via callbacks
--]]
ig.ped = ig.ped or {}
ig.peds = ig.peds or {}
-- ============================================
-- PED HELPERS
-- ============================================

---Get all ped data
---@return table All peds data
function ig.ped.GetAll()
    return ig.peds
end

---Get ped data by hash
---@param hash number Ped hash
---@return table|nil Ped data or nil if not found
function ig.ped.GetByHash(hash)
    return ig.peds[tostring(hash)]
end

---Get ped data by name
---@param name string Ped model name (e.g., "mp_m_freemode_01")
---@return table|nil Ped data or nil if not found
function ig.ped.GetByName(name)
    for _, ped in pairs(ig.peds) do
        if ped.name:lower() == name:lower() then
            return ped
        end
    end
    return nil
end

---Get peds by gender
---@param gender string Gender ("male", "female", "unknown")
---@return table Array of peds for the gender
function ig.ped.GetByGender(gender)
    local result = {}
    for _, ped in pairs(ig.peds) do
        if ped.gender == gender then
            table.insert(result, ped)
        end
    end
    return result
end

---Get peds by type
---@param pedType string Type ("freemode", "story", "ambient", "animal")
---@return table Array of peds of the type
function ig.ped.GetByType(pedType)
    local result = {}
    for _, ped in pairs(ig.peds) do
        if ped.type == pedType then
            table.insert(result, ped)
        end
    end
    return result
end

---Get freemode peds (customizable player models)
---@return table Array of freemode peds
function ig.ped.GetFreemodePeds()
    return ig.ped.GetByType("freemode")
end

---Get male peds
---@return table Array of male peds
function ig.ped.GetMalePeds()
    return ig.ped.GetByGender("male")
end

---Get female peds
---@return table Array of female peds
function ig.ped.GetFemalePeds()
    return ig.ped.GetByGender("female")
end

---Check if ped is freemode model
---@param hash number Ped hash
---@return boolean True if freemode model
function ig.ped.IsFreemode(hash)
    local ped = ig.ped.GetByHash(hash)
    return ped and ped.type == "freemode"
end

---Check if ped is male
---@param hash number Ped hash
---@return boolean True if male
function ig.ped.IsMale(hash)
    local ped = ig.ped.GetByHash(hash)
    return ped and ped.gender == "male"
end

---Check if ped is female
---@param hash number Ped hash
---@return boolean True if female
function ig.ped.IsFemale(hash)
    local ped = ig.ped.GetByHash(hash)
    return ped and ped.gender == "female"
end

---Get ped display name
---@param hash number Ped hash
---@return string Display name or "Unknown"
function ig.ped.GetDisplayName(hash)
    local ped = ig.ped.GetByHash(hash)
    return ped and ped.displayName or "Unknown"
end

---Validate ped model exists
---@param model string|number Ped model name or hash
---@return boolean True if valid
function ig.ped.IsValid(model)
    if type(model) == "number" then
        return ig.ped.GetByHash(model) ~= nil
    elseif type(model) == "string" then
        return ig.ped.GetByName(model) ~= nil
    end
    return false
end

