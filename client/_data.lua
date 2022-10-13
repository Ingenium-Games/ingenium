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
    TriggerServerEvent("Server:PlayerConnecting")
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
    if type(bool) == "boolean" then
        c._loaded = bool
    end
end

--- Returns if the client has finished loading. Boolean
function c.data.GetLoadedStatus()
    return c._loaded
end

--- Returns if the client has finished loading. Boolean
function c.data.IsPlayerLoaded()
    return c._loaded
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
--- Set the Players"s state bag.
---@param key string "The key"
---@param value any "Just not a table"
---@param sync boolean "Sync to Server, default is false"
function c.data.SetLocalPlayerState(key, value, sync)
    if sync == nil then sync = false end
    LocalPlayer.state:set(key, value, sync)
end

-- Please do not use this other than for animations or such...
--- Set the Players"s state bag.
---@param key string "The key"
---@param value any "Just not a table"
---@param sync boolean "Sync to Server, default is false"
function c.SetLocalPlayerState(key, value, sync)
    c.data.SetLocalPlayerState(key, value, sync)
end

--- Return the Players"s state bag.
---@param id any "Player"s Server Id"
function c.data.GetPlayer(id)
    local id = id or -1
    return Player(id).state
end

--- Return the Players"s state bag.
---@param id any "Player"s Server Id"
function c.data.GetPlayerState(id,key)
    return Player(id).state[key]
end

--- Return the Players"s state bag.
---@param id any "Player"s Server Id"
function c.GetPlayerState(id,key)   
    return c.data.GetPlayerState(id,key)
end

--- Return the Players"s state bag.
---@param ped any "Player"s Ped Entity"
function c.data.GetPlayerPedState(ped,key)
    return Player(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))).state[key]
end

--- Return the Players"s state bag.
---@param ped any "Player"s Ped Entity"
function c.GetPlayerPedState(ped,key)    
    return c.data.GetPlayerPedState(ped,key)
end



--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.GetEntityState(net,key)    
    return Entity(NetworkGetEntityFromNetworkId(net)).state[key]
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.GetEntityState(net,key)    
    return c.data.GetEntityState(net,key)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.SetEntityState(net,key,value)    
    Entity(NetworkGetEntityFromNetworkId(net)).state:set(tostring(key), value, true)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.SetEntityState(net,key,value)    
    c.data.SetEntityState(net,key,value)   
end



--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.GetObjectState(net,key)    
    return Entity(NetToObj(net)).state[key]
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.GetObjectState(net,key)    
    return c.data.GetObjectState(net,key)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.SetObjectState(net,key,value)    
    Entity(NetToObj(net)).state:set(tostring(key), value, true)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.SetObjectState(net,key,value)    
    c.data.SetObjectState(net,key,value)   
end



--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.GetVehicleState(net,key)    
    return Entity(NetToVeh(net)).state[key]
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.GetVehicleState(net,key)    
    return c.data.GetVehicleState(net,key)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.SetVehicleState(net,key,value)    
    Entity(NetToVeh(net)).state:set(tostring(key), value, true)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.SetVehicleState(net,key,value)    
    c.data.SetVehicletate(net,key,value)   
end



--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.GetPedState(net,key)    
    return Entity(NetToPed(net)).state[key]
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.GetPedState(net,key)    
    return c.data.GetPedState(net,key)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.data.SetPedState(net,key,value)    
    Entity(NetToPed(net)).state:set(tostring(key), value, true)
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function c.SetPedState(net,key,value)    
    c.data.SetPedState(net,key,value)   
end

--- func desc
---@param net any "The passed client entity"
---@param key any "The state bag key you want to get the data from."
function c.data.GetEntityStateByType(net, key)
    local entity = NetworkGetEntityFromNetworkId(net)
    local type = GetEntityType(entity)
    --
    -- Object
    if type == 3 then
        return c.data.GetObjectState(net, key) 
    --
    -- Vehicle
    elseif type == 2 then
        return c.data.GetVehicleState(net, key) 
    --
    -- Ped
    elseif type == 1 then
        if IsPedAPlayer(ent) then
            return c.data.GetPlayerPedState(net, key)
        else
            return c.data.GetPedState(net, key)
        end
    end
end

function c.data.Packet()
    return {
        Health = c.status.GetHealth(),
        Armour = c.status.GetArmour(),
        Hunger = c.status.GetHunger(),
        Thirst = c.status.GetThirst(),
        Stress = c.status.GetStress(),
        Modifiers = c.modifier.GetModifiers(),
    }
end

-- ====================================================================================--