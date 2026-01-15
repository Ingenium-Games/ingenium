-- ====================================================================================--
-- Generic server functions (ig.func initialized in server/_var.lua)
-- ci: touch file to trigger wiki-sync workflow when needed
-- ====================================================================================--

--- func desc
function ig.func.Timestamp()
    return os.time(os.date("*t"))
end

--- Converts a Unix timestamp to formatted date/time string
---@param time integer|nil "Unix timestamp (optional, uses current time if nil)"
---@return string Formatted date/time string
function ig.func.Timestring(time)
    local time = time or ig.func.Timestamp()
    return os.date("%c", time)
end

-- ====================================================================================--
-- Credits to Linden
-- 
local intervals = {}
--- Dream of a world where this PR gets accepted.
---@param callback function | number
---@param interval? number
---@param ... any
function ig.func.SetInterval(callback, interval, ...)
	interval = interval or 0

    if type(interval) ~= 'number' then
        return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
    end

	local cbType = type(callback)

	if cbType == 'number' and intervals[callback] then
		intervals[callback] = interval or 0
		return
	end

    if cbType ~= 'function' then
        return error(('Callback must be a function. Received %s'):format(cbType))
    end

	local args, id = { ... }

	Citizen.CreateThreadNow(function(ref)
		id = ref
		intervals[id] = interval or 0
		repeat
			interval = intervals[id]
			Wait(interval)
			callback(table.unpack(args))
		until interval < 0
		intervals[id] = nil
	end)

	return id
end

---@param id number
function ig.func.ClearInterval(id)
    if type(id) ~= 'number' then
        return error(('Interval id must be a number. Received %s'):format(json.encode(id --[[@as unknown]])))
	end

    if not intervals[id] then
        return error(('No interval exists with id %s'):format(id))
	end

	intervals[id] = -1
end

-- ====================================================================================--

--- Returns Primary_ID as set by conf.lua. String
---@param source number "license: etig..."
function ig.func.identifier(source)
    local src = tonumber(source)
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, conf.identifier) then
            return v
        end
    end
end

--- Returns Steam, FiveM, License, Discord and IP identifiers in that order. Strings
---@param source number "license: etig..."
function ig.func.identifiers(source)
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
function ig.func.Discord(url, color, name, message, footer)
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


-- This one probably doesnt work, was testing with it for a while.
--- func desc
---@param url any
---@param color any
---@param name any
---@param message any
---@param footer any
function ig.func.Discorse(message, url, name, coords)
    --[[local post = json.encode({
        raw = message,
        title = "Feedback",
        displayusername = "system",
        topic_id = tonumber(ig.func.Timestamp()),
        category = 26
    })]]--
    PerformHttpRequest(conf.url.discorse_posts, function(err, text, headers)
        print(err)
        print(text)
        print(ig.table.Dump(headers))
    end, "POST", [[{
        "title": "string",
        "raw": "string",
        "topic_id": 0,
        "category": 26,
        }]], {
        ["Api-Key"] = conf.url.discorse_api,
        ["Api-Username"] = "system",
        ["Content-Type"] = "application/json"
    })
end

--- func desc
---@param source any
---@param event any
function ig.func.Eventban(source, event)
    local src = source
    local time = ig.func.Timestamp()
    local reason = {
        ["Event"] = event,
        ["Timestamp"] = time,
        ["By"] = "Server"
    }
    ig.sql.user.SetBan(ig.func.identifier(src), true, reason, function()
        DropPlayer(src, "[AC] ig.func.Eventban : Abuse of [E] " .. event .. ", at [T] " .. time ..
            ". Please screenshot this for records sake")
        TriggerEvent("txaLogger:CommandExecuted", "[AC] Eventban : Abuse of [E] " .. event .. ", at [T] " .. time .. ".")
    end)
    CancelEvent()
end

-- ====================================================================================--

--- func desc
---@param vehicle any
function ig.func.IsAnyPlayerInsideVehicle(vehicle)
    local playerPeds = ig.func.GetAllPlayerPeds()
    for i, playerPed in ipairs(playerPeds) do
        local veh = GetVehiclePedIsIn(playerPed, false)

        if (DoesEntityExist(veh) and veh == vehicle) then
            return true
        end
    end

    return false
end

--- func desc
---@param position any
---@param maxRadius any
function ig.func.GetClosestPlayer(position, maxRadius)
    local closestDistance = maxRadius and (maxRadius * maxRadius) or 1000000.0
    local closestPlayer = nil
    local closestPos = nil

    for i, player in ipairs(GetPlayers()) do
        if (GetPlayerRoutingBucket(player) == 0) then
            local ped = GetPlayerPed(player)
            if (DoesEntityExist(ped)) then
                local pos = GetEntityCoords(ped)
                local tempDistSquared = #(position - pos)

                if (tempDistSquared < closestDistance) then
                    closestDistance = tempDistSquared
                    closestPlayer = player
                    closestPos = pos
                end
            end
        end
    end

    if (closestPos ~= nil) then
        closestDistance = #(position - closestPos)
    end

    return closestPlayer, closestDistance
end

--- func desc
function ig.func.GetAllPlayerPeds()
    local playerPeds = {}

    local peds = GetAllPeds()
    for i, ped in ipairs(peds) do
        if (DoesEntityExist(ped) and IsPedAPlayer(ped)) then
            table.insert(playerPeds, ped)
        end
    end

    return playerPeds
