-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--
--[[
NOTES

]]--
math.randomseed(c.Seed)
-- ====================================================================================--

RegisterNetEvent('Client:Doors:Set')
AddEventHandler('Client:Doors:Set', function(door, locked)
    DoorSystemSetDoorState(door, locked and 1 or 0)
end)

RegisterNetEvent('Client:Doors:Initialize')
AddEventHandler('Client:Doors:Initialize', function(doors)
    for k, v in pairs(doors) do
        AddDoorToSystem(k, v.model, v.coords)
        DoorSystemSetDoorState(k, v.locked and 1 or 0)
    end
end)