-- ====================================================================================--

-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
c.ammo = {}
-- _ammo.lua
c._ammo = {["9mm"]=0,["5.56mm"]=0,["7.62mm"]=0,["20g"]=0,[".223"]=0,[".308"]=0}
c._ammotype = nil

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