-- ====================================================================================--

c.func = {}

-- ====================================================================================--

--- func desc
---@param . any
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

-- ====================================================================================--

--- Preduce a Busy Spinner
--- func desc
function c.func.IsBusy()
    BeginTextCommandBusyspinnerOn("FM_COR_AUTOD")
    EndTextCommandBusyspinnerOn(5)
end

--- Remvoe a Busy Spinner
--- func desc
function c.func.NotBusy()
    BusyspinnerOff()
    PreloadBusyspinner()
end

--- Produce a Busy Spinner with a "Please Wait"
--- func desc
function c.func.PleaseWait()
    BeginTextCommandBusyspinnerOn("PM_WAIT")
    EndTextCommandBusyspinnerOn(5)
end

--- Informs the client to Please Wait with a Busy Spinner over a timeframe.
---@param ms number "Milisecons to wait."
function c.func.IsBusyPleaseWait(ms)
    c.func.PleaseWait()
    --
    Citizen.Wait(ms)
    --
    c.func.NotBusy()
end

--- func desc
---@param ms any
function c.func.FadeOut(ms)
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
function c.func.FadeIn(ms)
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
-- @style - c.SelectMarker() - Pick Marker type.
function c.func.CompareCoords(coords, arrays, style, range)
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
                    c.marker.Place(ords, style)
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
                c.marker.Place(arrays, style)
            end
        end
        return dstchecked
    end
end

