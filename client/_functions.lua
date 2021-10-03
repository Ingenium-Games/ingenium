-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

function c.func(...)
    local arg = {...}
    local status, val = c.err(unpack(arg))
    return val
end

function c.err(func, ...)
    local arg = {...}
    return xpcall(function()
        return c.func(unpack(arg))
    end, function(err)
        return c.error(err)
    end)
end

function c.error(err)
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

function c.debug(str)
    if conf.debug then
        print("   ^7[^6Debug^7]:  ==    ", str)
    end
end

function c.alert(str)
    print("   ^7[^3Alert^7]:  ==    ", str)
end

-- ====================================================================================--

--- Preduce a Busy Spinner
function c.IsBusy()
    BeginTextCommandBusyspinnerOn("FM_COR_AUTOD")
    EndTextCommandBusyspinnerOn(5)
end

--- Remvoe a Busy Spinner
function c.NotBusy()
    BusyspinnerOff()
    PreloadBusyspinner()
end

--- Produce a Busy Spinner with a "Please Wait"
function c.PleaseWait()
    BeginTextCommandBusyspinnerOn("PM_WAIT")
    EndTextCommandBusyspinnerOn(5)
end

--- Informs the client to Please Wait with a Busy Spinner over a timeframe.
---@param ms number "Milisecons to wait."
function c.IsBusyPleaseWait(ms)
    c.PleaseWait()
    --
    Citizen.Wait(ms)
    --
    c.NotBusy()
end

-- ====================================================================================--

--- Return the Entity"s state bag.
---@param entity any "Typically a number or string"
function c.GetEntity(entity)
    return Entity(entity).state
end

-- @entity - the object
-- @arrays - locations in a table format
-- @style - c.SelectMarker() - Pick Marker type.
function c.CompareCoords(coords, arrays, style)
    local dstchecked = 1000
    local pos = coords
    if type(arrays) == "table" then
        for i = 1, #arrays do
            local ords = arrays[i]
            local comparedst = Vdist(pos - ords)
            if comparedst < dstchecked then
                dstchecked = comparedst
            end
            if comparedst < 7.5 then
                if style then
                    c.marker.SelectMarker(style, ords)
                end
            end
        end
        return dstchecked
    else
        local comparedst = Vdist(pos - arrays)
        if comparedst < dstchecked then
            dstchecked = comparedst
        end
        if comparedst < 7.5 then
            if style then
                c.marker.SelectMarker(style, arrays)
            end
        end
        return dstchecked
    end
end

--- Returns Players within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.GetPlayersInArea(ords, radius, minimal)
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
function c.GetPedsInArea(ords, radius, minimal)
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
function c.GetObjectsInArea(ords, radius, minimal)
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
function c.GetVehiclesInArea(ords, radius, minimal)
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
function c.GetPickupsInArea(coords, radius, minimal)
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

-- returns closestPlayer, closestDistance
function c.GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    for _, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if (target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value))
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) -
                                 vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if (closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

-- returns closestVeh, closestDistance
function c.GetClosestVehicle()
    local closestDistance = -1
    local closestVeh = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    local vehicles = c.GetVehiclesInArea(plyCoords, 20)
    for _, value in ipairs(vehicles) do
        local targetCoords = GetEntityCoords(GetPlayerPed(value))
        local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) -
                             vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if (closestDistance == -1 or closestDistance > distance) then
            closestVeh = value
            closestDistance = distance
        end
    end
    return closestVeh, closestDistance
end

function c.GetVehicleInDirection()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    if hit == 1 and GetEntityType(entityHit) == 2 then
        return entityHit
    end
    return nil
end

-- https://forum.cfx.re/t/use-displayonscreenkeyboard-properly/51143

function c.Keyboard(TextEntry, ExampleText, MaxStringLenght)

    -- TextEntry		-->	The Text above the typing field in the black square
    -- ExampleText		-->	An Example Text, what it should say in the typing field
    -- MaxStringLenght	-->	Maximum String Lenght

    AddTextEntry("FMMC_KEY_TIP1", TextEntry) -- Sets the Text above the typing field in the black square
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) -- Actually calls the Keyboard Input
    blockinput = true -- Blocks new input while typing if **blockinput** is used

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do -- While typing is not aborted and not finished, this loop waits
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() -- Gets the result of the typing
        Citizen.Wait(500) -- Little Time Delay, so the Keyboard won"t open again if you press enter to finish the typing
        blockinput = false -- This unblocks new Input when typing is done
        return result -- Returns the result
    else
        Citizen.Wait(500) -- Little Time Delay, so the Keyboard won"t open again if you press enter to finish the typing
        blockinput = false -- This unblocks new Input when typing is done
        return nil -- Returns nil if the typing got aborted
    end
