-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.door = {} -- functions
c.doors = {} -- doors
--[[
NOTES
    -
]]--
-- ====================================================================================--

function c.door.Add(model, coords, locked)
    local tab = {model = model, coords = coords, locked = locked}
    table.insert(c.doors, tab)
end

function c.door.Resync()
    local doors = c.doors
    TriggerClientEvent("Client:Doors:Initialize", -1, doors)
end

function c.door.Find(coords)
    for k,v in pairs(c.doors) do
        -- is the door in the table?
        if v.coords == coords then
            return true, k
        end
    end    
    return false, false
end

function c.door.Toggle(coords)
    local bool, door = c.door.Find(coords)
    if door then
        c.doors[door].locked = not bool
        TriggerClientEvent("Client:Doors:Set", -1, door, c.doors[door].locked)
    end
end