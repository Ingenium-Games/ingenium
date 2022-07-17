-- ====================================================================================--
c.func = {}
--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--

function c.func.Func(...)
    local arg = {...}
    local status, val = c.func.Err(unpack(arg))
    return val
end

function c.func.Err(func, ...)
    local arg = {...}
    return xpcall(function()
        return c.func.Func(unpack(arg))
    end, function(err)
        return c.func.Error(err)
    end)
end

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

function c.func.Debug_1(str)
    if conf.debug_1 then
        print("   ^7[^6Debug L1^7]:  ==    ", str)
    end
end

function c.func.Debug_2(str)
    if conf.debug_2 then
        print("   ^7[^6Debug L2^7]:  ==    ", str)
    end
end

function c.func.Debug_3(str)
    if conf.debug_3 then
        print("   ^7[^6Debug L3^7]:  ==    ", str)
    end
end

function c.func.Alert(str)
    print("   ^7[^3Alert^7]:  ==    ", str)
end

-- ====================================================================================--

--- Preduce a Busy Spinner
function c.func.IsBusy()
    BeginTextCommandBusyspinnerOn("FM_COR_AUTOD")
    EndTextCommandBusyspinnerOn(5)
end

--- Remvoe a Busy Spinner
function c.func.NotBusy()
    BusyspinnerOff()
    PreloadBusyspinner()
end

--- Produce a Busy Spinner with a "Please Wait"
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
    if not range then range = 10 end
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
                    c.marker.SelectMarker(ords, style)
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
                c.marker.SelectMarker(arrays, style)
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

-- returns closest, closestdist
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

-- base events.
function c.func.GetVehicleSeatOfPed(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2, GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

function c.func.GetEntityFromRay()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local direction = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayhandle = StartShapeTestLosProbe(coords, direction, 10, ped, 0)
    local result, hit, endcoords, surface, entity = GetShapeTestResult(rayhandle)
    if result == 2 then
        if hit and entity then
            return entity, endcoords
        end
    end
    return false, false
end

function c.func.CreatePed(name, x, y, z, h)
    local hash = nil
    if type(name) == "number" then
        hash = name
    else
        hash = GetHashKey(name)
    end
    local net = CreatePed(0, hash, x, y, z, h, true, false)
    return net
end

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
    local net = CreateObject(hash, x, y, z, true, isdoor)
    return net
end

function c.func.CreateVehicle(name, x, y, z, h, data)
    local data = data or {}
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
    SetVehicleNeedsToBeHotwired(net, false)
    SetModelAsNoLongerNeeded(hash)
    if NetworkDoesEntityExistWithNetworkId(net) then
        c.func.Debug_1("Entity exists on network, id: "..net.." entity: "..entity)            
        TriggerServerCallback({eventName = "ClientCreateVehicle", args={net, data}})  
    else
        c.func.Debug_1("Entity DOES NOT exist on network.")
        DeleteEntity(entity)
        return false, false
    end
    return entity, net
end

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
    if #closeVeh > 0 then return false end
    return true
end
