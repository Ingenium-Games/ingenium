-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.vehicle = {} -- functions
-- c.vehicles is found in /[Data]/_vehicles.lua as dumped from ig.dump
--[[
NOTES.
    -
    -
    -
]]--
-- ====================================================================================--
function c.vehicle.GetAllByHash()
    local t = {}
    for _,v in pairs(c.vehicles) do
        table.insert(t,v.SignedHash)
    end
    return t
end
