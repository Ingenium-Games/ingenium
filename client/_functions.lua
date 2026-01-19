-- Test for ci
-- ====================================================================================--
-- Generic functions (ig.func initialized in client/_var.lua)
-- ====================================================================================--

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

--- Preduce a Busy Spinner
--- func desc
function ig.func.IsBusy()
    BeginTextCommandBusyspinnerOn("FM_COR_AUTOD")
    EndTextCommandBusyspinnerOn(5)
end

--- Remvoe a Busy Spinner
--- func desc
function ig.func.NotBusy()
    BusyspinnerOff()
    PreloadBusyspinner()
end

--- Produce a Busy Spinner with a "Please Wait"
--- func desc
function ig.func.PleaseWait()
    BeginTextCommandBusyspinnerOn("PM_WAIT")
    EndTextCommandBusyspinnerOn(5)
end

--- Informs the client to Please Wait with a Busy Spinner over a timeframe.
---@param ms number "Milisecons to wait."
function ig.func.IsBusyPleaseWait(ms)
    ig.func.PleaseWait()
    --
    Citizen.Wait(ms)
    --
    ig.func.NotBusy()
end

--- func desc
---@param ms any
function ig.func.FadeOut(ms)
    if not IsScreenFadedOut() then
        DoScreenFadeOut(ms)
        Citizen.Wait(0)
        while IsScreenFadingOut() do
            Citizen.Wait(100)
            if IsScreenFadedOut() then
                break
            end
        end
    end
end

--- func desc
---@param ms any
function ig.func.FadeIn(ms)
    if not IsScreenFadedIn() then
        DoScreenFadeIn(ms)
        Citizen.Wait(0)
        while IsScreenFadingIn() do
            Citizen.Wait(100)
            if IsScreenFadedIn() then
                break
            end
        end
    end
end

-- ====================================================================================--

-- @entity - the object
-- @arrays - locations in a table format
-- @style - ig.SelectMarker() - Pick Marker type.
function ig.func.CompareCoords(coords, arrays, style, range)
    if not range then
        range = 10
    end
    local dstchecked = 1000
    local pos = coords
    if type(arrays) == "table" then
        for i = 1, #arrays do
            local ords = arrays[i]
            local comparedst = #(pos - ords)
            if comparedst < dstchecked then
                dstchecked = comparedst
            end
            if comparedst < range then
                if style then
                    ig.marker.Place(ords, style)
                end
            end
        end
        return dstchecked
    else
        local comparedst = #(pos - arrays)
        if comparedst < dstchecked then
            dstchecked = comparedst
        end
        if comparedst < range then
            if style then
                ig.marker.Place(arrays, style)
            end
        end
        return dstchecked
    end
end

