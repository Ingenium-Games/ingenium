-- ====================================================================================--

c.data = {}
--[[
NOTES.
    -
    -
    -
]]--
-- ====================================================================================--

--- Upon joining, these are core functions to run internally prior to sending the join request to the server
---@param cb function "Callback function to run if any provided."
function c.data.Initilize(cb)
    -- Get time and update every minute.
    c.time.UpdateTime()
    --
    TriggerServerEvent('Server:PlayerConnecting')
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
function c.data.GetLocalPlayer()
    return LocalPlayer.state
end

--- Returns the Player state
function c.GetLocalPlayer()
    return c.data.GetLocalPlayer()
end

--- Returns the Player state
function c.data.GetLocalPlayerState(key)
    return LocalPlayer.state[key]
end

--- Returns the Player state
function c.GetLocalPlayerState(key)
    return LocalPlayer.state[key]
end

-- Please do not use this other than for animations or such...
--- Set the Players's state bag.
---@param key string "The key"
---@param value any "Just not a table"
---@param sync boolean "Sync to Server, default is false"
function c.data.SetLocalPlayerState(key, value, sync)
    if sync == nil then sync = false end
    LocalPlayer.state:set(key, value, sync)
end

-- Please do not use this other than for animations or such...
--- Set the Players's state bag.
---@param key string "The key"
---@param value any "Just not a table"
---@param sync boolean "Sync to Server, default is false"
function c.SetLocalPlayerState(key, value, sync)
    c.data.SetLocalPlayerState(key, value, sync)
end

--- Return the Players's state bag.
---@param id any "Player's Server Id"
function c.data.GetPlayer(id)
    return Player(id).state
end

--- Return the Players's state bag.
---@param id any "Player's Server Id"
function c.data.GetPlayerState(id,key)
    return Player(id).state[key]
end

--- Return the Players's state bag.
---@param id any "Player's Server Id"
function c.GetPlayerState(id,key)   
    return c.data.GetPlayerState(id,key)
end

--- Return the Players's state bag.
---@param ped any "Player's Ped Entity"
function c.data.GetPlayerPedState(ped,key)
    return Player(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))).state[key]
end

--- Return the Players's state bag.
---@param ped any "Player's Ped Entity"
function c.GetPlayerPedState(ped,key)    
    return c.data.GetPlayerPedState(ped,key)
end

--- Return the Entity"s state bag.
---@param ent any "Entity"
function c.data.GetEntityState(ent,key)    
    return Entity(ent).state[key]
end

--- Return the Entity"s state bag.
---@param ent any "Entity"
function c.GetEntityState(ent,key)    
    return c.data.GetEntityState(ent,key)
end

--- func desc
---@param type number "1-3"
---@param ent any "The passed client entity"
---@param key any "The state bag key you want to get the data from."
function c.data.GetEntityStateByType(type, ent, key)
    --
    -- Object
    if type == 3 then
        return c.data.GetEntityState(ent, key) 
    --
    -- Vehicle
    elseif type == 2 then
        return c.data.GetEntityState(ent, key) 
    --
    -- Ped
    elseif type == 1 then
        if IsPedAPlayer(ent) then
            return c.data.GetPlayerPedState(ent, key)
        else
            return c.data.GetEntityState(ent, key)
        end
    end
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