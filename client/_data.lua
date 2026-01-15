-- ====================================================================================--
-- Client data management (ig.data initialized in client/_var.lua)
-- ====================================================================================--

--- Upon joining, these are core functions to run internally prior to sending the join request to the server
---@param cb function "Callback function to run if any provided."
function ig.data.Initilize(cb)
    -- Get time and update every minute.
    ig.time.UpdateTime()
    --
    -- Use secure callback for player connecting
    TriggerServerCallback({
        eventName = "Server:PlayerConnecting",
        args = {},
        callback = function(result)
            if result and not result.success then
                ig.debug.Error("Failed to connect: " .. (result.error or "Unknown error"))
            end
        end
    })
    if cb then
        cb()
    end
end

--- Returns the local from the local variable. String
function ig.data.GetLocale()
    return ig.locale
end

--- Takes local information from the `user` SQL table and sets it for the client.
function ig.data.SetLocale()
    ig.locale = LocalPlayer.state.Locale
end

--- Sets the client as receieved the character data. Boolean
---@param bool boolean "Set loaded status to true or false."
function ig.data.SetLoadedStatus(bool)
    if type(bool) == "boolean" then
        ig._loaded = bool
    end
end

--- Returns if the client has finished loading. Boolean
function ig.data.GetLoadedStatus()
    return ig._loaded
end

--- Returns if the client has finished loading. Boolean
function ig.data.IsPlayerLoaded()
    return ig._loaded
end

--- Returns the Player state
function ig.data.GetLocalPlayer()
    return LocalPlayer.state
end

--- Returns the Player state
function ig.data.GetLocalPlayerState(key)
    return LocalPlayer.state[key]
end

-- Please do not use this other than for animations or such...
--- Set the Players"s state bag.
---@param key string "The key"
---@param value any "Just not a table"
---@param sync boolean "Sync to Server, default is false"
function ig.data.SetLocalPlayerState(key, value, sync)
    if sync == nil then sync = false end
    LocalPlayer.state:set(key, value, sync)
end

--- Return the Players"s state bag.
---@param id any "Player's Server Id"
function ig.data.GetPlayer(id)
    local id = id or -1
    return Player(id).state
end

--- Return the Players"s state bag.
---@param id any "Player"s Server Id"
function ig.data.GetPlayerState(id, key)
    return Player(id).state[key]
end

--- Return the Players"s state bag.
---@param ped any "Player's Ped Entity"
function ig.data.GetPlayerPedState(ped, key)
    local player = NetworkGetPlayerIndexFromPed(ped)
    local id = GetPlayerServerId(player)
    return Player(id).state[key]
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function ig.data.GetEntityState(net, key)
    local entity = NetworkGetEntityFromNetworkId(net)
    return Entity(entity).state[key]
end

--- Return the Entity"s state bag.
---@param net any "NetworkId"
function ig.data.SetEntityState(net, key, value)   
    local entity = NetworkGetEntityFromNetworkId(net) 
    Entity(entity).state:set(tostring(key), value, true)
end

--- func desc
---@param net any "The passed client entity"
---@param key any "The state bag key you want to get the data from."
function ig.data.GetEntityStateCheck(net, key)
    local entity = NetworkGetEntityFromNetworkId(net)
    local type = GetEntityType(entity)
    --
    if type == 1 then
        if IsPedAPlayer(entity) then
            return ig.data.GetPlayerPedState(entity, key)
        end
    end
    --
    return ig.data.GetEntityState(net, key)
end

function ig.data.Packet()
    return {
        -- Data to send to server for server to update
        Health = ig.status.GetHealth(),
        Armour = ig.status.GetArmour(),
        Hunger = ig.status.GetHunger(),
        Thirst = ig.status.GetThirst(),
        Stress = ig.status.GetStress(),
        Modifiers = ig.modifier.GetModifiers(),
        -- 
        

    }
end

-- ====================================================================================--