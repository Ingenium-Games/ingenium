-- ====================================================================================--
-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
c.ammo = {}
-- ====================================================================================--

function c.ammo.GetType(type)
    return c._ammo[type]
end

function c.ammo.Get()
    return c._ammo
end