end

--- func desc
---@param position any
---@param maxRadius any
function ig.func.GetClosestPlayerPed(position, maxRadius)
    local closestDistance = maxRadius and (maxRadius * maxRadius) or 1000000.0
    local closestPlayerPed = nil
    local closestPos = nil

    for i, playerPed in ipairs(ig.func.GetAllPlayerPeds()) do
        local pos = GetEntityCoords(playerPed)
        local distanceSquared = #(position - pos)

        if (distanceSquared < closestDistance) then
            closestDistance = distanceSquared
            closestPlayerPed = playerPed
            closestPos = pos
        end
    end

    if (closestPos ~= nil) then
        closestDistance = #(position - closestPos)
    end

    return closestPlayerPed, closestDistance
end

--- Create a vehicle entity
---@param name string|integer "Vehicle model name (string) or hash (integer)"
---@param x number "X coordinate"
---@param y number "Y coordinate"
---@param z number "Z coordinate"
---@param h number "Heading in degrees"
---@param data table|nil "Optional vehicle data/config"
---@param routingBucket number|nil "Optional routing bucket (inherits from calling context if not specified)"
---@return number|boolean entity The vehicle entity handle or false on failure
---@return number|boolean net The network ID or false on failure
function ig.func.CreateVehicle(name, x, y, z, h, data, routingBucket)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    local entity = CreateVehicle(hash, x, y, z, h, true, false)
    local timer = GetGameTimer()
    while (not DoesEntityExist(entity)) do
        Citizen.Wait(0)
        if ((timer + 3000) < GetGameTimer()) then
            ig.log.Debug("ENTITY", "Timeout reached on creating vehicle")
            return false, false
        end
    end
    
    -- Set routing bucket if specified
    if routingBucket then
        ig.inst.SetEntity(entity, routingBucket)
    end
    
    local net = NetworkGetNetworkIdFromEntity(entity)
    if data then
        ig.data.AddVehicle(net, ig.class.OwnedVehicle, net, data)
    else
        ig.data.AddVehicle(net, ig.class.Vehicle, net)
    end
    return entity, net
end

--- Create a ped entity (NPC)
---@param name string|integer "Ped model name (string) or hash (integer)"
---@param x number "X coordinate"
---@param y number "Y coordinate"
---@param z number "Z coordinate"
---@param h number "Heading in degrees"
---@param routingBucket number|nil "Optional routing bucket (inherits from calling context if not specified)"
---@return number|boolean entity The ped entity handle or false on failure
---@return number|boolean net The network ID or false on failure
function ig.func.CreatePed(name, x, y, z, h, routingBucket)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    local entity = CreatePed(0, hash, x, y, z, h, true, false)
    local timer = GetGameTimer()
    while (not DoesEntityExist(entity)) do
        Citizen.Wait(0)
        if ((timer + 3000) < GetGameTimer()) then
            ig.log.Debug("ENTITY", "Timeout reached on creating ped")
            return false, false
        end
    end
    
    -- Set routing bucket if specified
    if routingBucket then
        ig.inst.SetEntity(entity, routingBucket)
    end
    
    local net = NetworkGetNetworkIdFromEntity(entity)
    ig.data.AddPed(net, ig.class.Npc, net)
    return entity, net
end

--- Create an object entity
---@param model string|integer "Object model name (string) or hash (integer)"
---@param x number "X coordinate"
---@param y number "Y coordinate"
---@param z number "Z coordinate"
---@param isdoor boolean "Whether this object is a door"
---@param data table|nil "Optional object data/config"
---@return number|boolean entity The object entity handle or false on failure
---@return number|boolean net The network ID or false on failure
function ig.func.CreateObject(model, x, y, z, isdoor, data)
    local hash = nil
    if type(model) == "number" then
        hash = model
    else
        hash = GetHashKey(model)
    end
    if type(isdoor) ~= "boolean" then
        isdoor = false
    end
    local entity = CreateObject(hash, x, y, z, true, isdoor)
    local timer = GetGameTimer()
    while (not DoesEntityExist(entity)) do
        Citizen.Wait(0)
        if ((timer + 3000) < GetGameTimer()) then
            ig.log.Debug("ENTITY", "Timeout reached on creating object")
            return false, false
        end
    end
    local net = NetworkGetNetworkIdFromEntity(entity)
    if data then
        ig.data.AddObject(net, ig.class.ExistingObject, net, data)
    else
        ig.data.AddObject(net, ig.class.BlankObject, net)
    end
    return entity, net
end

--- Checks if a ped model is male based on configuration
---@param hash integer "Ped model hash"
---@return boolean|nil Is male (true/false) or nil if not configured
---@return string|nil Gender label ('Male', 'Female', or nil)
function ig.func.IsPedMale(hash)
    if conf.peds.male[hash] then
        return true, "Male"
    end
    if conf.peds.female[hash] then
        return false, "Female"
    end
end

--- Checks if a ped model is human (not an animal) based on configuration
---@param hash integer "Ped model hash"
---@return boolean Is human
---@return string Type label ('Human' or 'Animal')
function ig.func.IsPedHuman(hash)
    if conf.peds.animals[hash] then
        return false, "Animal"
    else
        return true, "Human"
    end
end

--- func desc
function ig.func.HasPlayers()
    if (#GetPlayers() > 0) then
        return true
    else
        return false
    end
end

