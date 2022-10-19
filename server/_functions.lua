-- ====================================================================================--
c.func = {}
--[[
NOTES.
    -
    -
    -
]] --
-- ====================================================================================--

--- func desc
---@param any any
function c.func.Func(...)
    local arg = {...}
    local status, val = c.func.Err(unpack(arg))
    return val
end

--- func desc
---@param func any
function c.func.Err(func, ...)
    local arg = {...}
    return xpcall(function()
        return c.func.Func(unpack(arg))
    end, function(err)
        return c.func.Error(err)
    end)
end

--- func desc
---@param err any
function c.func.Error(err)
    if conf.error then
        if type(err) == "string" then
            print("   ^7[^3Error^7]:  ==    ", err)
            print(debug.traceback(_, 2))
        else
            print("   ^7[^3Error^7]:  ==    ", "Unable to type(err) == string. [err] = ", err)
            print(debug.traceback(_, 2))
        end
    end
end

--- func desc
---@param str any
function c.func.Debug_1(str)
    if conf.debug_1 then
        print("   ^7[^6Debug L1^7]:  ==    ", str)
    end
end

--- func desc
---@param str any
function c.func.Debug_2(str)
    if conf.debug_2 then
        print("   ^7[^6Debug L2^7]:  ==    ", str)
    end
end

--- func desc
---@param str any
function c.func.Debug_3(str)
    if conf.debug_3 then
        print("   ^7[^6Debug L3^7]:  ==    ", str)
    end
end

--- func desc
---@param str any
function c.func.Alert(str)
    print("   ^7[^3Alert^7]:  ==    ", str)
end

--- func desc
function c.func.Timestamp()
    return os.time(os.date("*t"))
end

--- func desc
---@param time any
function c.func.Timestring(time)
    local time = time or c.func.Timestamp()
    return os.date("%c", time)
end

-- ====================================================================================--

--- Returns Primary_ID as set by conf.lua. String
---@param source number "license: etc..."
function c.func.identifier(source)
    local src = tonumber(source)
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, conf.identifier) then
            return v
        end
    end
end

--- Returns Steam, FiveM, License, Discord and IP identifiers in that order. Strings
---@param source number "license: etc..."
function c.func.identifiers(source)
    local src = tonumber(source)
    local steam, fivem, license, discord, ip = nil, nil, nil, nil, nil
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, "steam:") then
            steam = v
        elseif string.match(v, "fivem:") then
            fivem = v
        elseif string.match(v, "license:") then
            license = v
        elseif string.match(v, "discord:") then
            discord = v
        elseif string.match(v, "ip:") then
            ip = v
        end
    end
    return steam, fivem, license, discord, ip
end

--- func desc
---@param url any
---@param color any
---@param name any
---@param message any
---@param footer any
function c.func.Discord(url, color, name, message, footer)
    local embed = {{
        ["color"] = color,
        ["title"] = "**" .. name .. "**",
        ["description"] = message,
        ["footer"] = {
            ["text"] = footer
        }
    }}
    PerformHttpRequest(url, function(err, text, headers)
    end, "POST", json.encode({
        username = name,
        embeds = embed
    }), {
        ["Content-Type"] = "application/json"
    })
end

-- local "https://api.twitch.tv/helix/clips?broadcaster_id="..i.broadcaster
--- func desc
---@param source any
---@param event any
function c.func.Eventban(source, event)
    local src = source
    local id = c.func.identifier(src)
    local name = GetPlayerName(src)
    TriggerEvent("txaLogger:CommandExecuted",
        "Player ID: " .. src .. " / " .. id .. " / " .. name .. " : Attempted to abuse [E] " .. event)
    c.func.Debug_2("Player ID: " .. src .. " / " .. id .. " / " .. name .. " : Attempted to abuse [E] " .. event)
    c.sql.user.SetBan(c.func.identifier(src), true, function()
        DropPlayer(src, "Banned for attmpting to exploit event, this has been logged in txAdmin.")
    end)
    return CancelEvent()
end

-- ====================================================================================--

--- func desc
---@param name any
---@param x any
---@param y any
---@param z any
---@param h any
function c.func.CreateVehicle(name, x, y, z, h, owned)
    local data = owned or false
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    local entity = CreateVehicle(hash, x, y, z, h, true, false)
    while not DoesEntityExist(entity) do
        Wait(100)
    end
    Wait(250)
    local net = NetworkGetNetworkIdFromEntity(entity)
    if not data then
        c.data.AddVehicle(net, c.class.Vehicle, net)
    else
        c.data.AddVehicle(net, c.class.OwnedVehicle, net, data)
    end
    return entity, net
end

--- func desc
---@param name any
---@param x any
---@param y any
---@param z any
---@param h any
function c.func.CreatePed(name, x, y, z, h)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    local entity = CreatePed(0, hash, x, y, z, h, true, false)
    while not DoesEntityExist(entity) do
        Wait(100)
    end
    Wait(250)
    local net = NetworkGetNetworkIdFromEntity(entity)
    c.data.AddPed(net, c.class.Npc, net)
    return entity, net
end

--- func desc
---@param name any
---@param x any
---@param y any
---@param z any
---@param isdoor any
function c.func.CreateObject(name, x, y, z, isdoor, owned)
    local data = owned or false
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    if type(isdoor) ~= "boolean" then
        isdoor = false
    end
    local entity = CreateObject(hash, x, y, z, true, isdoor)
    while not DoesEntityExist(entity) do
        Wait(100)
    end
    Wait(250)
    local net = NetworkGetNetworkIdFromEntity(entity)
    if not id then
        c.data.AddObject(net, c.class.BlankObject, net)
    else
        c.data.AddObject(net, c.class.Object, net, data)
    end
    return entity, net
end

-- My own version of the native for the server to use.
--- func desc
---@param hash any
function c.func.IsPedMale(hash)
    if conf.peds.male[hash] then
        return true, "Male"
    end
    if conf.peds.female[hash] then
        return false, "Female"
    end
end

-- My own version of the native for the server to use.
--- func desc
---@param hash any
function c.func.IsPedHuman(hash)
    if conf.peds.animals[hash] then
        return false, "Animal"
    else
        return true, "Human"
    end
end

--- func desc
function c.func.HasPlayers()
    if (#GetPlayers() > 0) then
        return true
    else
        return false
    end
end