end

function c.CreatePed(name, x, y, z, h)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    local net = CreatePed(0, hash, x, y, z, h, true, false)
    return net
end

function c.CreateObject(name, x, y, z, isdoor)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    if type(isdoor) ~= "boolean" then
        isdoor = false
    end
    local net = CreateObject(hash, x, y, z, true, isdoor)
    return net
end

function c.CreateVehicle(name, x, y, z, h, plate, stolen)
    if plate == nil then plate = false end
    if stolen == nil then stolen = false end
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
    local entity = CreateVehicle(hash, x, y, z, h, true, false)
    local net = VehToNet(entity)
    SetVehicleOnGroundProperly(entity)
    SetVehicleHasBeenOwnedByPlayer(entity, true)
    SetNetworkIdCanMigrate(net, true)
    SetModelAsNoLongerNeeded(hash)
    if NetworkDoesEntityExistWithNetworkId(net) then
        c.debug("Entity exists on network, id: "..net.." entity: "..entity)              
        if plate then
            TriggerServerEvent("Server:VehicleData", net, plate)
        else
            TriggerServerEvent("Server:VehicleData", net, false, stolen)
        end
    else
        net = false
        c.debug("Entity DOES NOT exist on network.")
    end
    return entity, net
end

function c.SetVehicleModifications(vehicle, mods)
    SetVehicleModKit(vehicle, 0)

    if mods.Plate ~= nil then
        SetVehicleNumberPlateText(vehicle, mods.Plate)
    end

    if mods.PlateIndex ~= nil then
        SetVehicleNumberPlateTextIndex(vehicle, mods.PlateIndex)
    end

    if mods.Fuel ~= nil then
        SetVehicleFuelLevel(vehicle, mods.Fuel + 0.0)
    end

    if mods.Dirt ~= nil then
        SetVehicleDirt(vehicle, mods.Dirt + 0.0)
    end

    if mods.Colour_1 ~= nil then
        local Colour_1, Colour_2 = GetVehicleColours(vehicle)
        SetVehicleColours(vehicle, mods.Colour_1, Colour_2)
    end

    if mods.Colour_2 ~= nil then
        local Colour_1, Colour_2 = GetVehicleColours(vehicle)
        SetVehicleColours(vehicle, Colour_1, mods.Colour_2)
    end

    if mods.Pearlescent ~= nil then
        local Pearlescent, WheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleExtraColours(vehicle, mods.Pearlescent, WheelColor)
    end

    if mods.WheelColor ~= nil then
        local Pearlescent, WheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleExtraColours(vehicle, Pearlescent, mods.WheelColor)
    end

    if mods.Wheels ~= nil then
        SetVehicleWheelType(vehicle, mods.Wheels)
    end

    if mods.WindowTint ~= nil then
        SetVehicleWindowTint(vehicle, mods.WindowTint)
    end

    if mods.NeonEnabled ~= nil then
        SetVehicleNeonLightEnabled(vehicle, 0, mods.NeonEnabled[1])
        SetVehicleNeonLightEnabled(vehicle, 1, mods.NeonEnabled[2])
        SetVehicleNeonLightEnabled(vehicle, 2, mods.NeonEnabled[3])
        SetVehicleNeonLightEnabled(vehicle, 3, mods.NeonEnabled[4])
    end

    if mods.Extras ~= nil then
        for id, enabled in pairs(mods.Extras) do
            if enabled then
                SetVehicleExtra(vehicle, tonumber(id), 0)
            else
                SetVehicleExtra(vehicle, tonumber(id), 1)
            end
        end
    end

    if mods.NeonColor ~= nil then
        SetVehicleNeonLightsColour(vehicle, mods.NeonColor[1], mods.NeonColor[2], mods.NeonColor[3])
    end

    if mods.TyreSmoke ~= nil then
        ToggleVehicleMod(vehicle, 20, true)
    end

    if mods.TyreSmokeColour ~= nil then
        SetVehicleTyreSmokeColor(vehicle, mods.TyreSmokeColour[1], mods.TyreSmokeColour[2], mods.TyreSmokeColour[3])
    end

    if mods.Spoiler ~= nil then
        SetVehicleMod(vehicle, 0, mods.Spoiler, false)
    end

    if mods.FrontBumper ~= nil then
        SetVehicleMod(vehicle, 1, mods.FrontBumper, false)
    end

    if mods.RearBumper ~= nil then
        SetVehicleMod(vehicle, 2, mods.RearBumper, false)
    end

    if mods.SideSkirt ~= nil then
        SetVehicleMod(vehicle, 3, mods.SideSkirt, false)
    end

    if mods.Exhaust ~= nil then
        SetVehicleMod(vehicle, 4, mods.Exhaust, false)
    end

    if mods.Frame ~= nil then
        SetVehicleMod(vehicle, 5, mods.Frame, false)
    end

    if mods.Grille ~= nil then
        SetVehicleMod(vehicle, 6, mods.Grille, false)
    end

    if mods.Hood ~= nil then
        SetVehicleMod(vehicle, 7, mods.Hood, false)
    end

    if mods.Fender ~= nil then
        SetVehicleMod(vehicle, 8, mods.Fender, false)
    end

    if mods.RightFender ~= nil then
        SetVehicleMod(vehicle, 9, mods.RightFender, false)
    end

    if mods.Roof ~= nil then
        SetVehicleMod(vehicle, 10, mods.Roof, false)
    end

    if mods.Engine ~= nil then
        SetVehicleMod(vehicle, 11, mods.Engine, false)
    end

    if mods.Brakes ~= nil then
        SetVehicleMod(vehicle, 12, mods.Brakes, false)
    end

    if mods.Transmission ~= nil then
        SetVehicleMod(vehicle, 13, mods.Transmission, false)
    end

    if mods.Horns ~= nil then
        SetVehicleMod(vehicle, 14, mods.Horns, false)
    end

    if mods.Suspension ~= nil then
        SetVehicleMod(vehicle, 15, mods.Suspension, false)
    end

    if mods.Armor ~= nil then
        SetVehicleMod(vehicle, 16, mods.Armor, false)
    end

    if mods.Turbo ~= nil then
        ToggleVehicleMod(vehicle, 18, mods.Turbo)
    end

    if mods.Xenon ~= nil then
        ToggleVehicleMod(vehicle, 22, mods.Xenon)
    end

    if mods.FrontWheels ~= nil then
        SetVehicleMod(vehicle, 23, mods.FrontWheels, false)
    end

    if mods.BackWheels ~= nil then
        SetVehicleMod(vehicle, 24, mods.BackWheels, false)
    end

    if mods.PlateHolder ~= nil then
        SetVehicleMod(vehicle, 25, mods.PlateHolder, false)
    end

    if mods.VanityPlate ~= nil then
        SetVehicleMod(vehicle, 26, mods.VanityPlate, false)
    end

    if mods.TrimA ~= nil then
        SetVehicleMod(vehicle, 27, mods.TrimA, false)
    end

    if mods.Ornaments ~= nil then
        SetVehicleMod(vehicle, 28, mods.Ornaments, false)
    end

    if mods.Dashboard ~= nil then
        SetVehicleMod(vehicle, 29, mods.Dashboard, false)
    end

    if mods.Dial ~= nil then
        SetVehicleMod(vehicle, 30, mods.Dial, false)
    end

    if mods.DoorSpeaker ~= nil then
        SetVehicleMod(vehicle, 31, mods.DoorSpeaker, false)
    end

    if mods.Seats ~= nil then
        SetVehicleMod(vehicle, 32, mods.Seats, false)
    end

    if mods.SteeringWheel ~= nil then
        SetVehicleMod(vehicle, 33, mods.SteeringWheel, false)
    end

    if mods.ShifterLeavers ~= nil then
        SetVehicleMod(vehicle, 34, mods.ShifterLeavers, false)
    end

    if mods.APlate ~= nil then
        SetVehicleMod(vehicle, 35, mods.APlate, false)
    end

    if mods.Speakers ~= nil then
        SetVehicleMod(vehicle, 36, mods.Speakers, false)
    end

    if mods.Trunk ~= nil then
        SetVehicleMod(vehicle, 37, mods.Trunk, false)
    end

    if mods.Hydrolic ~= nil then
        SetVehicleMod(vehicle, 38, mods.Hydrolic, false)
    end

    if mods.EngineBlock ~= nil then
        SetVehicleMod(vehicle, 39, mods.EngineBlock, false)
    end

    if mods.AirFilter ~= nil then
        SetVehicleMod(vehicle, 40, mods.AirFilter, false)
    end

    if mods.Struts ~= nil then
        SetVehicleMod(vehicle, 41, mods.Struts, false)
    end

    if mods.ArchCover ~= nil then
        SetVehicleMod(vehicle, 42, mods.ArchCover, false)
    end

    if mods.Aerials ~= nil then
        SetVehicleMod(vehicle, 43, mods.Aerials, false)
    end

    if mods.TrimB ~= nil then
        SetVehicleMod(vehicle, 44, mods.TrimB, false)
    end

    if mods.Tank ~= nil then
        SetVehicleMod(vehicle, 45, mods.Tank, false)
    end

    if mods.Windows ~= nil then
        SetVehicleMod(vehicle, 46, mods.Windows, false)
    end

    if mods.Livery ~= nil then
        SetVehicleMod(vehicle, 48, mods.Livery, false)
        SetVehicleLivery(vehicle, mods.Livery)
    end
