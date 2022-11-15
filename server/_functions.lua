-- ====================================================================================--

c.func = {}

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

--- func desc
---@param source any
---@param event any
function c.func.Eventban(source, event)
    local src = source
    local time = c.func.Timestamp()
    local reason = { ["Event"] = event, ["Timestamp"] = time, ["By"] = "Server" }
    c.sql.user.SetBan(c.func.identifier(src), true, reason, function()
        DropPlayer(src, "[AC] c.func.Eventban : Abuse of [E] " .. event.. ", at [T] "..time..". Please screenshot this for records sake")
        TriggerEvent("txaLogger:CommandExecuted", "[AC] Eventban : Abuse of [E] " .. event.. ", at [T] "..time..".")
    end)
    CancelEvent()
end

-- ====================================================================================--

--- func desc
---@param vehicle any
function c.func.IsAnyPlayerInsideVehicle(vehicle)
	local playerPeds = c.func.GetAllPlayerPeds()
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
function c.func.GetClosestPlayer(position, maxRadius)
	local closestDistance	= maxRadius and (maxRadius * maxRadius) or 1000000.0
	local closestPlayer		= nil
	local closestPos		= nil

	for i, player in ipairs(GetPlayers()) do
		if (GetPlayerRoutingBucket(player) == 0) then
			local ped = GetPlayerPed(player)
			if (DoesEntityExist(ped)) then
				local pos = GetEntityCoords(ped)
				local tempDistSquared = #(position - pos)

				if (tempDistSquared < closestDistance) then
					closestDistance	= tempDistSquared
					closestPlayer	= player
					closestPos		= pos
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
function c.func.GetAllPlayerPeds()
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
function c.func.GetClosestPlayerPed(position, maxRadius)
	local closestDistance	= maxRadius and (maxRadius * maxRadius) or 1000000.0
	local closestPlayerPed	= nil
	local closestPos		= nil

	for i, playerPed in ipairs(c.func.GetAllPlayerPeds()) do
		local pos = GetEntityCoords(playerPed)
		local distanceSquared = #(position - pos)

		if (distanceSquared < closestDistance) then
			closestDistance		= distanceSquared
			closestPlayerPed	= playerPed
			closestPos			= pos
		end
	end

	if (closestPos ~= nil) then
		closestDistance = #(position - closestPos)
	end

	return closestPlayerPed, closestDistance
end

--- func desc
---@param name any
---@param x any
---@param y any
---@param z any
---@param h any
function c.func.CreateVehicle(name, x, y, z, h, data)
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
            c.func.Debug_2("Timout Reached on creating vehicle")
            return false, false
        end
    end
    local net = NetworkGetNetworkIdFromEntity(entity)
    if data then
        c.data.AddVehicle(net, c.class.OwnedVehicle, net, data)
    else
        c.data.AddVehicle(net, c.class.Vehicle, net)
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
	local timer = GetGameTimer()
	while (not DoesEntityExist(entity)) do
        Citizen.Wait(0)
        if ((timer + 3000) < GetGameTimer()) then
            c.func.Debug_2("Timout Reached on creating ped")
            return false, false
        end
    end
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
function c.func.CreateObject(model, x, y, z, isdoor, data)
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
            c.func.Debug_2("Timout Reached on creating object")
            return false, false
        end
    end
    local net = NetworkGetNetworkIdFromEntity(entity)
    if data then
        c.data.AddObject(net, c.class.ExistingObject, net, data)
    else
        c.data.AddObject(net, c.class.BlankObject, net)
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
