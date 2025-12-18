--[[
    Ped Data Helper Functions (Server-side)
    Provides query and validation functions for ped models
    Server is the authority - clients request data via callbacks
--]]

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


-- ============================================
-- APPEARANCE CONSTANTS HELPERS
-- ============================================

---Get all appearance constants
---@return table Appearance constants
function ig.appearance.GetConstants()
    return ig.appearance_constants
end

---Get eye colors
---@return table Array of eye colors
function ig.appearance.GetEyeColors()
    return ig.appearance_constants.eyeColors or {}
end

---Get hair decorations for gender
---@param gender string "male" or "female"
---@return table Array of hair decorations
function ig.appearance.GetHairDecorations(gender)
    if not ig.appearance_constants.hairDecorations then return {} end
    return ig.appearance_constants.hairDecorations[gender] or {}
end

---Get face features list
---@return table Array of face features
function ig.appearance.GetFaceFeatures()
    return ig.appearance_constants.faceFeatures or {}
end

---Get head overlays list
---@return table Array of head overlays
function ig.appearance.GetHeadOverlays()
    return ig.appearance_constants.headOverlays or {}
end

---Get components list
---@return table Array of components
function ig.appearance.GetComponents()
    return ig.appearance_constants.components or {}
end

---Get props list
---@return table Array of props
function ig.appearance.GetProps()
    return ig.appearance_constants.props or {}
end

---Get default appearance
---@return table Default appearance data
function ig.appearance.GetDefaultAppearance()
    return ig.appearance_constants.defaultAppearance or {}
end

---Validate appearance data structure
---@param appearance table Appearance data to validate
---@return boolean, string True if valid, or false with error message
function ig.appearance.ValidateAppearance(appearance)
    if type(appearance) ~= "table" then
        return false, "Appearance must be a table"
    end
    
    -- Check required fields
    if not appearance.model or type(appearance.model) ~= "string" then
        return false, "Invalid or missing model"
    end
    
    -- Validate model exists
    if not ig.ped.IsValid(appearance.model) then
        return false, "Unknown ped model: " .. tostring(appearance.model)
    end
    
    -- Check headBlend if present
    if appearance.headBlend then
        if type(appearance.headBlend) ~= "table" then
            return false, "headBlend must be a table"
        end
    end
    
    -- Check faceFeatures if present
    if appearance.faceFeatures then
        if type(appearance.faceFeatures) ~= "table" then
            return false, "faceFeatures must be a table"
        end
    end
    
    -- Check headOverlays if present
    if appearance.headOverlays then
        if type(appearance.headOverlays) ~= "table" then
            return false, "headOverlays must be a table"
        end
    end
    
    -- Check hair if present
    if appearance.hair then
        if type(appearance.hair) ~= "table" then
            return false, "hair must be a table"
        end
    end
    
    return true, "Valid"
end


-- ============================================
-- CLIENT CALLBACKS
-- Server distributes data to clients on request
-- ============================================

---Client callback: Get all peds
ig.callback.Register('ig:GameData:GetPeds', function(source)
    return ig.peds
end)

---Client callback: Get peds by gender
ig.callback.Register('ig:GameData:GetPedsByGender', function(source, gender)
    return ig.ped.GetByGender(gender)
end)

---Client callback: Get peds by type
ig.callback.Register('ig:GameData:GetPedsByType', function(source, pedType)
    return ig.ped.GetByType(pedType)
end)

---Client callback: Get ped by hash
ig.callback.Register('ig:GameData:GetPedByHash', function(source, hash)
    return ig.ped.GetByHash(hash)
end)

---Client callback: Get ped by name
ig.callback.Register('ig:GameData:GetPedByName', function(source, name)
    return ig.ped.GetByName(name)
end)

---Client callback: Get appearance constants
ig.callback.Register('ig:GameData:GetAppearanceConstants', function(source)
    return ig.appearance_constants
end)

---Client callback: Validate appearance data
ig.callback.Register('ig:Appearance:ValidateAppearance', function(source, appearance)
    return ig.appearance.ValidateAppearance(appearance)
end)

print('^2[Game Data] Ped helpers and appearance callbacks loaded^7')