--- Returns Players within the designated radius.
---@param ords table "Generally a {x,y,z} or vec3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function ig.func.GetPlayersInArea(ords, radius, minimal)
    local coords = vec3(ords)
    local objs = GetGamePool("CPed")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            if IsPedAPlayer(v) then
                local target = vec3(GetEntityCoords(v))
                local distance = #(target - coords)
                if distance <= radius then
                    table.insert(obj, v)
                end
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            if IsPedAPlayer(v) then
                local model = GetEntityModel(v)
                local target = vec3(GetEntityCoords(v))
                local distance = #(target - coords)
                if distance <= radius then
                    obj[v] = {
                        ["Model"] = model,
                        ["Coords"] = target
                    }
                end
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns All Peds (including Players) within the designated radius.
---@param ords table "Generally a {x,y,z} or vec3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function ig.func.GetPedsInArea(ords, radius, minimal)
    local coords = vec3(ords)
    local objs = GetGamePool("CPed")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vec3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vec3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["Model"] = model,
                    ["Coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Objects within the designated radius.
---@param ords table "Generally a {x,y,z} or vec3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function ig.func.GetObjectsInArea(ords, radius, minimal)
    local coords = vec3(ords)
    local objs = GetGamePool("CObject")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vec3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vec3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["Model"] = model,
                    ["Coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Vehicles within the designated radius.
---@param ords table "Generally a {x,y,z} or vec3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function ig.func.GetVehiclesInArea(ords, radius, minimal)
    local coords = vec3(ords)
    local objs = GetGamePool("CVehicle")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vec3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vec3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["Model"] = model,
                    ["Coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Pickups within the designated radius.
---@param ords table "Generally a {x,y,z} or vec3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function ig.func.GetPickupsInArea(coords, radius, minimal)
    local coords = vec3(ords)
    local objs = GetGamePool("CPickup")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vec3(GetPickupCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetPickupHash(v)
            local target = vec3(GetPickupCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["Model"] = model,
                    ["Coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

function ig.func.GetPlayers()
    return GetActivePlayers()
end

-- returns closest, closestdist
--- func desc
function ig.func.GetClosestPed()
    local closest = -1
    local closestdist = -1
    local ply = PlayerPedId()
    local coords = vec3(GetEntityCoords(ply))
    local peds = ig.func.GetPedsInArea(coords, 20, true)
    for _, value in pairs(peds) do
        local targetcoords = vec3(GetEntityCoords(value))
        local distance = #(targetcoords - coords)
        if (closestdist == -1 or closestdist > distance) then
            closest = value
            closestdist = distance
        end
    end
    return closest, closestdist
end

-- returns closest, closestdist
--- func desc
function ig.func.GetClosestPlayer()
    local players = GetActivePlayers()
    local closest = -1
    local closestdist = -1
    local ply = PlayerPedId()
    local coords = vec3(GetEntityCoords(ply))
    for _, value in pairs(players) do
        local target = GetPlayerPed(value)
        if target ~= ply then
            local targetcoords = vec3(GetEntityCoords(target))
            local distance = #(targetcoords - coords)
            if (closestdist == -1 or closestdist > distance) then
                closest = value
                closestdist = distance
            end
        end
    end
    return closest, closestdist, IsPedInAnyVehicle(closest, false)
end

-- returns closestVeh, closestdist
--- func desc
function ig.func.GetClosestVehicle()
    local closest = -1
    local closestdist = -1
    local ply = PlayerPedId()
    local coords = vec3(GetEntityCoords(ply))
    local vehicles = ig.func.GetVehiclesInArea(coords, 20, true)
    for _, value in pairs(vehicles) do
        local targetcoords = vec3(GetEntityCoords(value))
        local distance = #(targetcoords - coords)
        if (closestdist == -1 or closestdist > distance) then
            closest = value
            closestdist = distance
        end
    end
    return closest, closestdist
end

-- returns closestVeh, closestdist
--- func desc
---@param positions any
function ig.func.GetClosestPosition(positions)
    local closest = -1
    local closestdist = -1
    local count = 0
    local ply = PlayerPedId()
    local coords = vec3(GetEntityCoords(ply))
    local positions = positions
    for i=1, #positions, 1 do
        local targetcoords = vec3(positions[i].x,positions[i].y,positions[i].z)
        local distance = #(targetcoords - coords)
        if (closestdist == -1 or closestdist > distance) then
            closest = positions[i]
            closestdist = distance
        end
        count = count + 1
    end
    return closest, closestdist, count
end

-- base events.
--- func desc
---@param ped any
function ig.func.GetVehicleSeatOfPed(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
        if (GetPedInVehicleSeat(vehicle, i) == ped) then
            return i
        end
    end
    return -2
end

--- func desc
function ig.func.GetEntityFromRay(flag)
	local cam = GetGameplayCamCoord()
	local direction = GetGameplayCamRot()
	direction = vec2(math.rad(direction.x), math.rad(direction.z))
	local num = math.abs(math.cos(direction.x))
	direction = vec3((-math.sin(direction.y) * num), (math.cos(direction.y) * num), math.sin(direction.x))
	local destination = vec3(cam.x + direction.x * 30, cam.y + direction.y * 30, cam.z + direction.z * 30)
	local rayHandle = StartShapeTestLosProbe(cam, destination, flag or -1, ped, 0)
	while true do
		Wait(1)
		local result, collision, endords, surface, material, entity = GetShapeTestResultIncludingMaterial(rayHandle)
		if result ~= 1 then
			return entity, collision, surface, material, endords
		end
	end
end

--- func desc
---@param networkId any
---@param timeout any
function ig.func.WaitUntilNetIdExists(networkId, timeout)
	local threshold = GetGameTimer() + (timeout or 5000)

	while (not NetworkDoesEntityExistWithNetworkId(networkId) and GetGameTimer() < threshold) do
		Citizen.Wait(0)
	end

	return NetworkDoesEntityExistWithNetworkId(networkId)
end

--- func desc
---@param entityHandle any
---@param timeout any
function ig.func.WaitUntilPlayerIsOwner(entityHandle, timeout)
	local threshold = GetGameTimer() + (timeout or 5000)

	while (DoesEntityExist(entityHandle) and NetworkGetEntityOwner(entityHandle) ~= PlayerId() and GetGameTimer() < threshold) do
		Citizen.Wait(0)
	end

	return DoesEntityExist(entityHandle) and NetworkGetEntityOwner(entityHandle) == PlayerId()
end

--- func desc
---@param name any
---@param x any
---@param y any
---@param z any
---@param h any
function ig.func.CreatePed(name, x, y, z, h)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    local check = DoesObjectOfTypeExistAtCoords(x, y, z, 1, hash, 0)
    if not check then
        local entity = CreatePed(0, hash, x, y, z, h, true, false)
        local timer = GetGameTimer()
        while (not DoesEntityExist(entity)) do
            Citizen.Wait(0)
            if ((timer + 3000) < GetGameTimer()) then
                ig.log.Debug("ENTITY", "Timeout reached on creating object")
                return false, false
            end
        end
        local net = NetworkGetEntityFromNetworkId(entity)
        SetNetworkIdCanMigrate(net, true)
        SetModelAsNoLongerNeeded(hash)
        return entity, net
    else
        return false, false
    end
end

--- func desc
---@param name any
---@param x any
---@param y any
---@param z any
---@param isdoor any
function ig.func.CreateObject(name, x, y, z, isdoor)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    if type(isdoor) ~= "boolean" then
        isdoor = false
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    local check = DoesObjectOfTypeExistAtCoords(x, y, z, 1, hash, 0)
    if not check then
        local entity = CreateObject(hash, x, y, z, true, isdoor)
        local timer = GetGameTimer()
        while (not DoesEntityExist(entity)) do
            Citizen.Wait(0)
            if ((timer + 3000) < GetGameTimer()) then
                ig.log.Debug("ENTITY", "Timeout reached on creating object")
                return false, false
            end
        end
        local net = NetworkGetEntityFromNetworkId(entity)
        SetNetworkIdCanMigrate(net, true)
        SetModelAsNoLongerNeeded(hash)
        return entity, net
    else
        return false, false
    end
end

--- func desc
---@param name any
---@param x any
---@param y any
---@param z any
---@param h any
function ig.func.CreateVehicle(name, x, y, z, h)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    local check = DoesObjectOfTypeExistAtCoords(x, y, z, 1, hash, 0)
    if not check then
        local entity = CreateVehicle(hash, x, y, z, h, true, true)
        local timer = GetGameTimer()
        while (not DoesEntityExist(entity)) do
            Citizen.Wait(0)
            if ((timer + 3000) < GetGameTimer()) then
                ig.log.Debug("ENTITY", "Timeout reached on creating object")
                return false, false
            end
        end
        local net = NetworkGetEntityFromNetworkId(entity)
        SetVehicleOnGroundProperly(entity)
        SetVehicleHasBeenOwnedByPlayer(entity, true)
        SetNetworkIdCanMigrate(net, true)
        SetVehicleNeedsToBeHotwired(net, false)
        SetModelAsNoLongerNeeded(hash)
        return entity, net
    else
        return false, false
    end
end


--- func desc
---@param coords any
---@param radius any
function ig.func.IsVehicleSpawnClear(coords, radius)
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    local vehicles = GetGamePool('CVehicle')
    local closeVeh = {}
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)
        if distance <= radius then
            closeVeh[#closeVeh + 1] = vehicles[i]
        end
    end
    if #closeVeh > 0 then
        return false
    end
    return true
end


-- returns all Modifications of a vehicle
--- func desc
---@param vehicle any
function ig.func.GetVehicleModifications(vehicle)
    -- main colors
    local primaryColor, secondaryColor = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    -- custom colors
    local customPrimaryColor, customSecondaryColor
    if (GetIsVehiclePrimaryColourCustom(vehicle)) then
        local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
        customPrimaryColor = {r, g, b}
    end
    if (GetIsVehicleSecondaryColourCustom(vehicle)) then
        local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
        customSecondaryColor = {r, g, b}
    end
    -- tire smoke color
    r, g, b = GetVehicleTyreSmokeColor(vehicle)
    local tireSmokeColor = {r, g, b}
    -- neon lights color
    local r, g, b = GetVehicleNeonLightsColour(vehicle)
    local neonLightsColor = {r, g, b}
    local enabledNeonLights = {IsVehicleNeonLightEnabled(vehicle, 0), IsVehicleNeonLightEnabled(vehicle, 1),
                               IsVehicleNeonLightEnabled(vehicle, 2), IsVehicleNeonLightEnabled(vehicle, 3)}
    return { -- 1
    string.upper(GetVehicleNumberPlateText(vehicle)), -- 2
    ig.func.GetVehicleMods(vehicle), -- 3
    primaryColor, -- 4
    secondaryColor, -- 5
    pearlescentColor, -- 6
    wheelColor, -- 7
    customPrimaryColor, -- 8
    customSecondaryColor, -- 9
    GetVehicleInteriorColor(vehicle), -- 10
    GetVehicleDashboardColor(vehicle), -- 11
    tireSmokeColor, -- 12
    GetVehicleXenonLightsColour(vehicle), -- 13
    neonLightsColor, -- 14
    enabledNeonLights, -- 15
    ig.func.GetVehicleExtras(vehicle), -- 16
    GetVehicleWheelType(vehicle), -- 17
    GetVehicleModVariation(vehicle, 23), -- 18
    GetVehicleModVariation(vehicle, 24), -- 19
    not GetVehicleTyresCanBurst(vehicle), -- 20
    (GetGameBuildNumber() >= 2372) and GetDriftTyresEnabled(vehicle), -- 21
    GetVehicleNumberPlateTextIndex(vehicle), -- 22
    GetVehicleWindowTint(vehicle), -- 23
    GetVehicleLivery(vehicle), -- 24
    GetVehicleRoofLivery(vehicle)}
end

-- apply all vehicle Modifications
--- func desc
---@param vehicle any
---@param Modifications any
function ig.func.SetVehicleModifications(vehicle, Modifications)
    SetVehicleModKit(vehicle, 0)
    -- 16 wheelType
    SetVehicleWheelType(vehicle, Modifications[16])
    -- 2 mods
    ig.func.SetVehicleMods(vehicle, Modifications[2], Modifications[17], Modifications[18])
    -- 3-4 primary/secondaryColor
    SetVehicleColours(vehicle, Modifications[3], Modifications[4])
    -- 5-6 pearlescent/wheelColor
    SetVehicleExtraColours(vehicle, Modifications[5], Modifications[6])
    -- 7 customPrimaryColor
    if (Modifications[7]) then
        SetVehicleCustomPrimaryColour(vehicle, Modifications[7][1], Modifications[7][2], Modifications[7][3])
    end
    -- 8 customSecondaryColor
    if (Modifications[8]) then
        SetVehicleCustomSecondaryColour(vehicle, Modifications[8][1], Modifications[8][2], Modifications[8][3])
    end
    -- 9 interiorColor
    SetVehicleInteriorColor(vehicle, Modifications[9])
    -- 10 dashboardColor
    SetVehicleDashboardColor(vehicle, Modifications[10])
    -- 11 tireSmokeColor
    SetVehicleTyreSmokeColor(vehicle, Modifications[11][1], Modifications[11][2], Modifications[11][3])
    -- 12 xenonLightsColor
    SetVehicleXenonLightsColour(vehicle, Modifications[12])
    -- 13 neonLightsColor
    SetVehicleNeonLightsColour(vehicle, Modifications[13][1], Modifications[13][2], Modifications[13][3])
    -- 14 enabledNeonLights
    for i = 0, 3, 1 do
        SetVehicleNeonLightEnabled(vehicle, i, Modifications[14][i + 1])
    end
    -- 15 extras
    ig.func.SetVehicleExtras(vehicle, Modifications[15])
    -- 19 bulletproofTires
    SetVehicleTyresCanBurst(vehicle, not Modifications[19])
    -- 20 driftTires
    if (GetGameBuildNumber() >= 2372) then
        SetDriftTyresEnabled(vehicle, Modifications[20])
    end
    -- 1 numberPlateText
    SetVehicleNumberPlateText(vehicle, string.upper(Modifications[1]))
    -- 21 numberPlateTextIndex
    SetVehicleNumberPlateTextIndex(vehicle, Modifications[21])
    -- 22 windowTint
    SetVehicleWindowTint(vehicle, Modifications[22])
    -- 23 livery
    SetVehicleLivery(vehicle, Modifications[23])
    -- 24 roofLivery
    SetVehicleRoofLivery(vehicle, Modifications[24])
end

-- returns the status values of a vehicle
--- func desc
---@param vehicle any
function ig.func.GetVehicleCondition(vehicle)
    local fuelLevel = 65.0
    fuelLevel = GetVehicleFuelLevel(vehicle)
    fuelLevel = math.floor(fuelLevel * 10.0) / 10.0
    return { -- 1 entity health
    math.floor(GetEntityHealth(vehicle) * 10.0) / 10.0, -- 2 body health
    math.floor(GetVehicleBodyHealth(vehicle) * 10.0) / 10.0, -- 3 engine health
    math.floor(GetVehicleEngineHealth(vehicle) * 10.0) / 10.0, -- 4 petrol tank health
    math.floor(GetVehiclePetrolTankHealth(vehicle) * 10.0) / 10.0, -- 5 dirt level
    math.floor(GetVehicleDirtLevel(vehicle) * 10.0) / 10.0, -- 6 fuel level
    fuelLevel, -- 7 lock status
    GetVehicleDoorLockStatus(vehicle), -- 8 tire states
    ig.func.GetVehicleTireStates(vehicle), -- 9 door states
    ig.func.GetVehicleDoorStates(vehicle), -- 10 window states
    ig.func.GetVehicleWindowStates(vehicle)}
end

-- apply all vehicle status values
--- func desc
---@param vehicle any
---@param Condition any
function ig.func.SetVehicleCondition(vehicle, Condition)
    -- 1 entity health
    SetEntityHealth(vehicle, Condition[1])
    -- 2 body health
    SetVehicleBodyHealth(vehicle, Condition[2])
    -- 3 engine health
    SetVehicleEngineHealth(vehicle, Condition[3])
    -- 4 petrol tank health
    SetVehiclePetrolTankHealth(vehicle, Condition[4])
    if ((Condition[3] < -3999.0 or Condition[4] < -999.0)) then
        TriggerServerEvent("AdvancedParking:renderScorched", NetworkGetNetworkIdFromEntity(vehicle), true)
    end
    -- 5 dirt level
    SetVehicleDirtLevel(vehicle, Condition[5])
    -- 6 fuel level
    SetVehicleFuelLevel(vehicle, Condition[6])
    -- 7 lock status
    SetVehicleDoorsLocked(vehicle, Condition[7])
    -- 8 tire states
    ig.func.SetVehicleTireStates(vehicle, Condition[8])
    -- 9 door states
    ig.func.SetVehicleDoorStates(vehicle, Condition[9])
    -- 10 window states
    ig.func.SetVehicleWindowStates(vehicle, Condition[10])
end

-- returns the complete statebag data for a vehicle (captures all state changes made by any script)
--- func desc
---@param vehicle any
function ig.func.GetVehicleStatebag(vehicle)
    local statebag = {}
    if GetEntityStatebag(vehicle) then
        for key, value in pairs(GetEntityStatebag(vehicle)) do
            statebag[key] = value
        end
    end
    return statebag
end

-- apply all statebag data back to a vehicle
--- func desc
---@param vehicle any
---@param statebag any
function ig.func.SetVehicleStatebag(vehicle, statebag)
    if statebag and type(statebag) == 'table' then
        for key, value in pairs(statebag) do
            Entity(vehicle).state[key] = value
        end
    end
end

-- returns all non-stock vehicle mods
--- func desc
---@param vehicle any
function ig.func.GetVehicleMods(vehicle)
    local mods = {}
    for i = 0, 49, 1 do
        -- TODO check for 17, 19, 21 -- toggle or normal mods? -- currently not possible
        if (i == 18 or i == 20 or i == 22) then
            if (IsToggleModOn(vehicle, i)) then
                table.insert(mods, { -- 1 index
                i, -- 2 isToggledOn
                true})
            end
        else
            local modIndex = GetVehicleMod(vehicle, i)
            if (modIndex ~= -1) then
                table.insert(mods, { -- 1 index
                i, -- 2 modIndex
                modIndex})
            end
        end
    end
    return mods
end

-- apply all vehicle mods
--- func desc
---@param vehicle any
---@param mods any
---@param customFrontWheels any
---@param customRearWheels any
function ig.func.SetVehicleMods(vehicle, mods, customFrontWheels, customRearWheels)
    for i, mod in ipairs(mods) do
        local id = mod[1]
        local value = mod[2]

        -- TODO check for 17, 19, 21 -- toggle or normal mods? -- currently not possible
        if (id == 18 or id == 20 or id == 22) then
            ToggleVehicleMod(vehicle, id, value)
        else
            SetVehicleMod(vehicle, id, value, (id == 24) and customRearWheels or customFrontWheels)
        end
    end
end

-- returns all vehicle extras
--- func desc
---@param vehicle any
function ig.func.GetVehicleExtras(vehicle)
    local extras = {}
    for i = 0, 20, 1 do
        if (DoesExtraExist(vehicle, i)) then
            if (IsVehicleExtraTurnedOn(vehicle, i)) then
                table.insert(extras, { -- 1 index
                i, -- 2 isToggledOn
                0})
            else
                table.insert(extras, { -- 1 index
                i, -- 2 isToggledOn
                1})
            end
        end
    end
    return extras
end

-- apply all vehicle extras
--- func desc
---@param vehicle any
---@param extras any
function ig.func.SetVehicleExtras(vehicle, extras)
    for i, extra in ipairs(extras) do
        SetVehicleExtra(vehicle, extra[1], extra[2])
    end
end

function ig.func.SetVehicleExtrasFalse(vehicle, extras)
    for i, extra in ipairs(extras) do
        SetVehicleExtra(vehicle, extra[1], 1)
    end
end

-- returns all tire states
--- func desc
---@param vehicle any
function ig.func.GetVehicleTireStates(vehicle)
    local burstTires = {}
    for i = 0, 5, 1 do
        if (IsVehicleTyreBurst(vehicle, i, true)) then
            table.insert(burstTires, { -- 1 index
            i, -- 2 isBurst
            true})
        elseif (IsVehicleTyreBurst(vehicle, i, false)) then
            table.insert(burstTires, { -- 1 index
            i, -- 2 isBurst
            false})
        end
    end
    return burstTires
end

-- apply all tire states
--- func desc
---@param vehicle any
---@param tireStates any
function ig.func.SetVehicleTireStates(vehicle, tireStates)
    for i, tireState in ipairs(tireStates) do
        SetVehicleTyreBurst(vehicle, tireState[1], tireState[2], 1000.0)
    end
end

-- returns all door states
--- func desc
---@param vehicle any
function ig.func.GetVehicleDoorStates(vehicle)
    local doorStates = {}
    for i = 0, 7, 1 do
        if (GetIsDoorValid(vehicle, i)) then
            table.insert(doorStates, { -- 1 index
            i, -- 2 missing
            IsVehicleDoorDamaged(vehicle, i) -- 3 angle (unused, causes problems)
            -- GetVehicleDoorAngleRatio(vehicle, i)
            })
        end
    end
    return doorStates
end

-- apply all door states
--- func desc
---@param vehicle any
---@param doorStates any
function ig.func.SetVehicleDoorStates(vehicle, doorStates)
    for i, doorState in ipairs(doorStates) do
        if (doorState[2]) then
            SetVehicleDoorBroken(vehicle, doorState[1], true)
            -- elseif (doorState[3] > 0.0) then
            --	SetVehicleDoorControl(vehicle, doorState[1], 1000, doorState[3])
        end
    end
end

-- returns all window states
--- func desc
---@param vehicle any
function ig.func.GetVehicleWindowStates(vehicle)
    if (AreAllVehicleWindowsIntact(vehicle)) then
        return {}
    end
    local windowStates = {}
    for i = 0, 13, 1 do
        if (not IsVehicleWindowIntact(vehicle, i)) then
            table.insert(windowStates, i)
        end
    end
    return windowStates
end

-- apply all window states
--- func desc
---@param vehicle any
---@param windowStates any
function ig.func.SetVehicleWindowStates(vehicle, windowStates)
    for i, windowState in ipairs(windowStates) do
        SmashVehicleWindow(vehicle, windowState)
    end
end

--- func desc
---@param vehicle any
function ig.func.DeleteVehicle(vehicle)
    if (not DoesEntityExist(vehicle)) then return end
    SetEntityAsMissionEntity(vehicle,  false,  true)
    DeleteVehicle(vehicle)
end