end

function c.GetVehicleModifications(vehicle)
    local Colour_1, Colour_2 = GetVehicleColours(vehicle)
    local Pearlescent, WheelColor = GetVehicleExtraColours(vehicle)
    local Extras = {}
    for id = 0, 64 do
        if DoesExtraExist(vehicle, id) then
            local state = (IsVehicleExtraTurnedOn(vehicle, id) == 1)
            Extras[tostring(id)] = state
        end
    end
    return {
        Model = GetEntityModel(vehicle),
        Plate = GetVehicleNumberPlateText(vehicle),
        PlateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        Fuel = math.ceil(GetVehicleFuelLevel(vehicle), 1),
        Dirt = math.ceil(GetVehicleDirtLevel(vehicle), 1),
        Colour_1 = Colour_1,
        Colour_2 = Colour_2,
        Pearlescent = Pearlescent,
        WheelColor = WheelColor,
        wheels = GetVehicleWheelType(vehicle),
        WindowTint = GetVehicleWindowTint(vehicle),
        NeonEnabled = {IsVehicleNeonLightEnabled(vehicle, 0), IsVehicleNeonLightEnabled(vehicle, 1),
                       IsVehicleNeonLightEnabled(vehicle, 2), IsVehicleNeonLightEnabled(vehicle, 3)},
        Extras = Extras,
        NeonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
        TyreSmokeColour = table.pack(GetVehicleTyreSmokeColor(vehicle)),
        Spoiler = GetVehicleMod(vehicle, 0),
        FrontBumper = GetVehicleMod(vehicle, 1),
        RearBumper = GetVehicleMod(vehicle, 2),
        SideSkirt = GetVehicleMod(vehicle, 3),
        Exhaust = GetVehicleMod(vehicle, 4),
        Frame = GetVehicleMod(vehicle, 5),
        Grille = GetVehicleMod(vehicle, 6),
        Hood = GetVehicleMod(vehicle, 7),
        Fender = GetVehicleMod(vehicle, 8),
        RightFender = GetVehicleMod(vehicle, 9),
        Roof = GetVehicleMod(vehicle, 10),
        Engine = GetVehicleMod(vehicle, 11),
        Brakes = GetVehicleMod(vehicle, 12),
        Transmission = GetVehicleMod(vehicle, 13),
        Horns = GetVehicleMod(vehicle, 14),
        Suspension = GetVehicleMod(vehicle, 15),
        Armor = GetVehicleMod(vehicle, 16),
        Turbo = IsToggleModOn(vehicle, 18),
        TyreSmoke = IsToggleModOn(vehicle, 20),
        Xenon = IsToggleModOn(vehicle, 22),
        FrontWheels = GetVehicleMod(vehicle, 23),
        BackWheels = GetVehicleMod(vehicle, 24),
        PlateHolder = GetVehicleMod(vehicle, 25),
        VanityPlate = GetVehicleMod(vehicle, 26),
        TrimA = GetVehicleMod(vehicle, 27),
        Ornaments = GetVehicleMod(vehicle, 28),
        Dashboard = GetVehicleMod(vehicle, 29),
        Dial = GetVehicleMod(vehicle, 30),
        DoorSpeaker = GetVehicleMod(vehicle, 31),
        Seats = GetVehicleMod(vehicle, 32),
        SteeringWheel = GetVehicleMod(vehicle, 33),
        ShifterLeavers = GetVehicleMod(vehicle, 34),
        APlate = GetVehicleMod(vehicle, 35),
        Speakers = GetVehicleMod(vehicle, 36),
        Trunk = GetVehicleMod(vehicle, 37),
        Hydrolic = GetVehicleMod(vehicle, 38),
        EngineBlock = GetVehicleMod(vehicle, 39),
        AirFilter = GetVehicleMod(vehicle, 40),
        Struts = GetVehicleMod(vehicle, 41),
        ArchCover = GetVehicleMod(vehicle, 42),
        Aerials = GetVehicleMod(vehicle, 43),
        TrimB = GetVehicleMod(vehicle, 44),
        Tank = GetVehicleMod(vehicle, 45),
        Windows = GetVehicleMod(vehicle, 46),
        Livery = GetVehicleLivery(vehicle)
    }
