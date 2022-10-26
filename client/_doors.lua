-- ====================================================================================--

c.door = {} -- functions
c.doors = {} -- from server

-- ====================================================================================--

--[[
[       script:ig.dev] [197] = {
[       script:ig.dev]     [1] = 89357677,
[       script:ig.dev]     [2] = 680601509,
[       script:ig.dev]     [3] = vec3(1018.692322, 67.176483, 70.010086),
[       script:ig.dev]     [4] = false,
[       script:ig.dev]     [5] = false,
[       script:ig.dev]     [6] = false,
[       script:ig.dev]     [7] = false,
[       script:ig.dev]     },
[       script:ig.dev] }
]]--

function c.door.SetDoors(doors)
    c.doors = doors
end

function c.door.ToggleLock(hash)
    --
    while DoorSystemSetOpenRatio(hash) ~= 0.0 do
        Citizen.Wait(1000)
    end
    --
    local state = DoorSystemGetDoorState(hash)
    if DoorSystemGetDoorPendingState(hash) ~- state then
        if state == 0 then
            TriggerServerEvent("Server:Doors:SetState", hash, 1)
        elseif state == 1 then 
            TriggerServerEvent("Server:Doors:SetState", hash, 0)
        end
    end
end

local door_hashes = {}

function c.door.Add(d)
    local hash, model, coords, jobs, locked, item, time = d[1], d[2], d[3], d[4], d[5], d[6], d[7]
    AddDoorToSystem(hash, model, coords.x, coords.y, coords.z, false, false, false)
    DoorSystemSetDoorState(hash, locked, 0)
    --
    if not door_hashes[model] then
        table.insert(door_hashes, model)
    end
end

function c.door.Find(d)
    local hash = d[1]
    if IsDoorRegisteredWithSystem(hash) then
        return true
    else
        return false
    end
end

--- func desc
---@param coords any
function c.door.FindHash(hash)
    for k,v in pairs(c._doors) do
        -- is the door in the table?
        if v[1] == hash then
            return true, k, v
        end
    end    
    return false, false
end

local start_scan = false
local target_cache = {}

function c.door.AddDoorsToSystem(doors)
    for k,v in pairs(doors) do
        if not c.door.Find(v) then
            c.door.Add(v)
        end
    end
    if c.doors ~= doors then
        c.door.SetDoors(doors)
    end
    start_scan = true
end

function c.door.SetDoorEntityHashInRadius(radius)
    local entities = {}
    local objs = c.func.GetObjectsInArea(GetEntityCoords(PlayerPedId()), radius, false)
    for k, v in pairs(objs) do
        if door_hashes[v.Model] then
            local bool, hash = DoorSystemFindExistingDoor(v.Coords.x, v.Coords.y, v.Coords.z, v.Model)
            if bool then
                entities[k] = hash
            end
        end
    end
    for k, v in pairs(entities) do
        if DoesEntityExist(k) and not target_cache[k] then
            --
            table.insert(target_cache, k)
            --
            local hash = v
            Entity(k).state.Hash = hash
            --
            local bool, key, values = c.door.FindHash(hash)
            --
            exports['ig.target']:AddEntityZone(joaat("DOOR_"..key), k, {
                name = joaat("DOOR_"..key),
                heading = GetEntityHeading(k),
                debugPoly = false,
            }, {
                options = {
                {
                    label = "Door",
                    info = "Lock",
                    job = values[4],
                    interact = function(entity)
                        local hash = Entity(entity).state.Hash
                        local state = DoorSystemGetDoorState(hash)
                        if state == 0 then
                            return true
                        end
                    end,
                    action = function(entity)
                        local hash = Entity(entity).state.Hash
                        c.door.ToggleLock(hash)
                    end
                },
                {
                    label = "Door",
                    info = "Unlock",
                    job = values[4],
                    interact = function(entity)
                        local hash = Entity(entity).state.Hash
                        local state = DoorSystemGetDoorState(hash)
                        if state == 1 then
                            return true
                        end
                    end,
                    action = function(entity)
                        local hash = Entity(entity).state.Hash
                        c.door.ToggleLock(hash)
                    end
                },
                {
                    label = "Door",
                    info = "Lockpick",
                    job = values[4],
                    interact = function(entity)
                        local hash = Entity(entity).state.Hash
                        local state = DoorSystemGetDoorState(hash)
                        if state == 1 then
                            local Quantity = c.inventory.GetItemQuantity("Lockpick")
                            return Quantity or false
                        end
                    end,
                    action = function(entity)
                        local hash = Entity(entity).state.Hash
                        c.door.ToggleLock(hash)
                    end
                },
            },
                distance = 3.5
            })
        end
    end
end

RegisterNetEvent("Client:Doors:Sync", function(hash, state)
    if IsDoorRegisteredWithSystem(hash) then
        DoorSystemSetDoorState(hash, state, 1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if start_scan then
            c.door.SetDoorEntityHashInRadius(50)
            Citizen.Wait(3000)
        else
            Citizen.Wait(3000)
        end
    end
end)