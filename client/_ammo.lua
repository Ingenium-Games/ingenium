-- ====================================================================================--
-- Ammo tracking (ig.ammo, ig._ammo, ig._ammotype initialized in client/_var.lua)
-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
-- ====================================================================================--

--- func desc
---@param . any
function ig.ammo.GetType(type)
    return ig._ammo[type]
end

--- func desc
function ig.ammo.Get()
    return ig._ammo
end