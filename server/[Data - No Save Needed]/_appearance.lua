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
