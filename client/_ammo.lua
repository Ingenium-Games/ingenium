-- ====================================================================================--

-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
c.ammo = {}

-- ====================================================================================--

--- func desc
---@param . any
function c.ammo.GetType(type)
    return c._ammo[type]
end

--- func desc
function c.ammo.Get()
    return c._ammo
end