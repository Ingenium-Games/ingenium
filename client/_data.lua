-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.data = {}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

--- Upon joining, these are core functions to run internally prior to sending the join request to the server
---@param cb function "Callback function to run if any provided."
function c.data.Initilize(cb)
    -- Get time and update every minute.
    c.time.UpdateTime()
    --
    if cb then
        cb()
    end
end

--- Returns the local from the local variable. String
function c.data.GetLocale()
    return c.locale
end

--- Takes local information from the `user` SQL table and sets it for the client.
function c.data.SetLocale()
    local xPlayer = c.data.GetPlayer()
    c.data.locale = xPlayer.Locale
end

--- Sets the client as receieved the character data. Boolean
---@param bool boolean "Set loaded status to true or false."
function c.data.SetLoadedStatus(bool)
    if type(bool) == 'boolean' then
        c.CharacterLoaded = bool
    end
end

--- Returns if the client has finished loading. Boolean
function c.data.GetLoadedStatus()
    return c.CharacterLoaded
end

--- Returns if the client has finished loading. Boolean
function c.data.IsPlayerLoaded()
    return c.CharacterLoaded
end

--- Returns the Player state
function c.data.GetPlayer()
    return Player(GetPlayerServerId(PlayerId())).state
end

--- Return the Entity"s state bag.
---@param ent any "Entity"
function c.data.GetEntityState(ent)    
    return Entity(ent).state
end

--- Return the Entity"s state bag.
---@param ent any "Entity"
function c.GetEntityState(ent)    
    return c.data.GetEntityState(ent)
end

--- Return the Players's state bag.
---@param id any "Player's Server Id"
function c.data.GetPlayerState(id)
    return Player(id).state
end

--- Return the Players's state bag.
---@param id any "Player's Server Id"
function c.GetPlayerState(id)    
    return c.data.GetPlayerState(id)
end

--- Return the Players's state bag.
---@param ped any "Player's Ped Entity"
function c.data.GetPlayerPedState(ped)
    return Player(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))).state
end

--- Return the Players's state bag.
---@param ped any "Player's Ped Entity"
function c.GetPlayerPedState(ped)    
    return c.data.GetPlayerPedState(ped)
end


-- ====================================================================================--

--- Sends the packet of data to the server to register and update xPlayer
function c.data.Packet()
    local ped = PlayerPedId()
    local data = {}
    -- Stats / HP vs 
    data.Health = c.math.Decimals(c.status.GetHealth(ped), 0)
    data.Armour = c.math.Decimals(c.status.GetArmour(ped), 0)
    data.Hunger = c.math.Decimals(c.status.GetHunger(), 0)
    data.Thirst = c.math.Decimals(c.status.GetThirst(), 0)
    data.Stress = c.math.Decimals(c.status.GetStress(), 0)
    -- Modifiers
    data.Modifiers = c.modifier.GetModifiers()
    -- Coords
    local loc = GetEntityCoords(ped)
    data.Coords = {
        x = c.math.Decimals(loc.x, 2),
        y = c.math.Decimals(loc.y, 2),
        z = c.math.Decimals(loc.z, 2)
    }
    return data
end