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
function c.ped.GetAll()
    return c.peds
end

---Get ped data by hash
---@param hash number Ped hash
---@return table|nil Ped data or nil if not found
function c.ped.GetByHash(hash)
    return c.peds[tostring(hash)]
end

---Get ped data by name
---@param name string Ped model name (e.g., "mp_m_freemode_01")
---@return table|nil Ped data or nil if not found
function c.ped.GetByName(name)
    for _, ped in pairs(c.peds) do
        if ped.name:lower() == name:lower() then
            return ped
        end
    end
    return nil
end

---Get peds by gender
---@param gender string Gender ("male", "female", "unknown")
---@return table Array of peds for the gender
function c.ped.GetByGender(gender)
    local result = {}
    for _, ped in pairs(c.peds) do
        if ped.gender == gender then
            table.insert(result, ped)
        end
    end
    return result
end

---Get peds by type
---@param pedType string Type ("freemode", "story", "ambient", "animal")
---@return table Array of peds of the type
function c.ped.GetByType(pedType)
    local result = {}
    for _, ped in pairs(c.peds) do
        if ped.type == pedType then
            table.insert(result, ped)
        end
    end
    return result
end

---Get freemode peds (customizable player models)
---@return table Array of freemode peds
function c.ped.GetFreemodePeds()
    return c.ped.GetByType("freemode")
end

---Get male peds
---@return table Array of male peds
function c.ped.GetMalePeds()
    return c.ped.GetByGender("male")
end

---Get female peds
---@return table Array of female peds
function c.ped.GetFemalePeds()
    return c.ped.GetByGender("female")
end

---Check if ped is freemode model
---@param hash number Ped hash
---@return boolean True if freemode model
function c.ped.IsFreemode(hash)
    local ped = c.ped.GetByHash(hash)
    return ped and ped.type == "freemode"
end

---Check if ped is male
---@param hash number Ped hash
---@return boolean True if male
function c.ped.IsMale(hash)
    local ped = c.ped.GetByHash(hash)
    return ped and ped.gender == "male"
end

---Check if ped is female
---@param hash number Ped hash
---@return boolean True if female
function c.ped.IsFemale(hash)
    local ped = c.ped.GetByHash(hash)
    return ped and ped.gender == "female"
end

---Get ped display name
---@param hash number Ped hash
---@return string Display name or "Unknown"
function c.ped.GetDisplayName(hash)
    local ped = c.ped.GetByHash(hash)
    return ped and ped.displayName or "Unknown"
end

---Validate ped model exists
---@param model string|number Ped model name or hash
---@return boolean True if valid
function c.ped.IsValid(model)
    if type(model) == "number" then
        return c.ped.GetByHash(model) ~= nil
    elseif type(model) == "string" then
        return c.ped.GetByName(model) ~= nil
    end
    return false
end


-- ============================================
-- APPEARANCE CONSTANTS HELPERS
-- ============================================

---Get all appearance constants
---@return table Appearance constants
function c.appearance.GetConstants()
    return c.appearance_constants
end

---Get eye colors
---@return table Array of eye colors
function c.appearance.GetEyeColors()
    return c.appearance_constants.eyeColors or {}
end

---Get hair decorations for gender
---@param gender string "male" or "female"
---@return table Array of hair decorations
function c.appearance.GetHairDecorations(gender)
    if not c.appearance_constants.hairDecorations then return {} end
    return c.appearance_constants.hairDecorations[gender] or {}
end

---Get face features list
---@return table Array of face features
function c.appearance.GetFaceFeatures()
    return c.appearance_constants.faceFeatures or {}
end

---Get head overlays list
---@return table Array of head overlays
function c.appearance.GetHeadOverlays()
    return c.appearance_constants.headOverlays or {}
end

---Get components list
---@return table Array of components
function c.appearance.GetComponents()
    return c.appearance_constants.components or {}
end

---Get props list
---@return table Array of props
function c.appearance.GetProps()
    return c.appearance_constants.props or {}
end

---Get default appearance
---@return table Default appearance data
function c.appearance.GetDefaultAppearance()
    return c.appearance_constants.defaultAppearance or {}
end

---Validate appearance data structure
---@param appearance table Appearance data to validate
---@return boolean, string True if valid, or false with error message
function c.appearance.ValidateAppearance(appearance)
    if type(appearance) ~= "table" then
        return false, "Appearance must be a table"
    end
    
    -- Check required fields
    if not appearance.model or type(appearance.model) ~= "string" then
        return false, "Invalid or missing model"
    end
    
    -- Validate model exists
    if not c.ped.IsValid(appearance.model) then
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
c.callback.Register('ig:GameData:GetPeds', function(source)
    return c.peds
end)

---Client callback: Get peds by gender
c.callback.Register('ig:GameData:GetPedsByGender', function(source, gender)
    return c.ped.GetByGender(gender)
end)

---Client callback: Get peds by type
c.callback.Register('ig:GameData:GetPedsByType', function(source, pedType)
    return c.ped.GetByType(pedType)
end)

---Client callback: Get ped by hash
c.callback.Register('ig:GameData:GetPedByHash', function(source, hash)
    return c.ped.GetByHash(hash)
end)

---Client callback: Get ped by name
c.callback.Register('ig:GameData:GetPedByName', function(source, name)
    return c.ped.GetByName(name)
end)

---Client callback: Get appearance constants
c.callback.Register('ig:GameData:GetAppearanceConstants', function(source)
    return c.appearance_constants
end)

---Client callback: Validate appearance data
c.callback.Register('ig:Appearance:ValidateAppearance', function(source, appearance)
    return c.appearance.ValidateAppearance(appearance)
end)

print('^2[Game Data] Ped helpers and appearance callbacks loaded^7')
