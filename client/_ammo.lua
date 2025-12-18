-- ====================================================================================--
-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
ig.ammo = {}
-- _ammo.lua
ig._ammo = {["9mm"]=0,["5.56mm"]=0,["7.62mm"]=0,["20g"]=0,[".223"]=0,[".308"]=0}
ig._ammotype = nil
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