--- Returns Players within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.func.GetPlayersInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool("CPed")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            if IsPedAPlayer(v) then
                local target = vector3(GetEntityCoords(v))
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
                local target = vector3(GetEntityCoords(v))
                local distance = #(target - coords)
                if distance <= radius then
                    obj[v] = {
                        ["model"] = model,
                        ["coords"] = target
                    }
                end
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns All Peds (including Players) within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.func.GetPedsInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool("CPed")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["model"] = model,
                    ["coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Objects within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.func.GetObjectsInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool("CObject")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["model"] = model,
                    ["coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Vehicles within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.func.GetVehiclesInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool("CVehicle")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["model"] = model,
                    ["coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Pickups within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.func.GetPickupsInArea(coords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool("CPickup")
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetPickupCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else
        for _, v in pairs(objs) do
            local model = GetPickupHash(v)
            local target = vector3(GetPickupCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {
                    ["model"] = model,
                    ["coords"] = target
                }
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

function c.func.GetPlayers()
    return GetActivePlayers()
end

-- returns closest, closestdist
--- func desc
function c.func.GetClosestPed()
    local closest = -1
    local closestdist = -1
    local ply = PlayerPedId()
    local coords = vector3(GetEntityCoords(ply))
    local peds = c.func.GetPedsInArea(coords, 20, true)
    for _, value in pairs(peds) do
        local targetcoords = vector3(GetEntityCoords(value))
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
function c.func.GetClosestPlayer()
    local players = GetActivePlayers()
    local closest = -1
    local closestdist = -1
    local ply = PlayerPedId()
    local coords = vector3(GetEntityCoords(ply))
    for _, value in pairs(players) do
        local target = GetPlayerPed(value)
        if target ~= ply then
            local targetcoords = vector3(GetEntityCoords(target))
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
function c.func.GetClosestVehicle()
    local closest = -1
    local closestdist = -1
    local ply = PlayerPedId()
    local coords = vector3(GetEntityCoords(ply))
    local vehicles = c.func.GetVehiclesInArea(coords, 20, true)
    for _, value in pairs(vehicles) do
        local targetcoords = vector3(GetEntityCoords(value))
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
function c.func.GetClosestPosition(positions)
    local closest = -1
    local closestdist = -1
    local count = 0
    local ply = PlayerPedId()
    local coords = vector3(GetEntityCoords(ply))
    local positions = positions
    for i=1, #positions, 1 do
        local targetcoords = vector3(positions[i].x,positions[i].y,positions[i].z)
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
function c.func.GetVehicleSeatOfPed(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
        if (GetPedInVehicleSeat(vehicle, i) == ped) then
            return i
        end
    end
    return -2
end

--- func desc
function c.func.GetEntityFromRay(flag)
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
function c.func.WaitUntilNetIdExists(networkId, timeout)
	local threshold = GetGameTimer() + (timeout or 5000)

	while (not NetworkDoesEntityExistWithNetworkId(networkId) and GetGameTimer() < threshold) do
		Citizen.Wait(0)
	end

	return NetworkDoesEntityExistWithNetworkId(networkId)
end

--- func desc
---@param entityHandle any
---@param timeout any
function c.func.WaitUntilPlayerIsOwner(entityHandle, timeout)
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
function c.func.CreatePed(name, x, y, z, h)
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
        local net = PedToNet(entity)
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
function c.func.CreateObject(name, x, y, z, isdoor)
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
        local net = ObjToNet(entity)
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
function c.func.CreateVehicle(name, x, y, z, h)
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
        local net = VehToNet(entity)
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
function c.func.IsVehicleSpawnClear(coords, radius)
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
function c.func.GetVehicleModifications(vehicle)
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
    GetVehicleNumberPlateText(vehicle), -- 2
    c.func.GetVehicleMods(vehicle), -- 3
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
    c.func.GetVehicleExtras(vehicle), -- 16
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
function c.func.SetVehicleModifications(vehicle, Modifications)
    SetVehicleModKit(vehicle, 0)
    -- 16 wheelType
    SetVehicleWheelType(vehicle, Modifications[16])
    -- 2 mods
    c.func.SetVehicleMods(vehicle, Modifications[2], Modifications[17], Modifications[18])
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
    c.func.SetVehicleExtras(vehicle, Modifications[15])
    -- 19 bulletproofTires
    SetVehicleTyresCanBurst(vehicle, not Modifications[19])
    -- 20 driftTires
    if (GetGameBuildNumber() >= 2372) then
        SetDriftTyresEnabled(vehicle, Modifications[20])
    end
    -- 1 numberPlateText
    SetVehicleNumberPlateText(vehicle, Modifications[1])
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
function c.func.GetVehicleCondition(vehicle)
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
    c.func.GetVehicleTireStates(vehicle), -- 9 door states
    c.func.GetVehicleDoorStates(vehicle), -- 10 window states
    c.func.GetVehicleWindowStates(vehicle)}
end

-- apply all vehicle status values
--- func desc
---@param vehicle any
---@param Condition any
function c.func.SetVehicleCondition(vehicle, Condition)
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
    c.func.SetVehicleTireStates(vehicle, Condition[8])
    -- 9 door states
    c.func.SetVehicleDoorStates(vehicle, Condition[9])
    -- 10 window states
    c.func.SetVehicleWindowStates(vehicle, Condition[10])
end

-- returns all non-stock vehicle mods
--- func desc
---@param vehicle any
function c.func.GetVehicleMods(vehicle)
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
function c.func.SetVehicleMods(vehicle, mods, customFrontWheels, customRearWheels)
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
function c.func.GetVehicleExtras(vehicle)
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
function c.func.SetVehicleExtras(vehicle, extras)
    for i, extra in ipairs(extras) do
        SetVehicleExtra(vehicle, extra[1], extra[2])
    end
end

function c.func.SetVehicleExtrasFalse(vehicle, extras)
    for i, extra in ipairs(extras) do
        SetVehicleExtra(vehicle, extra[1], 1)
    end
end

-- returns all tire states
--- func desc
---@param vehicle any
function c.func.GetVehicleTireStates(vehicle)
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
function c.func.SetVehicleTireStates(vehicle, tireStates)
    for i, tireState in ipairs(tireStates) do
        SetVehicleTyreBurst(vehicle, tireState[1], tireState[2], 1000.0)
    end
end

-- returns all door states
--- func desc
---@param vehicle any
function c.func.GetVehicleDoorStates(vehicle)
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
function c.func.SetVehicleDoorStates(vehicle, doorStates)
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
function c.func.GetVehicleWindowStates(vehicle)
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
function c.func.SetVehicleWindowStates(vehicle, windowStates)
    for i, windowState in ipairs(windowStates) do
        SmashVehicleWindow(vehicle, windowState)
    end
end

--- func desc
---@param vehicle any
function c.func.DeleteVehicle(vehicle)
    if (not DoesEntityExist(vehicle)) then return end
    if (GetResourceState("AdvancedParking") == "started") then
        exports["AdvancedParking"]:DeleteVehicle(vehicle)
    end
    SetEntityAsMissionEntity(vehicle,  false,  true)
    DeleteVehicle(vehicle)
end