end

function c.GetVehicleCondition(vehicle)
    local numwheels = GetVehicleNumberOfWheels(vehicle)
    local wheels = {}
    for i = 1, numwheels, 0 do
        wheels[i] = {
            ["Burst"] = IsVehicleTyreBurst(vehicle, i, false),
            ["Gone"] = DoesVehicleTyreExist(vehicle, i),
            ["Tyre"] = GetTyreHealth(vehicle, i),
            ["Wheel"] = GetVehicleWheelHealth(vehicle, i)
        }
    end
    local numdoors = GetNumberOfVehicleDoors(vehicle)
    local doors = {}
    for i = 1, numdoors, 0 do
        doors[i] = {
            ["ConValid"] = GetIsDoorValid(vehicle, i),
            ["ConDamaged"] = IsVehicleDoorDamaged(vehicle, i)
        }
    end
    --
    return {
        ["Wheels"] = wheels,
        ["Doors"] = doors,
        ["Eng"] = GetVehicleEngineHealth(vehicle),
        ["Tank"] = GetVehiclePetrolTankHealth(vehicle),
        ["Body"] = GetVehicleBodyHealth(vehicle)
    }
end

function c.SetVehicleCondition(vehicle, cons)
    if cons.Eng ~= nil then
        SetVehicleEngineHealth(vehicle, cons.Eng)
    end
    if cons.Tank ~= nil then
        SetVehiclePetrolTankHealth(vehicle, cons.Tank)
    end
    if cons.Body ~= nil then
        SetVehicleBodyHealth(vehicle, cons.Body)
    end
    if cons.Wheels ~= nil then
        for i = 1, #cons.Wheels, 0 do
            local a, b = cons.Wheels[i]["Gone"], cons.Wheels[i]["Burst"]
            if a and b then
                SetVehicleTyreBurst(vehicle, i, true, 1000.0)
            elseif not a and b then
                SetVehicleTyreBurst(vehicle, i, false, 250.0)
            elseif not a or b then
                SetVehicleTyreFixed(vehicle, i)
            end
            SetVehicleWheelHealth(vehicle, i, cons.Wheels[i]["Wheel"])
            SetTyreHealth(vehicle, i, cons.Wheels[i]["Tyre"])
        end
    end
    if cons.Doors ~= nil then
        for i = 1, #cons.Doors, 0 do
            local a, b = cons.Doors[i]["ConValid"], cons.Doors[i]["ConDamaged"]
            if a and b then
                SetVehicleDoorBroken(vehicle, i, true)
            elseif a or b then
                SetVehicleDoorBroken(vehicle, i, false)
            end
        end
    end
end
